# I could have generalized the code generation but intentionally chose not to for two main reasons:
#
# 1) The application is specifically designed targeting the usual FreeCell setup and not
#    a generalized version of it (different number of colors, lanes etc)
# 2) The purpose of the code generation is not so much for saving time but rather to
#    make the Prolog code more readable in its meta version.
#
# That's why I hard code for example L1, L2, L3, ... instead of generating that string.
#
# This approach is of experimental nature.

import re

import itertools as it


# not sufficient to configure those numbers.
# manual editing is still required.
NUM_LANES = 4
NUM_GOALS = 2
NUM_FREECELLS = 2


def _concise_format(res):
    """
    concise formatting (single line) except for the first rule which is pretty printed.
    """
    return it.chain([res[0]], map(lambda r: "".join(re.sub(r"%.*","",r).split()).replace(",",", "),res[1:]))


def freecells_to_goals(num_goals, num_freecells, concise=True):
    G = lambda g,i: [f"G{i}",f"[G{g}|G{g}s]"][i==g]
    F = lambda f,i: [f"F{i}",f"[F{f}]"][i==f]

    G_ = lambda f,g,i: [f"G{i}",f"[F{f},G{g}|G{g}s]"][i==g]
    F_ = lambda f,i: [f"F{i}","[]"][i==f]

    res = []
    for g in range(1,num_goals+1):
        for f in range(1,num_freecells+1):
            res0 = f"""
            f({G(g,1)}, {G(g,2)},                                   % F{f} to G{g}
                {F(f,1)}, {F(f,2)},
                L1, L2, L3, L4,
                [S_|S], P, P_
            ) :-
                ((G{g} = b, F{f} = 1); (G{g} \= b, F{f} =:= G{g} + 1)), % condition
                step_str(F{f}, 'F{f}', 'G{g}', S_),                 % string describing step
                f({G_(f,g,1)}, {G_(f,g,2)},
                    {F_(f,1)}, {F_(f,2)},
                    L1, L2, L3, L4,
                    S, [[L1,L2,L3,L4]|P], P_                  % steps and known states
                ),!.
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    if concise:
        res = _concise_format(res)

    return "\n".join(res)


def lanes_to_goals(num_goals, num_lanes, concise=True):
    G = lambda g,i: [f"G{i}",f"[G{g}|G{g}s]"][g==i]
    L = lambda l,i: [f"L{i}",f"[L{l}|L{l}s]"][l==i]

    G_ = lambda g,l,i: [f"G{i}",f"[L{l},G{g}|G{g}s]"][g==i]
    L_ = lambda l,i: [f"L{i}",f"L{l}s"][l==i]

    res = []
    for g in range(1,num_goals+1):
        for l in range(1,num_lanes+1):
            res0 = f"""
            f({G(g,1)}, {G(g,2)},                                   % L{l} to G{g}
                F1, F2,
                {L(l,1)}, {L(l,2)}, {L(l,3)}, {L(l,4)},
                [S_|S], P, P_
            ) :-
                L{l} \= b, ((G{g} = b, L{l} = 1); (G{g} \= b, L{l} =:= G{g} + 1)),
                step_str(L{l}, 'L{l}', 'G{g}', S_),
                f({G_(g,l,1)}, {G_(g,l,2)},
                    F1, F2,
                    {L_(l,1)}, {L_(l,2)}, {L_(l,3)}, {L_(l,4)},
                    S, [[{L_(l,1)},{L_(l,2)},{L_(l,3),{L_(l,4)}}]|P], P_
                ),!.
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    if concise:
        res = _concise_format(res)

    return "\n".join(res)


def freecells_to_lanes(num_freecells, num_lanes, concise=True):
    F = lambda f,i: [f"F{i}",f"[F{f}]"][i==f]
    L = lambda l,i: [f"L{i}",f"[L{l}|L{l}s]"][l==i]

    F_ = lambda f,i: [f"F{i}","[]"][i==f]
    L_ = lambda f,l,i: [f"L{i}",f"[F{f},L{l}|L{l}s]"][i==l]

    res = []
    for f in range(1,num_freecells+1):
        for l in range(1,num_lanes+1):
            res0 = f"""
            f(G1, G2,                                  % F{f} to L{l}
                {F(f,1)}, {F(f,2)},
                {L(l,1)}, {L(l,2)}, {L(l,3)}, {L(l,4)},
                [S_|S], P, P_
            ) :-
                (L{l} = b; (L{l} \= b, F{f} + 1 =:= L{l})),    % condition
                \+ member([{L_(f,l,1)},{L_(f,l,2)},{L_(f,l,3)},{L_(f,l,4)}],P),   % avoid repeated state
                step_str(F{f}, 'F{f}', 'L{l}', S_),          % step string
                f(G1, G2,
                    {F_(f,1)}, {F_(f,2)},
                    {L_(f,l,1)}, {L_(f,l,2)}, {L_(f,l,3)}, {L_(f,l,4)},
                    S, [[{L_(f,l,1)},{L_(f,l,2)},{L_(f,l,3)},{L_(f,l,4)}]|P], P_
                ).
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    if concise:
        res = _concise_format(res)

    return "\n".join(res)


def lanes_to_lanes(num_lanes, concise=True):
    L = lambda la,lb,i: [f"L{i}",f"[L{i}|L{i}s]"][i in [la,lb]]

    def L_(la,lb,i):
        if i == la:
            r = f"L{la}s"
        elif i == lb:
            r = f"[L{la},L{lb}|L{lb}s]"
        else:
            r = f"L{i}"
        return r

    res = []
    for la in range(1,num_lanes+1):
        for lb in range(1,num_lanes+1):
            res0 = f"""
            f(G1, G2,                               % L{la} to L{lb}
                F1, F2,
                {L(la,lb,1)}, {L(la,lb,2)}, {L(la,lb,3)}, {L(la,lb,4)},
                [S_|S], P, P_
            ) :-
                L{la} \= b, (L{lb} = b ; (L{lb} \= b, L{lb} =:= L{la} + 1)),
                \+ member([{L_(la,lb,1)},{L_(la,lb,2)},{L_(la,lb,3)},{L_(la,lb,4)}],P),
                step_str(L{la}, 'L{la}', 'L{lb}', S_),
                f(G1, G2,
                    F1, F2,
                    {L_(la,lb,1)}, {L_(la,lb,2)}, {L_(la,lb,3)}, {L_(la,lb,4)},
                    S, [[{L_(la,lb,1)},{L_(la,lb,2)},{L_(la,lb,3)},{L_(la,lb,4)}]|P], P_
                ).
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    if concise:
        res = _concise_format(res)

    return "\n".join(res)


