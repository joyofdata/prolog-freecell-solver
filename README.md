```
[4,1,1],[3,2],[5,4,3,2] represents:

L1:  L2:  L3:
1    2    2
1    3    3
4         4
          5
```
```
➜ swipl -f freecell.pl -g 'fc([4,1,1],[3,2],[5,4,3,2],S),writeln(S),halt.'

[3:L2-L1,2:L2-L1,5:L3-L2,4:L3-L2,2:L1-L3,3:L1-L2,2:L3-L2,3:L3-L1,2:L2-L1,2:L3-L2,2:L1-F1,2:L2-L1,3:L2-L3,2:F1-L3,2:L1-F1,3:L1-L2,2:F1-L2,4:L1-F1,1:L1-G1,2:L2-G1,3:L2-G1,4:F1-G1,1:L1-G2,2:L3-G2,3:L3-G2,4:L2-G2,5:L2-G1]
```
```
➜ python3 test.py

Predicate Call:  fc([4, 1, 1], [3, 5, 2], [5, 4, 3, 2], S)
Solution:  [3:L2-L1,3:L1-F1,4:L1-L2,1:L1-G1,1:L1-G2,3:F1-L1,4:L2-L3,3:L1-L3,5:L2-L1,2:L2-G1,3:L3-G1,4:L3-G1,5:L1-G1,5:L3-L1,5:L1-L2,4:L3-L1,4:L1-L2,3:L3-L1,2:L3-G2,3:L1-G2,4:L2-G2,5:L2-G2]
SUCCESS

Predicate Call:  fc([3, 2, 1], [5, 4, 3, 2], [5, 4, 1], S)
Solution:  [3:L1-F1,2:L1-F2,1:L1-G1,2:F2-G1,3:F1-G1,5:L2-L1,4:L2-G1,5:L1-G1,3:L2-L1,2:L2-L1,5:L3-L2,4:L3-L2,1:L3-G2,2:L1-G2,3:L1-G2,4:L2-G2,5:L2-G2]
SUCCESS
```