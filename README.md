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

L1:   L2:   L3:   L4:
♠️3   ♥️5   ♥️A   ♥️2
♠️2   ♠️6   ♠️5   ♥️3
♥️6   ♥️4   ♠️A   ♠️4
```
```
➜ swipl -g 'fc(
[c(1,dd), c(1,sd), c(9,cb), c(4,sd), c(11,sd), c(11,ht), c(13,cb)],
[c(5,ht), c(13,dd), c(12,sd), c(4,cb), c(9,ht), c(3,dd), c(12,ht)],
[c(1,ht), c(2,ht), c(3,ht), c(10,sd), c(8,sd), c(5,sd), c(8,dd)],
[c(2,dd), c(2,cb), c(3,sd), c(6,sd), c(10,cb), c(5,dd), c(12,cb)],
[c(6,ht), c(6,dd), c(8,cb), c(8,ht), c(10,dd), c(11,cb)],
[c(1,cb), c(2,sd), c(7,dd), c(3,cb), c(7,cb), c(12,dd)],
[c(5,cb), c(4,ht), c(6,cb), c(4,dd), c(10,ht), c(13,ht)],
[c(7,ht), c(9,sd), c(7,sd), c(9,dd), c(11,dd), c(13,sd)]
, S),write(S)' -t halt freecell.pl > solution_1.txt
```
[solution_1.txt](https://raw.githubusercontent.com/joyofdata/prolog-freecell-solver/full-game/solution_1.txt)

```
➜ python3 test.py

Predicate Call:  fc([c(2,ht), c(1,sd)], [c(4,ht), c(4,cb)], [c(2,dd), c(4,sd)], 
[c(4,dd), c(1,ht)], [c(3,sd), c(2,sd)], [c(3,cb), c(3,dd)], [c(1,cb), c(1,dd)], 
[c(3,ht), c(2,cb)], S)
Solution:  [c(1,cb):L7-G4,c(1,dd):L7-G1,c(2,dd):L3-G1,c(2,ht):L1-L5,c(1,sd):L1-G3,
c(4,ht):L2-L1,c(4,ht):L1-L7,c(4,cb):L2-L1,c(4,sd):L3-L2,c(4,cb):L1-L3,c(4,sd):L2-L1,
c(4,cb):L3-L2,c(4,dd):L4-L3,c(1,ht):L4-G2,c(2,ht):L5-G2,c(3,ht):L8-G2,c(4,ht):L7-G2,
c(2,cb):L8-G4,c(3,cb):L6-G4,c(3,dd):L6-G1,c(4,dd):L3-G1,c(4,cb):L2-G4,c(4,sd):L1-L2,
c(4,sd):L2-L3,c(4,sd):L3-L4,c(4,sd):L4-L6,c(3,sd):L5-L1,c(2,sd):L5-G3,c(3,sd):L1-G3,
c(4,sd):L6-G3]
SUCCESS

Predicate Call:  fc([c(1,ht), c(7,ht), c(5,ht), c(7,dd)], [c(1,cb), c(4,dd), 
c(6,ht), c(1,sd)], [c(1,dd), c(2,ht), c(7,sd), c(6,sd)], [c(7,cb), c(5,sd), 
c(3,cb), c(2,dd)], [c(6,dd), c(4,sd), c(4,cb)], [c(3,ht), c(5,dd), c(6,cb)], 
[c(2,cb), c(3,dd), c(4,ht)], [c(3,sd), c(5,cb), c(2,sd)], S)
Solution:  [c(1,dd):L3-G1,c(1,ht):L1-G2,c(2,ht):L3-G2,c(3,ht):L6-G2,c(1,cb):L2-G4,
c(2,cb):L7-G4,c(6,dd):L5-L3,c  ...  1,c(6,sd):L8-G3,c(7,dd):L8-G1,c(7,sd):L3-G3,
c(4,cb):L5-G4,c(5,cb):L2-G4,c(6,cb):L6-G4,c(7,cb):L1-G4]
SUCCESS

Predicate Call:  fc([c(6,cb), c(5,sd), c(8,sd), c(6,dd), c(9,ht)], [c(2,sd), 
c(4,ht), c(2,cb), c(1,ht), c(9,cb)], [c(3,cb), c(9,sd), c(7,dd), c(6,ht), c(8,dd)], 
[c(4,sd), c(3,sd), c(9,dd), c(3,ht), c(10,dd)], [c(4,cb), c(7,cb), c(7,sd), c(7,ht), 
c(8,ht)], [c(1,cb), c(1,sd), c(2,dd), c(10,cb), c(3,dd)], [c(1,dd), c(4,dd), c(5,ht), 
c(5,dd), c(8,cb)], [c(5,cb), c(2,ht), c(10,sd), c(6,sd), c(10,ht)], S)
Solution:  [c(1,dd):L7-G1,c(1,cb):L6-G4,c(1,sd):L6-G3,c(2,dd):L6-G1,c(2,sd):L2-G3,
c(4,ht):L2-L8,c(2,cb):L2-G4,c  ...  (10,sd):L8-L2,c(6,sd):L8-G3,c(10,ht):L8-G2,
c(7,sd):L5-G3,c(8,sd):L3-G3,c(9,sd):L1-G3,c(10,sd):L2-G3]
SUCCESS
```

# Missing Features

- Finding all or several solutions and choosing by shortness.
- If no full solution exists choose a solution that maximizes number of cards in goal.
- Allow entry of conventional ranks A,2,...,10,J,Q,K instead of 1,...,13.
- Obviously too long solutions and random utilization of the freecells due to almost total absence of strategy.
  Only "strategy" is order of rules (goals always first, free up freecells as soon as possible, etc)