def lanes_to_freecells(num_lanes, num_freecells, concise=True):
    L = lambda l,i: [f"L{i}",f"[L{l}|L{l}s]"][l==i]
    F = lambda f,i: [f"F{i}",f"[]"][f==i]

    L_ = lambda l,i: [f"L{i}",f"L{l}s"][l==i]
    F_ = lambda f,l,i: [f"F{i}",f"[L{l}]"][f==i]

    res = []
    for l in range(1,num_lanes+1):
        for f in range(1,num_freecells+1):
            res0 = f"""
            f(G1, G2,                           % L{l} to F{f}
                {F(f,1)}, {F(f,2)},
                {L(l,1)}, {L(l,2)}, {L(l,3)}, {L(l,4)},
                [S_|S], P, P_
            ) :-
                L{l} \= b,
                \+ member([{L_(l,1)},{L_(l,2)},{L_(l,3)},{L_(l,4)}],P),
                step_str(L{l}, 'L{l}', 'F{f}', S_),
                f(G1, G2,
                    {F_(f,l,1)}, {F_(f,l,2)},
                    {L_(l,1)}, {L_(l,2)}, {L_(l,3)}, {L_(l,4)},
                    S, [[{L_(l,1)},{L_(l,2)},{L_(l,3)},{L_(l,4)}]|P], P_
                ).
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    if concise:
        res = _concise_format(res)

    return "\n".join(res)

code = """
fc(L1,L2,L3,L4,S) :-
    append(L1,[b],L1_),
    append(L2,[b],L2_),
    append(L3,[b],L3_),
    append(L4,[b],L4_),
    f([b],[b],[],[],L1_,L2_,L3_,L4_,S,[],_).

% G1 for Goal 1 [n,n-1,...,1]
% G2 for Goal 2 [k,k-1,...,1]
% F1 for Free Cell 1 [m]
% F2 for Free Cell 2 [m]
% L1 for Lane 1 [l1_1,...,l1_k]
% L2 for Lane 2 [l2_1,...,l2_l]
% L3 for Lane 3 [l3_1,...,l3_l]
% L4 for Lane 4 [l4_1,...,l4_l]
% S for Solution
% P for Past states
% P_ for Past states accumulator

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,':',From,'-',To], Str).

% done
% f(
%   G1, G2, F1, F2, L1, L2, L3, L4, S, P, P_)
% )
f(_,_,[],[],[b],[b],[b],[b],[],P,P).

% ==============================================================================
% freecells to goals
% ------------------------------------------------------------------------------

<FREECELLS_TO_GOALS>

% ==============================================================================
% lanes to goals
% ------------------------------------------------------------------------------

<LANES_TO_GOALS>

% ==============================================================================
% freecells to lanes
% ------------------------------------------------------------------------------

<FREECELLS_TO_LANES>

% ==============================================================================
% lanes to lanes
% ------------------------------------------------------------------------------

<LANES_TO_LANES>

% ==============================================================================
% lanes to freecells
% ------------------------------------------------------------------------------

<LANES_TO_FREECELLS>
"""

code = (code
    .replace(
        "<FREECELLS_TO_GOALS>",
        freecells_to_goals(NUM_GOALS, NUM_FREECELLS)
    )
    .replace(
        "<LANES_TO_GOALS>",
        lanes_to_goals(NUM_GOALS, NUM_LANES)
    )
    .replace(
        "<FREECELLS_TO_LANES>",
        freecells_to_lanes(NUM_FREECELLS, NUM_LANES)
    )
    .replace(
        "<LANES_TO_LANES>",
        lanes_to_lanes(NUM_LANES)
    )
    .replace(
        "<LANES_TO_FREECELLS>",
        lanes_to_freecells(NUM_LANES, NUM_FREECELLS)
    )
)

print(code)
