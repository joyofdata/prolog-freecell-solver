
clr(ht, red).
clr(dd, red).
clr(sd, black).
clr(cb, black).

goal_suit(1, dd).
goal_suit(2, ht).
goal_suit(3, sd).
goal_suit(4, cb).

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

fc(L1,L2,L3,L4,L5,L6,L7,L8,S) :-
    append(L1,[b],L1_),
    append(L2,[b],L2_),
    append(L3,[b],L3_),
    append(L4,[b],L4_),
    append(L5,[b],L5_),
    append(L6,[b],L6_),
    append(L7,[b],L7_),
    append(L8,[b],L8_),

    f([b],[b],[b],[b],[],[],[],[],L1_,L2_,L3_,L4_,L5_,L6_,L7_,L8_,S,[],_).

% G# for Goal # [n,n-1,...,1]
% F# for Free Cell # [m]
% L# for Lane # [l#_1,...,l#_k]
% S for Solution
% P for Past states
% P_ for Past states accumulator

step_str(Val, From, To, Str) :-
    term_to_atom(Val,ValStr),
    atomic_list_concat([ValStr,':',From,'-',To], Str).

% done
% f(
%   G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, P, P_)
% )
f(_,_,_,_,[],[],[],[],[b],[b],[b],[b],[b],[b],[b],[b],[],P,P).

% ==============================================================================
% freecells to goals
% ------------------------------------------------------------------------------

f([G1|G1s], G2, G3, G4,                           % F1 to G1
    [F1], F2, F3, F4,
    L1, L2, L3, L4, L5, L6, L7, L8,
    [S_|S], P, P_
) :-
    can_add_to_goal(1,F1,G1),
    step_str(F1, 'F1', 'G1', S_),                 % string describing step
    f([F1,G1|G1s], G2, G3, G4,
        [], F2, F3, F4,
        L1, L2, L3, L4, L5, L6, L7, L8,
        S, [[L1,L2,L3,L4,L5,L6,L7,L8]|P], P_      % steps and known states
    ),!.

