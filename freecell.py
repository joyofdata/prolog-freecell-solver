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


# not sufficient to configure those numbers.
# manual editing is still required.
num_lanes = 3
num_goals = 2
num_freecells = 2


def freecells_to_goals(num_goals, num_freecells):
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
                L1, L2, L3,
                [S_|S], P, P_
            ) :-
                ((G{g} = b, F{f} = 1); (G{g} \= b, F{f} =:= G{g} + 1)), % condition
                step_str(F{f}, 'F{f}', 'G{g}', S_),                 % string describing step
                f({G_(f,g,1)}, {G_(f,g,2)},
                    {F_(f,1)}, {F_(f,2)},
                    L1, L2, L3,
                    S, [[L1,L2,L3]|P], P_                     % steps and known states
                ),!.
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    return "\n".join(res)


def lanes_to_goals(num_goals, num_lanes):
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
                {L(l,1)}, {L(l,2)}, {L(l,3)},
                [S_|S], P, P_
            ) :-
                L{l} \= b, ((G{g} = b, L{l} = 1); (G{g} \= b, L{l} =:= G{g} + 1)),
                step_str(L{l}, 'L{l}', 'G{g}', S_),
                f({G_(g,l,1)}, {G_(g,l,2)},
                    F1, F2,
                    {L_(l,1)}, {L_(l,2)}, {L_(l,3)},
                    S, [[{L_(l,1)},{L_(l,2)},{L_(l,3)}]|P], P_
                ),!.
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    return "\n".join(res)


def freecells_to_lanes(num_freecells, num_lanes):
    F = lambda f,i: [f"F{i}",f"[F{f}]"][i==f]
    L = lambda l,i: [f"L{i}",f"[L{l}|L{l}s]"][l==i]
    
    F_ = lambda f,i: [f"F{i}","[]"][i==f]
    L_ = lambda f,l,i: [f"L{i}",f"[F{f},L{l}|L{l}s]"][i==l]
    
    res = []
    for f in range(1,num_freecells+1):
        for l in range(1,num_lanes+1):
            res0 = f"""
            f(G1, G2,                               % F{f} to L{l}
                {F(f,1)}, {F(f,2)},
                {L(l,1)}, {L(l,2)}, {L(l,3)},
                [S_|S], P, P_
            ) :-
                (L{l} = b; (L{l} \= b, F{f} + 1 =:= L{l})), % condition
                \+ member([{L_(f,l,1)},{L_(f,l,2)},{L_(f,l,3)}],P),   % avoid repeated state
                step_str(F{f}, 'F{f}', 'L{l}', S_),       % step string
                f(G1, G2,
                    {F_(f,1)}, {F_(f,2)},
                    {L_(f,l,1)}, {L_(f,l,2)}, {L_(f,l,3)},
                    S, [[{L_(f,l,1)},{L_(f,l,2)},{L_(f,l,3)}]|P], P_
                ).
            """
            res.append(re.sub("\n            ","\n",res0).lstrip())

    return "\n".join(res)

