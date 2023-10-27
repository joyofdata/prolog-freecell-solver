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
[c(6,ht), c(2,sd), c(3,sd)],
[c(4,ht), c(6,sd), c(5,ht)],
[c(1,sd), c(5,sd), c(1,ht)],
[c(4,sd), c(3,ht), c(2,ht)]

represents:

L1:  L2:  L3:  L4:
♠3   ♥️5   ♥️A   ♥️2
♠2   ♠6   ♠5   ♥️3
♥️6   ♥️4   ♠A   ♠4
```
```
➜ swipl -g 'fc([c(6,ht), c(2,sd), c(3,sd)], [c(4,ht), c(6,sd), c(5,ht)],
    [c(1,sd), c(5,sd), c(1,ht)], [c(4,sd), c(3,ht), c(2,ht)], S), writeln(S)' \
    -t halt freecell.pl

[c(1,sd):L3-G2,c(4,ht):L2-L3,c(6,ht):L1-F1,c(2,sd):L1-G2,c(3,sd):L1-G2,
c(4,sd):L4-G2,c(6,ht):F1-L1,c(6,sd):L2-F1,c(6,ht):L1-F2,c(6,sd):F1-L1,
c(5,ht):L2-L1,c(6,ht):F2-L2,c(5,ht):L1-F1,c(6,sd):L1-F2,c(5,ht):F1-L1,
c(6,ht):L2-F1,c(6,sd):F2-L2,c(5,ht):L1-L2,c(6,ht):F1-L1,c(5,ht):L2-F1,
...]
```
```
➜ python3 test.py

Predicate Call:  fc([c(6,sd), c(5,sd), c(3,ht)], [c(4,ht), c(5,ht), c(1,ht)],
    [c(2,sd), c(6,ht), c(1,sd)], [c(4,sd), c(3,sd), c(2,ht)], S)
Solution:  [c(6,sd):L1-F1,c(4,ht):L2-L1,c(4,sd):L4-L2,c(3,sd):L4-L1,
c(2,ht):L4-L1,c(6,sd):F1-L4,c(2,ht):L1-F1,c(4,sd):L2-F2,c(2,ht):F1-L1,
c(5,ht):L2-L4,c(1,ht):L2-G1,c(2,ht):L1-G1,c(4,sd):F2-L2,c(4,sd):L2-L4,...]
SUCCESS

Predicate Call:  fc([c(6,ht), c(2,sd), c(3,sd)], [c(4,ht), c(6,sd), c(5,ht)],
    [c(1,sd), c(5,sd), c(1,ht)], [c(4,sd), c(3,ht), c(2,ht)], S)
Solution:  [c(1,sd):L3-G2,c(4,ht):L2-L3,c(6,ht):L1-F1,c(2,sd):L1-G2,
c(3,sd):L1-G2,c(4,sd):L4-G2,c(6,ht):F1-L1,c(6,sd):L2-F1,c(6,ht):L1-F2,
c(6,sd):F1-L1,c(5,ht):L2-L1,c(6,ht):F2-L2,c(5,ht):L1-F1,c(6,sd):L1-F2,...]
SUCCESS
```

# TODOs
- ~~communicate solution~~ (#2eb054)
- ~~introduce dummy values for unified handling of empty lanes and goals~~
- ~~generate rules~~
- ~~first test suite~~
- ~~four lanes~~
- ~~introduce two colors~~
- full game
