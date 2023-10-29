import re
import subprocess as sp

clr = {
    "dd": "red",
    "ht": "red",
    "sd": "black",
    "cb": "black"
}

def test(fc, print_full_solution=False, timeout=3):
    l1 = str(fc['L1']).replace("'","")
    l2 = str(fc['L2']).replace("'","")
    l3 = str(fc['L3']).replace("'","")
    l4 = str(fc['L4']).replace("'","")
    l5 = str(fc['L5']).replace("'","")
    l6 = str(fc['L6']).replace("'","")
    l7 = str(fc['L7']).replace("'","")
    l8 = str(fc['L8']).replace("'","")

    pred = f"fc({l1}, {l2}, {l3}, {l4}, {l5}, {l6}, {l7}, {l8}, S)"

    print("Predicate Call: ", pred)

    try:
        res = sp.run(
            ['swipl', '-g', f"{pred},write(S)", '-t', 'halt', 'freecell.pl'],
            capture_output=True, text=True, timeout=timeout
        )
    except sp.TimeoutExpired as te:
        print("FAILED: Timeout")
        return
    except Exception as e:
        print("FAILED: \n", e)
        return

    solution = res.stdout

    if(print_full_solution):
        print("Solution: ", solution)
    else:
        if len(solution) < 200:
            print("Solution: ", solution)
        else:
            print("Solution: ", solution[0:100]," ... ",solution[-100:])

    for step in re.finditer('(c\((\d+),([a-z]{2})\)):([L,G,F]\d)-([L,G,F]\d)', solution):
        card = step.group(1)
        rank = int(step.group(2))
        suit = step.group(3)
        from_ = step.group(4)
        to_ = step.group(5)
        card_ = fc[from_].pop(0)
        assert(card_ == card)

        if to_ in ["L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8"]:
            if len(fc[to_]) > 0:
                m = re.match("c\((\d+),([a-z]{2})\)",fc[to_][0])
                rank_prev = int(m.group(1))
                suit_prev = m.group(2)
                assert(rank_prev == rank + 1)
                assert(clr[suit_prev] != clr[suit])

        fc[to_].insert(0,card)

    goals = [("G1","dd"),("G2","ht"),("G3","sd"),("G4","cb")]
    for g,s in goals:
        assert(fc[g] == [f"c({i},{s})" for i in range(fc["max_rank"],0,-1)])

    assert(len(fc["F1"]) == len(fc["F2"]) == 0)
    for i in range(1,5):
        assert(len(fc[f"L{i}"]) == 0)

    print("SUCCESS\n")

# TEST 1

fc = {
    "max_rank": 4,
    "G1":[], "G2":[], "G3":[], "G4":[],
    "F1":[], "F2":[], "F3":[], "F4":[],
    "L1": ['c(2,ht)', 'c(1,sd)'],
    "L2": ['c(4,ht)', 'c(4,cb)'],
    "L3": ['c(2,dd)', 'c(4,sd)'],
    "L4": ['c(4,dd)', 'c(1,ht)'],
    "L5": ['c(3,sd)', 'c(2,sd)'],
    "L6": ['c(3,cb)', 'c(3,dd)'],
    "L7": ['c(1,cb)', 'c(1,dd)'],
    "L8": ['c(3,ht)', 'c(2,cb)'],
}

test(fc, print_full_solution=True)

# TEST 2

fc = {
    "max_rank": 7,
    "G1":[], "G2":[], "G3":[], "G4":[],
    "F1":[], "F2":[], "F3":[], "F4":[],
    "L1": ['c(1,ht)', 'c(7,ht)', 'c(5,ht)', 'c(7,dd)'],
    "L2": ['c(1,cb)', 'c(4,dd)', 'c(6,ht)', 'c(1,sd)'],
    "L3": ['c(1,dd)', 'c(2,ht)', 'c(7,sd)', 'c(6,sd)'],
    "L4": ['c(7,cb)', 'c(5,sd)', 'c(3,cb)', 'c(2,dd)'],
    "L5": ['c(6,dd)', 'c(4,sd)', 'c(4,cb)'],
    "L6": ['c(3,ht)', 'c(5,dd)', 'c(6,cb)'],
    "L7": ['c(2,cb)', 'c(3,dd)', 'c(4,ht)'],
    "L8": ['c(3,sd)', 'c(5,cb)', 'c(2,sd)']
}

test(fc, print_full_solution=False)

# TEST 3

fc = {
    "max_rank": 10,
    "G1":[], "G2":[], "G3":[], "G4":[],
    "F1":[], "F2":[], "F3":[], "F4":[],
    "L1": ['c(6,cb)', 'c(5,sd)', 'c(8,sd)', 'c(6,dd)', 'c(9,ht)'],
    "L2": ['c(2,sd)', 'c(4,ht)', 'c(2,cb)', 'c(1,ht)', 'c(9,cb)'],
    "L3": ['c(3,cb)', 'c(9,sd)', 'c(7,dd)', 'c(6,ht)', 'c(8,dd)'],
    "L4": ['c(4,sd)', 'c(3,sd)', 'c(9,dd)', 'c(3,ht)', 'c(10,dd)'],
    "L5": ['c(4,cb)', 'c(7,cb)', 'c(7,sd)', 'c(7,ht)', 'c(8,ht)'],
    "L6": ['c(1,cb)', 'c(1,sd)', 'c(2,dd)', 'c(10,cb)', 'c(3,dd)'],
    "L7": ['c(1,dd)', 'c(4,dd)', 'c(5,ht)', 'c(5,dd)', 'c(8,cb)'],
    "L8": ['c(5,cb)', 'c(2,ht)', 'c(10,sd)', 'c(6,sd)', 'c(10,ht)']
}

test(fc, print_full_solution=False, timeout=10)
