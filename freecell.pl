
clr(ht, red).
clr(dd, red).
clr(sd, black).
clr(cb, black).

goal_suit(1, ht).
goal_suit(2, sd).

can_add_to_goal(Goal,Card1,Card0) :-
    Card1 \= b,
    Card1 = c(R1,S1),
    goal_suit(Goal,S1),
    (
        (Card0 = b, R1 = 1);
        (
            Card0 \= b,
            Card0 = c(R0,_),
            R1 =:= R0 + 1
        )
    ),!.

can_add_to_lane(Card1,Card0) :-
    Card1 \= b,
    Card1 = c(R1,S1),
    (
        (Card0 = b);
        (
            Card0 \= b,
            Card0 = c(R0,S0),
            R1 + 1 =:= R0,
            clr(S1,Clr1), clr(S0,Clr0), Clr1 \= Clr0
        )
    ),!.

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
    term_to_atom(Val,ValStr),
    atomic_list_concat([ValStr,':',From,'-',To], Str).

% done
% f(
%   G1, G2, F1, F2, L1, L2, L3, L4, S, P, P_)
% )
f(_,_,[],[],[b],[b],[b],[b],[],P,P).

% ==============================================================================
% freecells to goals
% ------------------------------------------------------------------------------

f([G1|G1s], G2,                                   % F1 to G1
    [F1], F2,
    L1, L2, L3, L4,
    [S_|S], P, P_
) :-
    can_add_to_goal(1,F1,G1),
    step_str(F1, 'F1', 'G1', S_),                 % string describing step
    f([F1,G1|G1s], G2,
        [], F2,
        L1, L2, L3, L4,
        S, [[L1,L2,L3,L4]|P], P_                  % steps and known states
    ),!.

f([G1|G1s], G2, F1, [F2], L1, L2, L3, L4, [S_|S], P, P_):-can_add_to_goal(1, F2, G1), step_str(F2, 'F2', 'G1', S_), f([F2, G1|G1s], G2, F1, [], L1, L2, L3, L4, S, [[L1, L2, L3, L4]|P], P_), !.
f(G1, [G2|G2s], [F1], F2, L1, L2, L3, L4, [S_|S], P, P_):-can_add_to_goal(2, F1, G2), step_str(F1, 'F1', 'G2', S_), f(G1, [F1, G2|G2s], [], F2, L1, L2, L3, L4, S, [[L1, L2, L3, L4]|P], P_), !.
f(G1, [G2|G2s], F1, [F2], L1, L2, L3, L4, [S_|S], P, P_):-can_add_to_goal(2, F2, G2), step_str(F2, 'F2', 'G2', S_), f(G1, [F2, G2|G2s], F1, [], L1, L2, L3, L4, S, [[L1, L2, L3, L4]|P], P_), !.

% ==============================================================================
% lanes to goals
% ------------------------------------------------------------------------------

f([G1|G1s], G2,                                   % L1 to G1
    F1, F2,
    [L1|L1s], L2, L3, L4,
    [S_|S], P, P_
) :-
    can_add_to_goal(1,L1,G1),
    step_str(L1, 'L1', 'G1', S_),
    f([L1,G1|G1s], G2,
        F1, F2,
        L1s, L2, L3, L4,
        S, [[L1s,L2,L3,L4]|P], P_
    ),!.

