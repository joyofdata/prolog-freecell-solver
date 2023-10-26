This FreeCell solver is (intended to be) fully declarative, only defining rules
for legal moves and the final state. Due to Prologs tendency to get stuck in its
backtracking algorithm it is necessary to keep track of past states to avoid
repetitive moves. I decided to only keep track of the lanes. That makes sense
intuitively.

Due to the large number of rules - for example 8 lanes require 8 times 7 rules
to define all legal moves between lanes I decided to generate the Prolog code
with Python. The generating Python code is designed such that it is easy to
modify it from a Prolog programming perspective.

The build process is done by `./build.sh` which executes `freecell.py` for the
code generation and `test.py` for the testing.


```
[7,4,1,6,1],[3,5,2],[6,4,3,2],[5,7] represents:

L1:  L2:  L3:  L4:
1    2    2    7
6    5    3    5
1    3    4
4         6
7         
```
```
➜ swipl -g 'fc([7,4,1,6,1],[3,5,2],[6,4,3,2],[5,7],S),writeln(S)' -t halt freecell.pl 

[6:L3-L1,3:L2-L3,5:L2-L1,2:L2-L3,5:L1-L2,5:L4-L1,5:L1-F1,6:L1-L4,5:F1-L4,7:L1-F1,
4:L1-L2,1:L1-G1,2:L3-G1,3:L3-G1,4:L2-G1,5:L2-G1,6:L1-G1,7:F1-G1,1:L1-G2,4:L3-L1,
4:L1-L2,4:L2-L4,3:L3-L1,2:L3-G2,3:L1-G2,4:L4-G2,5:L4-G2,6:L4-G2,7:L4-G2]
```
```
➜ python3 test.py

PPredicate Call:  fc([7, 4, 1, 6, 1], [3, 5, 2], [6, 4, 3, 2], [5, 7], S)
Solution:  [6:L3-L1,3:L2-L3,5:L2-L1,2:L2-L3,5:L1-L2,5:L4-L1,5:L1-F1,6:L1-L4,
5:F1-L4,7:L1-F1,4:L1-L2,1:L1-G1,2:L3-G1,3:L3-G1,4:L2-G1,5:L2-G1,6:L1-G1,7:F1-G1,
1:L1-G2,4:L3-L1,4:L1-L2,4:L2-L4,3:L3-L1,2:L3-G2,3:L1-G2,4:L4-G2,5:L4-G2,6:L4-G2,
7:L4-G2]
SUCCESS

Predicate Call:  fc([3, 2, 1, 7], [5, 7, 4, 6, 2], [5, 4, 1], [6, 3], S)
Solution:  [5:L2-L4,3:L1-F1,2:L1-F2,1:L1-G1,2:F2-G1,3:F1-G1,7:L1-F1,7:L2-L1,
4:L2-G1,5:L3-G1,6:L2-G1,7:F1-G1,4:L3-L4,1:L3-G2,2:L2-G2,7:L1-L2,7:L2-L1,7:L1-L3,
4:L4-L1,4:L1-L2,7:L3-L1,4:L2-L3,7:L1-L2,4:L3-L1,5:L4-L3,4:L1-L3,7:L2-L1,4:L3-L2,
6:L4-L1,3:L4-G2,4:L2-G2,5:L3-G2,6:L1-G2,7:L1-G2]
SUCCESS
```

# TODOs
- ~~communicate solution~~ (#2eb054)
- ~~introduce dummy values for unified handling of empty lanes and goals~~
- ~~generate rules~~
- ~~first test suite~~
- ~~four lanes~~
- introduce two colors
- full game
- switch prolog invocation to pyswip
- pytest for testing