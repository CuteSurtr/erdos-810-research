import json,sys
# txt2json.py n file  -> prints json list
n=int(sys.argv[1]); E=[list(map(int,l.split())) for l in open(sys.argv[2]) if l.strip()]
print(json.dumps({str(n):E}))