f([G1|G1s], G2, F1, F2, L1, [L2|L2s], L3, L4, [S_|S], P, P_):-can_add_to_goal(1, L2, G1), step_str(L2, 'L2', 'G1', S_), f([L2, G1|G1s], G2, F1, F2, L1, L2s, L3, L4, S, [[L1, L2s, L3, L4]|P], P_), !.
f([G1|G1s], G2, F1, F2, L1, L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_goal(1, L3, G1), step_str(L3, 'L3', 'G1', S_), f([L3, G1|G1s], G2, F1, F2, L1, L2, L3s, L4, S, [[L1, L2, L3s, L4]|P], P_), !.
f([G1|G1s], G2, F1, F2, L1, L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_goal(1, L4, G1), step_str(L4, 'L4', 'G1', S_), f([L4, G1|G1s], G2, F1, F2, L1, L2, L3, L4s, S, [[L1, L2, L3, L4s]|P], P_), !.
f(G1, [G2|G2s], F1, F2, [L1|L1s], L2, L3, L4, [S_|S], P, P_):-can_add_to_goal(2, L1, G2), step_str(L1, 'L1', 'G2', S_), f(G1, [L1, G2|G2s], F1, F2, L1s, L2, L3, L4, S, [[L1s, L2, L3, L4]|P], P_), !.
f(G1, [G2|G2s], F1, F2, L1, [L2|L2s], L3, L4, [S_|S], P, P_):-can_add_to_goal(2, L2, G2), step_str(L2, 'L2', 'G2', S_), f(G1, [L2, G2|G2s], F1, F2, L1, L2s, L3, L4, S, [[L1, L2s, L3, L4]|P], P_), !.
f(G1, [G2|G2s], F1, F2, L1, L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_goal(2, L3, G2), step_str(L3, 'L3', 'G2', S_), f(G1, [L3, G2|G2s], F1, F2, L1, L2, L3s, L4, S, [[L1, L2, L3s, L4]|P], P_), !.
f(G1, [G2|G2s], F1, F2, L1, L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_goal(2, L4, G2), step_str(L4, 'L4', 'G2', S_), f(G1, [L4, G2|G2s], F1, F2, L1, L2, L3, L4s, S, [[L1, L2, L3, L4s]|P], P_), !.

% ==============================================================================
% freecells to lanes
% ------------------------------------------------------------------------------

f(G1, G2,                                  % F1 to L1
    [F1], F2,
    [L1|L1s], L2, L3, L4,
    [S_|S], P, P_
) :-
    can_add_to_lane(F1,L1),
    \+ member([[F1,L1|L1s],L2,L3,L4],P),   % avoid repeated state
    step_str(F1, 'F1', 'L1', S_),          % step string
    f(G1, G2,
        [], F2,
        [F1,L1|L1s], L2, L3, L4,
        S, [[[F1,L1|L1s],L2,L3,L4]|P], P_
    ).

f(G1, G2, [F1], F2, L1, [L2|L2s], L3, L4, [S_|S], P, P_):-can_add_to_lane(F1, L2), \+member([L1, [F1, L2|L2s], L3, L4], P), step_str(F1, 'F1', 'L2', S_), f(G1, G2, [], F2, L1, [F1, L2|L2s], L3, L4, S, [[L1, [F1, L2|L2s], L3, L4]|P], P_).
f(G1, G2, [F1], F2, L1, L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(F1, L3), \+member([L1, L2, [F1, L3|L3s], L4], P), step_str(F1, 'F1', 'L3', S_), f(G1, G2, [], F2, L1, L2, [F1, L3|L3s], L4, S, [[L1, L2, [F1, L3|L3s], L4]|P], P_).
f(G1, G2, [F1], F2, L1, L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(F1, L4), \+member([L1, L2, L3, [F1, L4|L4s]], P), step_str(F1, 'F1', 'L4', S_), f(G1, G2, [], F2, L1, L2, L3, [F1, L4|L4s], S, [[L1, L2, L3, [F1, L4|L4s]]|P], P_).
f(G1, G2, F1, [F2], [L1|L1s], L2, L3, L4, [S_|S], P, P_):-can_add_to_lane(F2, L1), \+member([[F2, L1|L1s], L2, L3, L4], P), step_str(F2, 'F2', 'L1', S_), f(G1, G2, F1, [], [F2, L1|L1s], L2, L3, L4, S, [[[F2, L1|L1s], L2, L3, L4]|P], P_).
f(G1, G2, F1, [F2], L1, [L2|L2s], L3, L4, [S_|S], P, P_):-can_add_to_lane(F2, L2), \+member([L1, [F2, L2|L2s], L3, L4], P), step_str(F2, 'F2', 'L2', S_), f(G1, G2, F1, [], L1, [F2, L2|L2s], L3, L4, S, [[L1, [F2, L2|L2s], L3, L4]|P], P_).
f(G1, G2, F1, [F2], L1, L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(F2, L3), \+member([L1, L2, [F2, L3|L3s], L4], P), step_str(F2, 'F2', 'L3', S_), f(G1, G2, F1, [], L1, L2, [F2, L3|L3s], L4, S, [[L1, L2, [F2, L3|L3s], L4]|P], P_).
f(G1, G2, F1, [F2], L1, L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(F2, L4), \+member([L1, L2, L3, [F2, L4|L4s]], P), step_str(F2, 'F2', 'L4', S_), f(G1, G2, F1, [], L1, L2, L3, [F2, L4|L4s], S, [[L1, L2, L3, [F2, L4|L4s]]|P], P_).

% ==============================================================================
% lanes to lanes
% ------------------------------------------------------------------------------

f(G1, G2,                               % L1 to L2
    F1, F2,
    [L1|L1s], [L2|L2s], L3, L4,
    [S_|S], P, P_
) :-
    can_add_to_lane(L1,L2),
    \+ member([L1s,[L1,L2|L2s],L3,L4],P),
    step_str(L1, 'L1', 'L2', S_),
    f(G1, G2,
        F1, F2,
        L1s, [L1,L2|L2s], L3, L4,
        S, [[L1s,[L1,L2|L2s],L3,L4]|P], P_
    ).

f(G1, G2, F1, F2, [L1|L1s], L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(L1, L3), \+member([L1s, L2, [L1, L3|L3s], L4], P), step_str(L1, 'L1', 'L3', S_), f(G1, G2, F1, F2, L1s, L2, [L1, L3|L3s], L4, S, [[L1s, L2, [L1, L3|L3s], L4]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L1, L4), \+member([L1s, L2, L3, [L1, L4|L4s]], P), step_str(L1, 'L1', 'L4', S_), f(G1, G2, F1, F2, L1s, L2, L3, [L1, L4|L4s], S, [[L1s, L2, L3, [L1, L4|L4s]]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], [L2|L2s], L3, L4, [S_|S], P, P_):-can_add_to_lane(L2, L1), \+member([[L2, L1|L1s], L2s, L3, L4], P), step_str(L2, 'L2', 'L1', S_), f(G1, G2, F1, F2, [L2, L1|L1s], L2s, L3, L4, S, [[[L2, L1|L1s], L2s, L3, L4]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(L2, L3), \+member([L1, L2s, [L2, L3|L3s], L4], P), step_str(L2, 'L2', 'L3', S_), f(G1, G2, F1, F2, L1, L2s, [L2, L3|L3s], L4, S, [[L1, L2s, [L2, L3|L3s], L4]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L2, L4), \+member([L1, L2s, L3, [L2, L4|L4s]], P), step_str(L2, 'L2', 'L4', S_), f(G1, G2, F1, F2, L1, L2s, L3, [L2, L4|L4s], S, [[L1, L2s, L3, [L2, L4|L4s]]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], L2, [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(L3, L1), \+member([[L3, L1|L1s], L2, L3s, L4], P), step_str(L3, 'L3', 'L1', S_), f(G1, G2, F1, F2, [L3, L1|L1s], L2, L3s, L4, S, [[[L3, L1|L1s], L2, L3s, L4]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], [L3|L3s], L4, [S_|S], P, P_):-can_add_to_lane(L3, L2), \+member([L1, [L3, L2|L2s], L3s, L4], P), step_str(L3, 'L3', 'L2', S_), f(G1, G2, F1, F2, L1, [L3, L2|L2s], L3s, L4, S, [[L1, [L3, L2|L2s], L3s, L4]|P], P_).
f(G1, G2, F1, F2, L1, L2, [L3|L3s], [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L3, L4), \+member([L1, L2, L3s, [L3, L4|L4s]], P), step_str(L3, 'L3', 'L4', S_), f(G1, G2, F1, F2, L1, L2, L3s, [L3, L4|L4s], S, [[L1, L2, L3s, [L3, L4|L4s]]|P], P_).
f(G1, G2, F1, F2, [L1|L1s], L2, L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L4, L1), \+member([[L4, L1|L1s], L2, L3, L4s], P), step_str(L4, 'L4', 'L1', S_), f(G1, G2, F1, F2, [L4, L1|L1s], L2, L3, L4s, S, [[[L4, L1|L1s], L2, L3, L4s]|P], P_).
f(G1, G2, F1, F2, L1, [L2|L2s], L3, [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L4, L2), \+member([L1, [L4, L2|L2s], L3, L4s], P), step_str(L4, 'L4', 'L2', S_), f(G1, G2, F1, F2, L1, [L4, L2|L2s], L3, L4s, S, [[L1, [L4, L2|L2s], L3, L4s]|P], P_).
f(G1, G2, F1, F2, L1, L2, [L3|L3s], [L4|L4s], [S_|S], P, P_):-can_add_to_lane(L4, L3), \+member([L1, L2, [L4, L3|L3s], L4s], P), step_str(L4, 'L4', 'L3', S_), f(G1, G2, F1, F2, L1, L2, [L4, L3|L3s], L4s, S, [[L1, L2, [L4, L3|L3s], L4s]|P], P_).

% ==============================================================================
% lanes to freecells
% ------------------------------------------------------------------------------

f(G1, G2,                           % L1 to F1
    [], F2,
    [L1|L1s], L2, L3, L4,
    [S_|S], P, P_
) :-
    L1 \= b,
    \+ member([L1s,L2,L3,L4],P),
    step_str(L1, 'L1', 'F1', S_),
    f(G1, G2,
        [L1], F2,
        L1s, L2, L3, L4,
        S, [[L1s,L2,L3,L4]|P], P_
    ).

f(G1, G2, F1, [], [L1|L1s], L2, L3, L4, [S_|S], P, P_):-L1\=b, \+member([L1s, L2, L3, L4], P), step_str(L1, 'L1', 'F2', S_), f(G1, G2, F1, [L1], L1s, L2, L3, L4, S, [[L1s, L2, L3, L4]|P], P_).
f(G1, G2, [], F2, L1, [L2|L2s], L3, L4, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4], P), step_str(L2, 'L2', 'F1', S_), f(G1, G2, [L2], F2, L1, L2s, L3, L4, S, [[L1, L2s, L3, L4]|P], P_).
f(G1, G2, F1, [], L1, [L2|L2s], L3, L4, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4], P), step_str(L2, 'L2', 'F2', S_), f(G1, G2, F1, [L2], L1, L2s, L3, L4, S, [[L1, L2s, L3, L4]|P], P_).
f(G1, G2, [], F2, L1, L2, [L3|L3s], L4, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4], P), step_str(L3, 'L3', 'F1', S_), f(G1, G2, [L3], F2, L1, L2, L3s, L4, S, [[L1, L2, L3s, L4]|P], P_).
f(G1, G2, F1, [], L1, L2, [L3|L3s], L4, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4], P), step_str(L3, 'L3', 'F2', S_), f(G1, G2, F1, [L3], L1, L2, L3s, L4, S, [[L1, L2, L3s, L4]|P], P_).
f(G1, G2, [], F2, L1, L2, L3, [L4|L4s], [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s], P), step_str(L4, 'L4', 'F1', S_), f(G1, G2, [L4], F2, L1, L2, L3, L4s, S, [[L1, L2, L3, L4s]|P], P_).
f(G1, G2, F1, [], L1, L2, L3, [L4|L4s], [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s], P), step_str(L4, 'L4', 'F2', S_), f(G1, G2, F1, [L4], L1, L2, L3, L4s, S, [[L1, L2, L3, L4s]|P], P_).

