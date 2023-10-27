import re
import subprocess as sp

clr = {
    "dd": "red",
    "ht": "red",
    "sd": "black",
    "cb": "black"
}

def test(fc):
    l1 = str(fc['L1']).replace("'","")
    l2 = str(fc['L2']).replace("'","")
    l3 = str(fc['L3']).replace("'","")
    l4 = str(fc['L4']).replace("'","")

    pred = f"fc({l1}, {l2}, {l3}, {l4}, S)"

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

    for step in re.finditer('(c\((\d+),([a-z]{2})\)):([L,G,F]\d)-([L,G,F]\d)', solution):
        card = step.group(1)
        rank = int(step.group(2))
        suit = step.group(3)
        from_ = step.group(4)
        to_ = step.group(5)
        card_ = fc[from_].pop(0)
        assert(card_ == card)

        if to_ in ["L1", "L2", "L3", "L4"]:
            if len(fc[to_]) > 0:
                m = re.match("c\((\d+),([a-z]{2})\)",fc[to_][0])
                rank_prev = int(m.group(1))
                suit_prev = m.group(2)
                assert(rank_prev == rank + 1)
                assert(clr[suit_prev] != clr[suit])

        fc[to_].insert(0,card)

    assert(fc["G1"] == ["c(6,ht)","c(5,ht)","c(4,ht)","c(3,ht)","c(2,ht)","c(1,ht)"])
    assert(fc["G2"] == ["c(6,sd)","c(5,sd)","c(4,sd)","c(3,sd)","c(2,sd)","c(1,sd)"])

    assert(len(fc["F1"]) == len(fc["F2"]) == 0)
    for i in range(1,5):
        assert(len(fc[f"L{i}"]) == 0)

    print("SUCCESS\n")

# TEST 1

fc = {
    "G1": [], "G2": [], "F1": [], "F2": [],
    "L1": ['c(6,sd)', 'c(5,sd)', 'c(3,ht)'],
    "L2": ['c(4,ht)', 'c(5,ht)', 'c(1,ht)'],
    "L3": ['c(2,sd)', 'c(6,ht)', 'c(1,sd)'],
    "L4": ['c(4,sd)', 'c(3,sd)', 'c(2,ht)'],
}

test(fc)

# TEST 2

fc = {
    "G1": [], "G2": [], "F1": [], "F2": [],
    "L1": ['c(6,ht)', 'c(2,sd)', 'c(3,sd)'],
    "L2": ['c(4,ht)', 'c(6,sd)', 'c(5,ht)'],
    "L3": ['c(1,sd)', 'c(5,sd)', 'c(1,ht)'],
    "L4": ['c(4,sd)', 'c(3,ht)', 'c(2,ht)'],
}

test(fc)
