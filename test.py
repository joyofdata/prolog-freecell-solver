import re
import subprocess as sp


def test(fc):
    pred = f"fc({str(fc['L1'])}, {str(fc['L2'])}, {str(fc['L3'])}, S)"

    print("Predicate Call: ", pred)

    try:
        res = sp.run(
            ['swipl', '-g', f"{pred},write(S)", '-t', 'halt', 'freecell.pl'],
            capture_output=True, text=True, timeout=3
        )
    except sp.TimeoutExpired as te:
        print("FAILED: Timeout")
        return
    except Exception as e:
        print("FAILED: \n", e)
        return

    solution = res.stdout

    print("Solution: ", solution)

    for step in re.finditer('(\d):([L,G,F]\d)-([L,G,F]\d)', solution):
        val = int(step.group(1))
        fr = step.group(2)
        to = step.group(3)
        val_ = fc[fr].pop(0)
        assert(val_ == val)
        fc[to].insert(0,val_)

    assert(fc["G1"] == fc["G2"] == [5,4,3,2,1])

    assert(len(fc["F1"]) == len(fc["F2"]) == 0)
    for i in range(1,4):
        assert(len(fc[f"L{i}"]) == 0)

    print("SUCCESS\n")

# TEST 1

fc = {
    "G1": [], "G2": [], "F1": [], "F2": [],
    "L1": [4,1,1],
    "L2": [3,5,2],
    "L3": [5,4,3,2],
}

test(fc)

# TEST 2

fc = {
    "G1": [], "G2": [], "F1": [], "F2": [],
    "L1": [3,2,1],
    "L2": [5,4,3,2],
    "L3": [5,4,1],
}

test(fc)