f([G1|G1s], G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, F2, G1), step_str(F2, 'F2', 'G1', S_), f([F2, G1|G1s], G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, F3, G1), step_str(F3, 'F3', 'G1', S_), f([F3, G1|G1s], G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, F4, G1), step_str(F4, 'F4', 'G1', S_), f([F4, G1|G1s], G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, [F1], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, F1, G2), step_str(F1, 'F1', 'G2', S_), f(G1, [F1, G2|G2s], G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, F2, G2), step_str(F2, 'F2', 'G2', S_), f(G1, [F2, G2|G2s], G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, F3, G2), step_str(F3, 'F3', 'G2', S_), f(G1, [F3, G2|G2s], G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, F4, G2), step_str(F4, 'F4', 'G2', S_), f(G1, [F4, G2|G2s], G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, [F1], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, F1, G3), step_str(F1, 'F1', 'G3', S_), f(G1, G2, [F1, G3|G3s], G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, F2, G3), step_str(F2, 'F2', 'G3', S_), f(G1, G2, [F2, G3|G3s], G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, F3, G3), step_str(F3, 'F3', 'G3', S_), f(G1, G2, [F3, G3|G3s], G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, F4, G3), step_str(F4, 'F4', 'G3', S_), f(G1, G2, [F4, G3|G3s], G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], [F1], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, F1, G4), step_str(F1, 'F1', 'G4', S_), f(G1, G2, G3, [F1, G4|G4s], [], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, F2, G4), step_str(F2, 'F2', 'G4', S_), f(G1, G2, G3, [F2, G4|G4s], F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, F3, G4), step_str(F3, 'F3', 'G4', S_), f(G1, G2, G3, [F3, G4|G4s], F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, F4, G4), step_str(F4, 'F4', 'G4', S_), f(G1, G2, G3, [F4, G4|G4s], F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, L8, S, [[L1, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.

% ==============================================================================
% lanes to goals
% ------------------------------------------------------------------------------

f([G1|G1s], G2, G3, G4,                                   % L1 to G1
    F1, F2, F3, F4,
    [L1|L1s], L2, L3, L4, L5, L6, L7, L8,
    [S_|S], P, P_
) :-
    can_add_to_goal(1,L1,G1),
    step_str(L1, 'L1', 'G1', S_),
    f([L1,G1|G1s], G2, G3, G4,
        F1, F2, F3, F4,
        L1s, L2, L3, L4, L5, L6, L7, L8,
        S, [[L1s,L2,L3,L4,L5,L6,L7,L8]|P], P_
    ),!.

f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, L2, G1), step_str(L2, 'L2', 'G1', S_), f([L2, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, L3, G1), step_str(L3, 'L3', 'G1', S_), f([L3, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, L4, G1), step_str(L4, 'L4', 'G1', S_), f([L4, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(1, L5, G1), step_str(L5, 'L5', 'G1', S_), f([L5, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_goal(1, L6, G1), step_str(L6, 'L6', 'G1', S_), f([L6, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_goal(1, L7, G1), step_str(L7, 'L7', 'G1', S_), f([L7, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_), !.
f([G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_goal(1, L8, G1), step_str(L8, 'L8', 'G1', S_), f([L8, G1|G1s], G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L1, G2), step_str(L1, 'L1', 'G2', S_), f(G1, [L1, G2|G2s], G3, G4, F1, F2, F3, F4, L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L2, G2), step_str(L2, 'L2', 'G2', S_), f(G1, [L2, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L3, G2), step_str(L3, 'L3', 'G2', S_), f(G1, [L3, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L4, G2), step_str(L4, 'L4', 'G2', S_), f(G1, [L4, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L5, G2), step_str(L5, 'L5', 'G2', S_), f(G1, [L5, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_goal(2, L6, G2), step_str(L6, 'L6', 'G2', S_), f(G1, [L6, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_goal(2, L7, G2), step_str(L7, 'L7', 'G2', S_), f(G1, [L7, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_), !.
f(G1, [G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_goal(2, L8, G2), step_str(L8, 'L8', 'G2', S_), f(G1, [L8, G2|G2s], G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L1, G3), step_str(L1, 'L1', 'G3', S_), f(G1, G2, [L1, G3|G3s], G4, F1, F2, F3, F4, L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L2, G3), step_str(L2, 'L2', 'G3', S_), f(G1, G2, [L2, G3|G3s], G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L3, G3), step_str(L3, 'L3', 'G3', S_), f(G1, G2, [L3, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L4, G3), step_str(L4, 'L4', 'G3', S_), f(G1, G2, [L4, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L5, G3), step_str(L5, 'L5', 'G3', S_), f(G1, G2, [L5, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_goal(3, L6, G3), step_str(L6, 'L6', 'G3', S_), f(G1, G2, [L6, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_goal(3, L7, G3), step_str(L7, 'L7', 'G3', S_), f(G1, G2, [L7, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_), !.
f(G1, G2, [G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_goal(3, L8, G3), step_str(L8, 'L8', 'G3', S_), f(G1, G2, [L8, G3|G3s], G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L1, G4), step_str(L1, 'L1', 'G4', S_), f(G1, G2, G3, [L1, G4|G4s], F1, F2, F3, F4, L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L2, G4), step_str(L2, 'L2', 'G4', S_), f(G1, G2, G3, [L2, G4|G4s], F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L3, G4), step_str(L3, 'L3', 'G4', S_), f(G1, G2, G3, [L3, G4|G4s], F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L4, G4), step_str(L4, 'L4', 'G4', S_), f(G1, G2, G3, [L4, G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L5, G4), step_str(L5, 'L5', 'G4', S_), f(G1, G2, G3, [L5, G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_goal(4, L6, G4), step_str(L6, 'L6', 'G4', S_), f(G1, G2, G3, [L6, G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_goal(4, L7, G4), step_str(L7, 'L7', 'G4', S_), f(G1, G2, G3, [L7, G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_), !.
f(G1, G2, G3, [G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_goal(4, L8, G4), step_str(L8, 'L8', 'G4', S_), f(G1, G2, G3, [L8, G4|G4s], F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_), !.

% ==============================================================================
% freecells to lanes
% ------------------------------------------------------------------------------

f(G1, G2, G3, G4,                                      % F1 to L1
    [F1], F2, F3, F4,
    [L1|L1s], L2, L3, L4, L5, L6, L7, L8,
    [S_|S], P, P_
) :-
    can_add_to_lane(F1,L1),
    \+ member([[F1,L1|L1s],L2,L3,L4,L5,L6,L7,L8],P),   % avoid repeated state
    step_str(F1, 'F1', 'L1', S_),                      % step string
    f(G1, G2, G3, G4,
        [], F2, F3, F4,
        [F1,L1|L1s], L2, L3, L4, L5, L6, L7, L8,
        S, [[[F1,L1|L1s],L2,L3,L4,L5,L6,L7,L8]|P], P_
    ).

f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F1, L2), \+member([L1, [F1, L2|L2s], L3, L4, L5, L6, L7, L8], P), step_str(F1, 'F1', 'L2', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, [F1, L2|L2s], L3, L4, L5, L6, L7, L8, S, [[L1, [F1, L2|L2s], L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F1, L3), \+member([L1, L2, [F1, L3|L3s], L4, L5, L6, L7, L8], P), step_str(F1, 'F1', 'L3', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, [F1, L3|L3s], L4, L5, L6, L7, L8, S, [[L1, L2, [F1, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F1, L4), \+member([L1, L2, L3, [F1, L4|L4s], L5, L6, L7, L8], P), step_str(F1, 'F1', 'L4', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, [F1, L4|L4s], L5, L6, L7, L8, S, [[L1, L2, L3, [F1, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F1, L5), \+member([L1, L2, L3, L4, [F1, L5|L5s], L6, L7, L8], P), step_str(F1, 'F1', 'L5', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, [F1, L5|L5s], L6, L7, L8, S, [[L1, L2, L3, L4, [F1, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(F1, L6), \+member([L1, L2, L3, L4, L5, [F1, L6|L6s], L7, L8], P), step_str(F1, 'F1', 'L6', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, [F1, L6|L6s], L7, L8, S, [[L1, L2, L3, L4, L5, [F1, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(F1, L7), \+member([L1, L2, L3, L4, L5, L6, [F1, L7|L7s], L8], P), step_str(F1, 'F1', 'L7', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, [F1, L7|L7s], L8, S, [[L1, L2, L3, L4, L5, L6, [F1, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, [F1], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(F1, L8), \+member([L1, L2, L3, L4, L5, L6, L7, [F1, L8|L8s]], P), step_str(F1, 'F1', 'L8', S_), f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [F1, L8|L8s], S, [[L1, L2, L3, L4, L5, L6, L7, [F1, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L1), \+member([[F2, L1|L1s], L2, L3, L4, L5, L6, L7, L8], P), step_str(F2, 'F2', 'L1', S_), f(G1, G2, G3, G4, F1, [], F3, F4, [F2, L1|L1s], L2, L3, L4, L5, L6, L7, L8, S, [[[F2, L1|L1s], L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L2), \+member([L1, [F2, L2|L2s], L3, L4, L5, L6, L7, L8], P), step_str(F2, 'F2', 'L2', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, [F2, L2|L2s], L3, L4, L5, L6, L7, L8, S, [[L1, [F2, L2|L2s], L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L3), \+member([L1, L2, [F2, L3|L3s], L4, L5, L6, L7, L8], P), step_str(F2, 'F2', 'L3', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, [F2, L3|L3s], L4, L5, L6, L7, L8, S, [[L1, L2, [F2, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L4), \+member([L1, L2, L3, [F2, L4|L4s], L5, L6, L7, L8], P), step_str(F2, 'F2', 'L4', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, [F2, L4|L4s], L5, L6, L7, L8, S, [[L1, L2, L3, [F2, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L5), \+member([L1, L2, L3, L4, [F2, L5|L5s], L6, L7, L8], P), step_str(F2, 'F2', 'L5', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, [F2, L5|L5s], L6, L7, L8, S, [[L1, L2, L3, L4, [F2, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(F2, L6), \+member([L1, L2, L3, L4, L5, [F2, L6|L6s], L7, L8], P), step_str(F2, 'F2', 'L6', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, [F2, L6|L6s], L7, L8, S, [[L1, L2, L3, L4, L5, [F2, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(F2, L7), \+member([L1, L2, L3, L4, L5, L6, [F2, L7|L7s], L8], P), step_str(F2, 'F2', 'L7', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, [F2, L7|L7s], L8, S, [[L1, L2, L3, L4, L5, L6, [F2, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, [F2], F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(F2, L8), \+member([L1, L2, L3, L4, L5, L6, L7, [F2, L8|L8s]], P), step_str(F2, 'F2', 'L8', S_), f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, [F2, L8|L8s], S, [[L1, L2, L3, L4, L5, L6, L7, [F2, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L1), \+member([[F3, L1|L1s], L2, L3, L4, L5, L6, L7, L8], P), step_str(F3, 'F3', 'L1', S_), f(G1, G2, G3, G4, F1, F2, [], F4, [F3, L1|L1s], L2, L3, L4, L5, L6, L7, L8, S, [[[F3, L1|L1s], L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L2), \+member([L1, [F3, L2|L2s], L3, L4, L5, L6, L7, L8], P), step_str(F3, 'F3', 'L2', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, [F3, L2|L2s], L3, L4, L5, L6, L7, L8, S, [[L1, [F3, L2|L2s], L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L3), \+member([L1, L2, [F3, L3|L3s], L4, L5, L6, L7, L8], P), step_str(F3, 'F3', 'L3', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, [F3, L3|L3s], L4, L5, L6, L7, L8, S, [[L1, L2, [F3, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L4), \+member([L1, L2, L3, [F3, L4|L4s], L5, L6, L7, L8], P), step_str(F3, 'F3', 'L4', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, [F3, L4|L4s], L5, L6, L7, L8, S, [[L1, L2, L3, [F3, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L5), \+member([L1, L2, L3, L4, [F3, L5|L5s], L6, L7, L8], P), step_str(F3, 'F3', 'L5', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, [F3, L5|L5s], L6, L7, L8, S, [[L1, L2, L3, L4, [F3, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(F3, L6), \+member([L1, L2, L3, L4, L5, [F3, L6|L6s], L7, L8], P), step_str(F3, 'F3', 'L6', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, [F3, L6|L6s], L7, L8, S, [[L1, L2, L3, L4, L5, [F3, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(F3, L7), \+member([L1, L2, L3, L4, L5, L6, [F3, L7|L7s], L8], P), step_str(F3, 'F3', 'L7', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, [F3, L7|L7s], L8, S, [[L1, L2, L3, L4, L5, L6, [F3, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [F3], F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(F3, L8), \+member([L1, L2, L3, L4, L5, L6, L7, [F3, L8|L8s]], P), step_str(F3, 'F3', 'L8', S_), f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, [F3, L8|L8s], S, [[L1, L2, L3, L4, L5, L6, L7, [F3, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L1), \+member([[F4, L1|L1s], L2, L3, L4, L5, L6, L7, L8], P), step_str(F4, 'F4', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, [], [F4, L1|L1s], L2, L3, L4, L5, L6, L7, L8, S, [[[F4, L1|L1s], L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L2), \+member([L1, [F4, L2|L2s], L3, L4, L5, L6, L7, L8], P), step_str(F4, 'F4', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, [F4, L2|L2s], L3, L4, L5, L6, L7, L8, S, [[L1, [F4, L2|L2s], L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L3), \+member([L1, L2, [F4, L3|L3s], L4, L5, L6, L7, L8], P), step_str(F4, 'F4', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, [F4, L3|L3s], L4, L5, L6, L7, L8, S, [[L1, L2, [F4, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L4), \+member([L1, L2, L3, [F4, L4|L4s], L5, L6, L7, L8], P), step_str(F4, 'F4', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, [F4, L4|L4s], L5, L6, L7, L8, S, [[L1, L2, L3, [F4, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L5), \+member([L1, L2, L3, L4, [F4, L5|L5s], L6, L7, L8], P), step_str(F4, 'F4', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, [F4, L5|L5s], L6, L7, L8, S, [[L1, L2, L3, L4, [F4, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(F4, L6), \+member([L1, L2, L3, L4, L5, [F4, L6|L6s], L7, L8], P), step_str(F4, 'F4', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, [F4, L6|L6s], L7, L8, S, [[L1, L2, L3, L4, L5, [F4, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(F4, L7), \+member([L1, L2, L3, L4, L5, L6, [F4, L7|L7s], L8], P), step_str(F4, 'F4', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, [F4, L7|L7s], L8, S, [[L1, L2, L3, L4, L5, L6, [F4, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [F4], L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(F4, L8), \+member([L1, L2, L3, L4, L5, L6, L7, [F4, L8|L8s]], P), step_str(F4, 'F4', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, [F4, L8|L8s], S, [[L1, L2, L3, L4, L5, L6, L7, [F4, L8|L8s]]|P], P_).

% ==============================================================================
% lanes to lanes
% ------------------------------------------------------------------------------

f(G1, G2, G3, G4,                               % L1 to L2
    F1, F2, F3, F4,
    [L1|L1s], [L2|L2s], L3, L4, L5, L6, L7, L8,
    [S_|S], P, P_
) :-
    can_add_to_lane(L1,L2),
    \+ member([L1s,[L1,L2|L2s],L3,L4,L5,L6,L7,L8],P),
    step_str(L1, 'L1', 'L2', S_),
    f(G1, G2, G3, G4,
        F1, F2, F3, F4,
        L1s, [L1,L2|L2s], L3, L4, L5, L6, L7, L8,
        S, [[L1s,[L1,L2|L2s],L3,L4,L5,L6,L7,L8]|P], P_
    ).

f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L1, L3), \+member([L1s, L2, [L1, L3|L3s], L4, L5, L6, L7, L8], P), step_str(L1, 'L1', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, [L1, L3|L3s], L4, L5, L6, L7, L8, S, [[L1s, L2, [L1, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L1, L4), \+member([L1s, L2, L3, [L1, L4|L4s], L5, L6, L7, L8], P), step_str(L1, 'L1', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, L3, [L1, L4|L4s], L5, L6, L7, L8, S, [[L1s, L2, L3, [L1, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L1, L5), \+member([L1s, L2, L3, L4, [L1, L5|L5s], L6, L7, L8], P), step_str(L1, 'L1', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, L3, L4, [L1, L5|L5s], L6, L7, L8, S, [[L1s, L2, L3, L4, [L1, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L1, L6), \+member([L1s, L2, L3, L4, L5, [L1, L6|L6s], L7, L8], P), step_str(L1, 'L1', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, L3, L4, L5, [L1, L6|L6s], L7, L8, S, [[L1s, L2, L3, L4, L5, [L1, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L1, L7), \+member([L1s, L2, L3, L4, L5, L6, [L1, L7|L7s], L8], P), step_str(L1, 'L1', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, L3, L4, L5, L6, [L1, L7|L7s], L8, S, [[L1s, L2, L3, L4, L5, L6, [L1, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L1, L8), \+member([L1s, L2, L3, L4, L5, L6, L7, [L1, L8|L8s]], P), step_str(L1, 'L1', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1s, L2, L3, L4, L5, L6, L7, [L1, L8|L8s], S, [[L1s, L2, L3, L4, L5, L6, L7, [L1, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L2, L1), \+member([[L2, L1|L1s], L2s, L3, L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L2, L1|L1s], L2s, L3, L4, L5, L6, L7, L8, S, [[[L2, L1|L1s], L2s, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L2, L3), \+member([L1, L2s, [L2, L3|L3s], L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, [L2, L3|L3s], L4, L5, L6, L7, L8, S, [[L1, L2s, [L2, L3|L3s], L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L2, L4), \+member([L1, L2s, L3, [L2, L4|L4s], L5, L6, L7, L8], P), step_str(L2, 'L2', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, [L2, L4|L4s], L5, L6, L7, L8, S, [[L1, L2s, L3, [L2, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L2, L5), \+member([L1, L2s, L3, L4, [L2, L5|L5s], L6, L7, L8], P), step_str(L2, 'L2', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, [L2, L5|L5s], L6, L7, L8, S, [[L1, L2s, L3, L4, [L2, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L2, L6), \+member([L1, L2s, L3, L4, L5, [L2, L6|L6s], L7, L8], P), step_str(L2, 'L2', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, [L2, L6|L6s], L7, L8, S, [[L1, L2s, L3, L4, L5, [L2, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L2, L7), \+member([L1, L2s, L3, L4, L5, L6, [L2, L7|L7s], L8], P), step_str(L2, 'L2', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, [L2, L7|L7s], L8, S, [[L1, L2s, L3, L4, L5, L6, [L2, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L2, L8), \+member([L1, L2s, L3, L4, L5, L6, L7, [L2, L8|L8s]], P), step_str(L2, 'L2', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, [L2, L8|L8s], S, [[L1, L2s, L3, L4, L5, L6, L7, [L2, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L3, L1), \+member([[L3, L1|L1s], L2, L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L3, L1|L1s], L2, L3s, L4, L5, L6, L7, L8, S, [[[L3, L1|L1s], L2, L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L3, L2), \+member([L1, [L3, L2|L2s], L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L3, L2|L2s], L3s, L4, L5, L6, L7, L8, S, [[L1, [L3, L2|L2s], L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L3, L4), \+member([L1, L2, L3s, [L3, L4|L4s], L5, L6, L7, L8], P), step_str(L3, 'L3', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, [L3, L4|L4s], L5, L6, L7, L8, S, [[L1, L2, L3s, [L3, L4|L4s], L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L3, L5), \+member([L1, L2, L3s, L4, [L3, L5|L5s], L6, L7, L8], P), step_str(L3, 'L3', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, [L3, L5|L5s], L6, L7, L8, S, [[L1, L2, L3s, L4, [L3, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L3, L6), \+member([L1, L2, L3s, L4, L5, [L3, L6|L6s], L7, L8], P), step_str(L3, 'L3', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, [L3, L6|L6s], L7, L8, S, [[L1, L2, L3s, L4, L5, [L3, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L3, L7), \+member([L1, L2, L3s, L4, L5, L6, [L3, L7|L7s], L8], P), step_str(L3, 'L3', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, [L3, L7|L7s], L8, S, [[L1, L2, L3s, L4, L5, L6, [L3, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L3, L8), \+member([L1, L2, L3s, L4, L5, L6, L7, [L3, L8|L8s]], P), step_str(L3, 'L3', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, [L3, L8|L8s], S, [[L1, L2, L3s, L4, L5, L6, L7, [L3, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L4, L1), \+member([[L4, L1|L1s], L2, L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L4, L1|L1s], L2, L3, L4s, L5, L6, L7, L8, S, [[[L4, L1|L1s], L2, L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L4, L2), \+member([L1, [L4, L2|L2s], L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L4, L2|L2s], L3, L4s, L5, L6, L7, L8, S, [[L1, [L4, L2|L2s], L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L4, L3), \+member([L1, L2, [L4, L3|L3s], L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L4, L3|L3s], L4s, L5, L6, L7, L8, S, [[L1, L2, [L4, L3|L3s], L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L4, L5), \+member([L1, L2, L3, L4s, [L4, L5|L5s], L6, L7, L8], P), step_str(L4, 'L4', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, [L4, L5|L5s], L6, L7, L8, S, [[L1, L2, L3, L4s, [L4, L5|L5s], L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L4, L6), \+member([L1, L2, L3, L4s, L5, [L4, L6|L6s], L7, L8], P), step_str(L4, 'L4', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, [L4, L6|L6s], L7, L8, S, [[L1, L2, L3, L4s, L5, [L4, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L4, L7), \+member([L1, L2, L3, L4s, L5, L6, [L4, L7|L7s], L8], P), step_str(L4, 'L4', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, [L4, L7|L7s], L8, S, [[L1, L2, L3, L4s, L5, L6, [L4, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L4, L8), \+member([L1, L2, L3, L4s, L5, L6, L7, [L4, L8|L8s]], P), step_str(L4, 'L4', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, [L4, L8|L8s], S, [[L1, L2, L3, L4s, L5, L6, L7, [L4, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L5, L1), \+member([[L5, L1|L1s], L2, L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L5, L1|L1s], L2, L3, L4, L5s, L6, L7, L8, S, [[[L5, L1|L1s], L2, L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L5, L2), \+member([L1, [L5, L2|L2s], L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L5, L2|L2s], L3, L4, L5s, L6, L7, L8, S, [[L1, [L5, L2|L2s], L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L5, L3), \+member([L1, L2, [L5, L3|L3s], L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L5, L3|L3s], L4, L5s, L6, L7, L8, S, [[L1, L2, [L5, L3|L3s], L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], [L5|L5s], L6, L7, L8, [S_|S], P, P_):-can_add_to_lane(L5, L4), \+member([L1, L2, L3, [L5, L4|L4s], L5s, L6, L7, L8], P), step_str(L5, 'L5', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L5, L4|L4s], L5s, L6, L7, L8, S, [[L1, L2, L3, [L5, L4|L4s], L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L5, L6), \+member([L1, L2, L3, L4, L5s, [L5, L6|L6s], L7, L8], P), step_str(L5, 'L5', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, [L5, L6|L6s], L7, L8, S, [[L1, L2, L3, L4, L5s, [L5, L6|L6s], L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L5, L7), \+member([L1, L2, L3, L4, L5s, L6, [L5, L7|L7s], L8], P), step_str(L5, 'L5', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, [L5, L7|L7s], L8, S, [[L1, L2, L3, L4, L5s, L6, [L5, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L5, L8), \+member([L1, L2, L3, L4, L5s, L6, L7, [L5, L8|L8s]], P), step_str(L5, 'L5', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, [L5, L8|L8s], S, [[L1, L2, L3, L4, L5s, L6, L7, [L5, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L6, L1), \+member([[L6, L1|L1s], L2, L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L6, L1|L1s], L2, L3, L4, L5, L6s, L7, L8, S, [[[L6, L1|L1s], L2, L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L6, L2), \+member([L1, [L6, L2|L2s], L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L6, L2|L2s], L3, L4, L5, L6s, L7, L8, S, [[L1, [L6, L2|L2s], L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L6, L3), \+member([L1, L2, [L6, L3|L3s], L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L6, L3|L3s], L4, L5, L6s, L7, L8, S, [[L1, L2, [L6, L3|L3s], L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L6, L4), \+member([L1, L2, L3, [L6, L4|L4s], L5, L6s, L7, L8], P), step_str(L6, 'L6', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L6, L4|L4s], L5, L6s, L7, L8, S, [[L1, L2, L3, [L6, L4|L4s], L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], [L6|L6s], L7, L8, [S_|S], P, P_):-can_add_to_lane(L6, L5), \+member([L1, L2, L3, L4, [L6, L5|L5s], L6s, L7, L8], P), step_str(L6, 'L6', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L6, L5|L5s], L6s, L7, L8, S, [[L1, L2, L3, L4, [L6, L5|L5s], L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L6, L7), \+member([L1, L2, L3, L4, L5, L6s, [L6, L7|L7s], L8], P), step_str(L6, 'L6', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, [L6, L7|L7s], L8, S, [[L1, L2, L3, L4, L5, L6s, [L6, L7|L7s], L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L6, L8), \+member([L1, L2, L3, L4, L5, L6s, L7, [L6, L8|L8s]], P), step_str(L6, 'L6', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, [L6, L8|L8s], S, [[L1, L2, L3, L4, L5, L6s, L7, [L6, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L1), \+member([[L7, L1|L1s], L2, L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L7, L1|L1s], L2, L3, L4, L5, L6, L7s, L8, S, [[[L7, L1|L1s], L2, L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L2), \+member([L1, [L7, L2|L2s], L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L7, L2|L2s], L3, L4, L5, L6, L7s, L8, S, [[L1, [L7, L2|L2s], L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L3), \+member([L1, L2, [L7, L3|L3s], L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L7, L3|L3s], L4, L5, L6, L7s, L8, S, [[L1, L2, [L7, L3|L3s], L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L4), \+member([L1, L2, L3, [L7, L4|L4s], L5, L6, L7s, L8], P), step_str(L7, 'L7', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L7, L4|L4s], L5, L6, L7s, L8, S, [[L1, L2, L3, [L7, L4|L4s], L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L5), \+member([L1, L2, L3, L4, [L7, L5|L5s], L6, L7s, L8], P), step_str(L7, 'L7', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L7, L5|L5s], L6, L7s, L8, S, [[L1, L2, L3, L4, [L7, L5|L5s], L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], [L7|L7s], L8, [S_|S], P, P_):-can_add_to_lane(L7, L6), \+member([L1, L2, L3, L4, L5, [L7, L6|L6s], L7s, L8], P), step_str(L7, 'L7', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L7, L6|L6s], L7s, L8, S, [[L1, L2, L3, L4, L5, [L7, L6|L6s], L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L7, L8), \+member([L1, L2, L3, L4, L5, L6, L7s, [L7, L8|L8s]], P), step_str(L7, 'L7', 'L8', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, [L7, L8|L8s], S, [[L1, L2, L3, L4, L5, L6, L7s, [L7, L8|L8s]]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L1), \+member([[L8, L1|L1s], L2, L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'L1', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, [L8, L1|L1s], L2, L3, L4, L5, L6, L7, L8s, S, [[[L8, L1|L1s], L2, L3, L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L2), \+member([L1, [L8, L2|L2s], L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'L2', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, [L8, L2|L2s], L3, L4, L5, L6, L7, L8s, S, [[L1, [L8, L2|L2s], L3, L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L3), \+member([L1, L2, [L8, L3|L3s], L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'L3', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, [L8, L3|L3s], L4, L5, L6, L7, L8s, S, [[L1, L2, [L8, L3|L3s], L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L4), \+member([L1, L2, L3, [L8, L4|L4s], L5, L6, L7, L8s], P), step_str(L8, 'L8', 'L4', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, [L8, L4|L4s], L5, L6, L7, L8s, S, [[L1, L2, L3, [L8, L4|L4s], L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L5), \+member([L1, L2, L3, L4, [L8, L5|L5s], L6, L7, L8s], P), step_str(L8, 'L8', 'L5', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, [L8, L5|L5s], L6, L7, L8s, S, [[L1, L2, L3, L4, [L8, L5|L5s], L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L6), \+member([L1, L2, L3, L4, L5, [L8, L6|L6s], L7, L8s], P), step_str(L8, 'L8', 'L6', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, [L8, L6|L6s], L7, L8s, S, [[L1, L2, L3, L4, L5, [L8, L6|L6s], L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], [L8|L8s], [S_|S], P, P_):-can_add_to_lane(L8, L7), \+member([L1, L2, L3, L4, L5, L6, [L8, L7|L7s], L8s], P), step_str(L8, 'L8', 'L7', S_), f(G1, G2, G3, G4, F1, F2, F3, F4, L1, L2, L3, L4, L5, L6, [L8, L7|L7s], L8s, S, [[L1, L2, L3, L4, L5, L6, [L8, L7|L7s], L8s]|P], P_).

% ==============================================================================
% lanes to freecells
% ------------------------------------------------------------------------------

f(G1, G2, G3, G4,                          % L1 to F1
    [], F2, F3, F4,
    [L1|L1s], L2, L3, L4, L5, L6, L7, L8,
    [S_|S], P, P_
) :-
    L1 \= b,
    \+ member([L1s,L2,L3,L4,L5,L6,L7,L8],P),
    step_str(L1, 'L1', 'F1', S_),
    f(G1, G2, G3, G4,
        [L1], F2, F3, F4,
        L1s, L2, L3, L4, L5, L6, L7, L8,
        S, [[L1s,L2,L3,L4,L5,L6,L7,L8]|P], P_
    ).

f(G1, G2, G3, G4, F1, [], F3, F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L1\=b, \+member([L1s, L2, L3, L4, L5, L6, L7, L8], P), step_str(L1, 'L1', 'F2', S_), f(G1, G2, G3, G4, F1, [L1], F3, F4, L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L1\=b, \+member([L1s, L2, L3, L4, L5, L6, L7, L8], P), step_str(L1, 'L1', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L1], F4, L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], [L1|L1s], L2, L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L1\=b, \+member([L1s, L2, L3, L4, L5, L6, L7, L8], P), step_str(L1, 'L1', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L1], L1s, L2, L3, L4, L5, L6, L7, L8, S, [[L1s, L2, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'F1', S_), f(G1, G2, G3, G4, [L2], F2, F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'F2', S_), f(G1, G2, G3, G4, F1, [L2], F3, F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L2], F4, L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, [L2|L2s], L3, L4, L5, L6, L7, L8, [S_|S], P, P_):-L2\=b, \+member([L1, L2s, L3, L4, L5, L6, L7, L8], P), step_str(L2, 'L2', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L2], L1, L2s, L3, L4, L5, L6, L7, L8, S, [[L1, L2s, L3, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'F1', S_), f(G1, G2, G3, G4, [L3], F2, F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'F2', S_), f(G1, G2, G3, G4, F1, [L3], F3, F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L3], F4, L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, [L3|L3s], L4, L5, L6, L7, L8, [S_|S], P, P_):-L3\=b, \+member([L1, L2, L3s, L4, L5, L6, L7, L8], P), step_str(L3, 'L3', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L3], L1, L2, L3s, L4, L5, L6, L7, L8, S, [[L1, L2, L3s, L4, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'F1', S_), f(G1, G2, G3, G4, [L4], F2, F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'F2', S_), f(G1, G2, G3, G4, F1, [L4], F3, F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L4], F4, L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, [L4|L4s], L5, L6, L7, L8, [S_|S], P, P_):-L4\=b, \+member([L1, L2, L3, L4s, L5, L6, L7, L8], P), step_str(L4, 'L4', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L4], L1, L2, L3, L4s, L5, L6, L7, L8, S, [[L1, L2, L3, L4s, L5, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-L5\=b, \+member([L1, L2, L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'F1', S_), f(G1, G2, G3, G4, [L5], F2, F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-L5\=b, \+member([L1, L2, L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'F2', S_), f(G1, G2, G3, G4, F1, [L5], F3, F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-L5\=b, \+member([L1, L2, L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L5], F4, L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, [L5|L5s], L6, L7, L8, [S_|S], P, P_):-L5\=b, \+member([L1, L2, L3, L4, L5s, L6, L7, L8], P), step_str(L5, 'L5', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L5], L1, L2, L3, L4, L5s, L6, L7, L8, S, [[L1, L2, L3, L4, L5s, L6, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-L6\=b, \+member([L1, L2, L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'F1', S_), f(G1, G2, G3, G4, [L6], F2, F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-L6\=b, \+member([L1, L2, L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'F2', S_), f(G1, G2, G3, G4, F1, [L6], F3, F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-L6\=b, \+member([L1, L2, L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L6], F4, L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, [L6|L6s], L7, L8, [S_|S], P, P_):-L6\=b, \+member([L1, L2, L3, L4, L5, L6s, L7, L8], P), step_str(L6, 'L6', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L6], L1, L2, L3, L4, L5, L6s, L7, L8, S, [[L1, L2, L3, L4, L5, L6s, L7, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-L7\=b, \+member([L1, L2, L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'F1', S_), f(G1, G2, G3, G4, [L7], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-L7\=b, \+member([L1, L2, L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'F2', S_), f(G1, G2, G3, G4, F1, [L7], F3, F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-L7\=b, \+member([L1, L2, L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L7], F4, L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, [L7|L7s], L8, [S_|S], P, P_):-L7\=b, \+member([L1, L2, L3, L4, L5, L6, L7s, L8], P), step_str(L7, 'L7', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L7], L1, L2, L3, L4, L5, L6, L7s, L8, S, [[L1, L2, L3, L4, L5, L6, L7s, L8]|P], P_).
f(G1, G2, G3, G4, [], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-L8\=b, \+member([L1, L2, L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'F1', S_), f(G1, G2, G3, G4, [L8], F2, F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, [], F3, F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-L8\=b, \+member([L1, L2, L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'F2', S_), f(G1, G2, G3, G4, F1, [L8], F3, F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, [], F4, L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-L8\=b, \+member([L1, L2, L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'F3', S_), f(G1, G2, G3, G4, F1, F2, [L8], F4, L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_).
f(G1, G2, G3, G4, F1, F2, F3, [], L1, L2, L3, L4, L5, L6, L7, [L8|L8s], [S_|S], P, P_):-L8\=b, \+member([L1, L2, L3, L4, L5, L6, L7, L8s], P), step_str(L8, 'L8', 'F4', S_), f(G1, G2, G3, G4, F1, F2, F3, [L8], L1, L2, L3, L4, L5, L6, L7, L8s, S, [[L1, L2, L3, L4, L5, L6, L7, L8s]|P], P_).

