#!/usr/bin/env python3
"""Bounded Linux overnight run. No model session is needed for shutdown.

One cyclic worker on CPU 30; one constructor on CPU 31. The independent
watchdog kills only processes carrying this run's exact environment tag.
"""
import argparse, datetime, fcntl, json, os, pathlib, resource, signal
import subprocess, sys, time

R=pathlib.Path(__file__).resolve().parents[1]
REPO=R.parents[2]
C=json.loads((R/'config.json').read_text())
epoch=lambda k:datetime.datetime.fromisoformat(C[k]).timestamp()
DEADLINE=epoch('compute_deadline_utc'); HARD=epoch('hard_stop_utc')
TAG='ERDOS810_RUN_ROOT='+str(R)

def atomic(path,obj):
    tmp=path.with_suffix('.tmp');tmp.write_text(json.dumps(obj,indent=2)+'\n');tmp.replace(path)

def tagged():
    found=[]
    for path in pathlib.Path('/proc').iterdir():
        if not path.name.isdigit():continue
        try:
            if TAG.encode() in (path/'environ').read_bytes().split(b'\0'):found.append(int(path.name))
        except (OSError,ProcessLookupError):pass
    return found

def signal_group(pid,sig):
    try:os.killpg(pid,sig)
    except ProcessLookupError:pass

def watchdog():
    while time.time()<HARD:time.sleep(min(30,HARD-time.time()))
    targets=[p for p in tagged() if p!=os.getpid()]
    for pid in targets:
        try:os.kill(pid,signal.SIGKILL)
        except ProcessLookupError:pass
    atomic(R/'logs/hard-stop.json',{'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'tagged_pids_killed':targets,'deadline_utc':C['hard_stop_utc']})

def child_limits(cpu,memory):
    os.sched_setaffinity(0,{cpu});os.nice(19)
    resource.setrlimit(resource.RLIMIT_AS,(memory,memory))
    resource.setrlimit(resource.RLIMIT_FSIZE,(2*1024**3,2*1024**3))

def cpu_ticks():
    v=list(map(int,pathlib.Path('/proc/stat').read_text().splitlines()[0].split()[1:]))
    return sum(v[:8]),v[3]+v[4]

def main():
    if time.time()>=DEADLINE:raise SystemExit('Compute deadline has expired; create a fresh run.')
    lock=(R/'logs/run.lock').open('w');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    if (R/'STOP').exists():raise SystemExit('STOP exists; not launching.')
    os.sched_setaffinity(0,{30});os.nice(19)
    env=os.environ.copy();env.update(ERDOS_CADICAL=C['cadical'],CYC_N='56',
        CYC_DEADLINE=str(DEADLINE),PYTHONDONTWRITEBYTECODE='1',ERDOS810_RUN_ROOT=str(R))
    jobs={};handles=[]
    commands={
      'cyclic':([sys.executable,str(R/'cyclic/src/resume_native.py')],30,C['proof_process_address_space_bytes']),
      'constructions':([sys.executable,str(R/'constructions/src/neighborhood.py'),'--lo','26','--hi','128',
          '--worker','0','--deadline',str(DEADLINE)],31,C['constructor_address_space_bytes'])}
    for name,(cmd,cpu,mem) in commands.items():
        log=(R/f'logs/{name}.log').open('ab');handles.append(log)
        jobs[name]=subprocess.Popen(cmd,cwd=REPO,env=env,stdin=subprocess.DEVNULL,
            stdout=log,stderr=subprocess.STDOUT,start_new_session=True,
            preexec_fn=lambda cpu=cpu,mem=mem:child_limits(cpu,mem))
    atomic(R/'logs/pids.json',{'controller':os.getpid(),'jobs':{k:v.pid for k,v in jobs.items()}})
    stopped=False;paused=False;last=cpu_ticks();last_status=0
    def stop(signum,frame):
        nonlocal stopped
        stopped=True;(R/'STOP').touch()
    signal.signal(signal.SIGTERM,stop);signal.signal(signal.SIGINT,stop)
    while any(p.poll() is None for p in jobs.values()) and not stopped and time.time()<DEADLINE:
        if (R/'STOP').exists():stopped=True;break
        now=cpu_ticks();dt=now[0]-last[0];busy=1-(now[1]-last[1])/dt if dt else 0;last=now
        constructor=jobs['constructions']
        if constructor.poll() is None:
            if busy>=.75 and not paused:signal_group(constructor.pid,signal.SIGSTOP);paused=True
            elif busy<.55 and paused:signal_group(constructor.pid,signal.SIGCONT);paused=False
        if time.time()-last_status>=30:
            atomic(R/'logs/status.json',{'phase':'running','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                'jobs':{k:{'pid':v.pid,'returncode':v.poll()} for k,v in jobs.items()},
                'sampled_system_cpu':busy,'constructor_paused':paused,'compute_deadline_utc':C['compute_deadline_utc']})
            last_status=time.time()
        time.sleep(2)
    (R/'STOP').touch()
    for p in jobs.values():
        if p.poll() is None:
            signal_group(p.pid,signal.SIGCONT);signal_group(p.pid,signal.SIGTERM)
    for p in jobs.values():
        try:p.wait(timeout=20)
        except subprocess.TimeoutExpired:signal_group(p.pid,signal.SIGKILL);p.wait(timeout=5)
    for h in handles:h.close()
    atomic(R/'logs/status.json',{'phase':'final_verification','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'jobs':{k:{'pid':v.pid,'returncode':v.returncode} for k,v in jobs.items()}})
    with (R/'logs/finalize.log').open('a') as log:
        result=subprocess.run([sys.executable,str(R/'src/finalize.py')],cwd=REPO,env=env,
            stdout=log,stderr=subprocess.STDOUT,timeout=max(1,epoch('audit_deadline_utc')-time.time()))
    atomic(R/'logs/status.json',{'phase':'finished' if result.returncode==0 else 'verification_failed',
        'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'finalize_returncode':result.returncode})
    # Only this task's files are staged. Proof archives and binaries are ignored.
    with (R/'logs/git-checkpoint.log').open('a') as log:
        branch=subprocess.check_output(['git','branch','--show-current'],cwd=REPO,text=True).strip()
        if branch!='research-2026-11-07':raise RuntimeError('Git branch changed; automatic commit skipped')
        subprocess.run(['git','add',str(R.relative_to(REPO))],cwd=REPO,stdout=log,stderr=log,check=True,timeout=30)
        staged=subprocess.run(['git','diff','--cached','--quiet','--',str(R.relative_to(REPO))],cwd=REPO)
        if staged.returncode==1:
            subprocess.run(['git','commit','--only','-m','Checkpoint bounded Linux Erdos 810 overnight run','--',str(R.relative_to(REPO))],cwd=REPO,stdout=log,stderr=log,check=True,timeout=30)
            subprocess.run(['git','push','origin','research-2026-11-07'],cwd=REPO,stdout=log,stderr=log,timeout=45)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--watchdog',action='store_true');args=ap.parse_args()
    if args.watchdog:watchdog()
    else:
        try:main()
        except Exception as exc:
            (R/'STOP').touch()
            atomic(R/'logs/controller-error.json',{'error':repr(exc),'utc':datetime.datetime.now(datetime.timezone.utc).isoformat()})
            for pid in tagged():
                if pid!=os.getpid():
                    # Preserve the separately identified hard-stop watchdog.
                    try:
                        if b'--watchdog' not in pathlib.Path(f'/proc/{pid}/cmdline').read_bytes():os.kill(pid,signal.SIGKILL)
                    except (OSError,ProcessLookupError):pass
            raise
