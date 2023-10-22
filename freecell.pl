% example:
% ?- fc([3,1],[4,2],S).
% S = ['3 from L1 to L2', '1 from L1 to G1', '3 from L2 to F1', '4 from L2 to F2', '2 from L2 to G1', '3 from F1 to G1', '4 from F2 to G1'].

fc(L1,L2,S) :-
    f([],[],[],L1,L2,S,[],_).

% G1 for Goal 1 [n,n-1,...,1]
% F1 for Free Cell 1 [m]
% F2 for Free Cell 2 [m]
% L1 for Lane 1 [l1_1,...,l1_k]
% L2 for Lane 2 [l2_1,...,l2_l]
% S for Solution
% P for Past states
% P_ for Past states accumulator

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,' from ',From,' to ',To], Str).

% done
% f(
%   G1, F1, F2, L1, L2, S, P, P_)
% )
f(_,[],[],[],[],[],P,P).

% first goal
f([], [1|F1s], F2, L1, L2, [S_|S], P, P_) :- step_str(1, 'F1', 'G1', S_), f([1], F1s, F2, L1, L2, S, [[L1,L2]|P], P_).
f([], F1, [1|F2s], L1, L2, [S_|S], P, P_) :- step_str(1, 'F2', 'G1', S_), f([1], F1, F2s, L1, L2, S, [[L1,L2]|P], P_).
f([], F1, F2, [1|L1s], L2, [S_|S], P, P_) :- step_str(1, 'L1', 'G1', S_), f([1], F1, F2, L1s, L2, S, [[L1s,L2]|P], P_).
f([], F1, F2, L1, [1|L2s], [S_|S], P, P_) :- step_str(1, 'L2', 'G1', S_), f([1], F1, F2, L1, L2s, S, [[L1,L2s]|P], P_).

% free cells to goal
f([G1|G1s], [F1], F2, L1, L2, [S_|S], P, P_) :- F1 =:= G1 + 1, step_str(F1, 'F1', 'G1', S_), f([F1,G1|G1s], [], F2, L1, L2, S, [[L1,L2]|P], P_),!.
f([G1|G1s], F1, [F2], L1, L2, [S_|S], P, P_) :- F2 =:= G1 + 1, step_str(F2, 'F2', 'G1', S_), f([F2,G1|G1s], F1, [], L1, L2, S, [[L1,L2]|P], P_),!.

% lanes to goal
f([G1|G1s], F1, F2, [L1|L1s], L2, [S_|S], P, P_) :- L1 =:= G1 + 1, step_str(L1, 'L1', 'G1', S_), f([L1,G1|G1s], F1, F2, L1s, L2, S, [[L1s,L2]|P], P_),!.
f([G1|G1s], F1, F2, L1, [L2|L2s], [S_|S], P, P_) :- L2 =:= G1 + 1, step_str(L2, 'L2', 'G1', S_), f([L2,G1|G1s], F1, F2, L1, L2s, S, [[L1,L2s]|P], P_),!.

% free cells to lanes
f(G1, [F1], F2, [L1|L1s], L2, [S_|S], P, P_) :- F1 + 1 =:= L1, \+ member([[F1,L1|L1s], L2],P), step_str(F1, 'F1', 'L1', S_), f(G1, [], F2, [F1,L1|L1s], L2, S, [[[F1,L1|L1s], L2]|P], P_).
f(G1, [F1], F2, L1, [L2|L2s], [S_|S], P, P_) :- F1 + 1 =:= L2, \+ member([L1, [F1,L2|L2s]],P), step_str(F1, 'F1', 'L2', S_), f(G1, [], F2, L1, [F1,L2|L2s], S, [[L1, [F1,L2|L2s]]|P], P_).
f(G1, F1, [F2], [L1|L1s], L2, [S_|S], P, P_) :- F2 + 1 =:= L1, \+ member([[F2,L1|L1s], L2],P), step_str(F2, 'F2', 'L1', S_), f(G1, F1, [], [F2,L1|L1s], L2, S, [[[F2,L1|L1s], L2]|P], P_).
f(G1, F1, [F2], L1, [L2|L2s], [S_|S], P, P_) :- F2 + 1 =:= L2, \+ member([L1, [F2,L2|L2s]],P), step_str(F2, 'F2', 'L2', S_), f(G1, F1, [], L1, [F2,L2|L2s], S, [[L1, [F2,L2|L2s]]|P], P_).

% lane to lane
f(G1, F1, F2, [L1|L1s], [L2|L2s], [S_|S], P, P_) :- L1 =:= L2 + 1, \+ member([[L2,L1|L1s], L2s],P), step_str(L2, 'L2', 'L1', S_), f(G1, F1, F2, [L2,L1|L1s], L2s, S, [[[L2,L1|L1s], L2s]|P], P_).
f(G1, F1, F2, [L1|L1s], [L2|L2s], [S_|S], P, P_) :- L2 =:= L1 + 1, \+ member([L1s, [L1,L2|L2s]],P), step_str(L1, 'L1', 'L2', S_), f(G1, F1, F2, L1s, [L1,L2|L2s], S, [[L1s, [L1,L2|L2s]]|P], P_).

% lanes to free cells
f(G1, [], F2, [L1|L1s], L2, [S_|S], P, P_) :- \+ member([L1s, L2],P), step_str(L1, 'L1', 'F1', S_), f(G1, [L1], F2, L1s, L2, S, [[L1s, L2]|P], P_).
f(G1, [], F2, L1, [L2|L2s], [S_|S], P, P_) :- \+ member([L1, L2s],P), step_str(L2, 'L2', 'F1', S_), f(G1, [L2], F2, L1, L2s, S, [[L1, L2s]|P], P_).
f(G1, F1, [], [L1|L1s], L2, [S_|S], P, P_) :- \+ member([L1s, L2],P), step_str(L1, 'L1', 'F2', S_), f(G1, F1, [L1], L1s, L2, S, [[L1s, L2]|P], P_).
f(G1, F1, [], L1, [L2|L2s], [S_|S], P, P_) :- \+ member([L1, L2s],P), step_str(L2, 'L2', 'F2', S_), f(G1, F1, [L2], L1, L2s, S, [[L1, L2s]|P], P_).