code = """
% example:
% ?- fc([4,1,1],[3,2],[5,4,3,2],S).
% S = ['3:L2-L1', '2:L2-L1', '5:L3-L2', '4:L3-L2', '2:L1-L3', '3:L1-L2', '2:L3-L2', '3:L3-L1', '2:L2-L1', '2:L3-L2',
%      '2:L1-F1', '2:L2-L1', '3:L2-L3', '2:F1-L3', '2:L1-F1', '3:L1-L2', '2:F1-L2', '4:L1-F1', '1:L1-G1', '2:L2-G1',
%      '3:L2-G1', '4:F1-G1', '1:L1-G2', '2:L3-G2', '3:L3-G2', '4:L2-G2', '5:L2-G1']

fc(L1,L2,L3,S) :-
    append(L1,[b],L1_),
    append(L2,[b],L2_),
    append(L3,[b],L3_),
    f([b],[b],[],[],L1_,L2_,L3_,S,[],_).

% G1 for Goal 1 [n,n-1,...,1]
% G2 for Goal 2 [k,k-1,...,1]
% F1 for Free Cell 1 [m]
% F2 for Free Cell 2 [m]
% L1 for Lane 1 [l1_1,...,l1_k]
% L2 for Lane 2 [l2_1,...,l2_l]
% L3 for Lane 3 [l3_1,...,l3_l]
% S for Solution
% P for Past states
% P_ for Past states accumulator

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,':',From,'-',To], Str).

% done
% f(
%   G1, G2, F1, F2, L1, L2, L3, S, P, P_)
% )
f(_,_,[],[],[b],[b],[b],[],P,P).

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

% lane to lane
f(G1, G2, F1, F2, [L1|L1s], [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, (L1 = b ; (L1 \= b, L1 =:= L2 + 1)), \+ member([[L2,L1|L1s],L2s,L3],P), step_str(L2, 'L2', 'L1', S_), f(G1, G2, F1, F2, [L2,L1|L1s], L2s, L3, S, [[[L2,L1|L1s],L2s,L3]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], [L3|L3s], [S_|S], P, P_) :- L2 \= b, (L3 = b ; (L3 \= b, L3 =:= L2 + 1)), \+ member([L1,L2s,[L2,L3|L3s]],P), step_str(L2, 'L2', 'L3', S_), f(G1, G2, F1, F2, L1, L2s, [L2,L3|L3s], S, [[L1,L2s,[L2,L3|L3s]]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], [L2|L2s], L3, [S_|S], P, P_) :- L1 \= b, (L2 = b ; (L2 \= b, L2 =:= L1 + 1)), \+ member([L1s,[L1,L2|L2s],L3],P), step_str(L1, 'L1', 'L2', S_), f(G1, G2, F1, F2, L1s, [L1,L2|L2s], L3, S, [[L1s,[L1,L2|L2s],L3]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], L2, [L3|L3s], [S_|S], P, P_) :- L1 \= b, (L3 = b ; (L3 \= b, L3 =:= L1 + 1)), \+ member([L1s,L2,[L1,L3|L3s]],P), step_str(L1, 'L1', 'L3', S_), f(G1, G2, F1, F2, L1s, L2, [L1,L3|L3s], S, [[L1s,L2,[L1,L3|L3s]]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, (L1 = b ; (L1 \= b, L1 =:= L3 + 1)), \+ member([[L3,L1|L1s],L2,L3s],P), step_str(L3, 'L3', 'L1', S_), f(G1, G2, F1, F2, [L3,L1|L1s], L2, L3s, S, [[[L3,L1|L1s],L2,L3s]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], [L3|L3s], [S_|S], P, P_) :- L3 \= b, (L2 = b ; (L2 \= b, L2 =:= L3 + 1)), \+ member([L1,[L3,L2|L2s],L3s],P), step_str(L3, 'L3', 'L2', S_), f(G1, G2, F1, F2, L1, [L3,L2|L2s], L3s, S, [[L1,[L3,L2|L2s],L3s]|P], P_).

% lanes to free cells
f(G1, G2, [], F2, [L1|L1s], L2, L3, [S_|S], P, P_) :- L1 \= b, \+ member([L1s,L2,L3],P), step_str(L1, 'L1', 'F1', S_), f(G1, G2, [L1], F2, L1s, L2, L3, S, [[L1s,L2,L3]|P], P_).
f(G1, G2, [], F2, L1, [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, \+ member([L1,L2s,L3],P), step_str(L2, 'L2', 'F1', S_), f(G1, G2, [L2], F2, L1, L2s, L3, S, [[L1,L2s,L3]|P], P_).
f(G1, G2, [], F2, L1, L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, \+ member([L1,L2,L3s],P), step_str(L3, 'L3', 'F1', S_), f(G1, G2, [L3], F2, L1, L2, L3s, S, [[L1,L2,L3s]|P], P_).
f(G1, G2, F1, [], [L1|L1s], L2, L3, [S_|S], P, P_) :- L1 \= b, \+ member([L1s,L2,L3],P), step_str(L1, 'L1', 'F2', S_), f(G1, G2, F1, [L1], L1s, L2, L3, S, [[L1s,L2,L3]|P], P_).
f(G1, G2, F1, [], L1, [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, \+ member([L1,L2s,L3],P), step_str(L2, 'L2', 'F2', S_), f(G1, G2, F1, [L2], L1, L2s, L3, S, [[L1,L2s,L3]|P], P_).
f(G1, G2, F1, [], L1, L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, \+ member([L1,L2,L3s],P), step_str(L3, 'L3', 'F2', S_), f(G1, G2, F1, [L3], L1, L2, L3s, S, [[L1,L2,L3s]|P], P_).

"""

code = (code
    .replace(
        "<FREECELLS_TO_GOALS>",
        freecells_to_goals(num_goals, num_freecells)
    )
    .replace(
        "<LANES_TO_GOALS>",
        lanes_to_goals(num_goals, num_lanes)
    )
    .replace(
        "<FREECELLS_TO_LANES>",
        freecells_to_lanes(num_freecells, num_lanes)
    )
)

print(code)
