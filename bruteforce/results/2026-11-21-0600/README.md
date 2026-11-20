# Fixed palettes and extremal four-cycle colorings

Write $F(n,k)$ for the maximum number of edges on $n$ vertices using at most $k$ colors when every four-cycle has four different colors. The quantity in Erdős #810 is $M(n)=F(n,n)$. The fixed-palette results below allow one to use vertex deletion without changing the color budget. [Problem statement](https://www.erdosproblems.com/810)

| Vertices | Palette | Exact maximum | Four-cycles in the witness |
| ---: | ---: | ---: | ---: |
| 13 | 14 | 49 | 265 |
| 14 | 13 | 54 | 284 |

On 13 vertices, two C checkers each ran a full, unsharded complement enumeration at 50 edges with 14 colors. Both found zero supports. There are 78 pairs, so the generator searches graphs of 28 missing pairs. A graph with more than 50 edges would yield a valid 50-edge graph by deleting edges. The 49-edge witness uses all 14 colors. [Witnesses](palette-witnesses.json) · [Complement generation and checker builds](../2026-11-21/README.md#the-upper-bound)

On 14 vertices with 13 colors, deleting any vertex leaves at most $F(13,13)=47$ edges. Each edge survives 12 of the 14 vertex deletions, so $12m\le14\cdot47$. It follows that $m\le54$. The 54-edge witness attains the bound with 13 colors. [The 13-vertex optimum](../2026-11-21/README.md) · [Witnesses](palette-witnesses.json)

The independent Python check enumerates the three possible cycles on every four-vertex set. It verifies the endpoint range, color budget, edge uniqueness, every color constraint and the reported cycle count. [Checker](check_palette.py)

```sh
python3 check_palette.py palette-witnesses.json
PRUNE_K=14 "$SCRATCH/rainbow-a" -u 13 28:28
PRUNE_K=14 "$SCRATCH/rainbow-b" -u 13 28:28
```
