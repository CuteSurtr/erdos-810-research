"""Write the DIMACS CNF of cnf.encode(p, target) (canonical form beta(1)=beta(2)=0, beta(3) in {0,1})."""
import sys
from cnf import encode
p, target, out = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
cnf, pool = encode(p, target)
cnf.to_file(out)
print(out, pool.top, len(cnf.clauses))
