% example:
% ?- fc([2,1],[4,3],S).
% S = ['2 from L1 to F1', '1 from L1 to G1', '2 from F1 to G1', '4 from L2 to F1', '3 from L2 to G1', '4 from F1 to G1'].

fc(L1,L2,S) :-
    f([],[],L1,L2,S).

% G1 for Goal 1 [n,n-1,...,1]
% F1 for Free Cell 1 [m]
% L1 for Lane 1 [l1_1,...,l1_k]
% L2 for Lane 2 [l2_1,...,l2_l]
% S for Solution

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,' from ',From,' to ',To], Str).

% done
% f(
%   G1, F1, L1, L2, S)
% )
f(_,[],[],[],[]).

% first goal
f([], [1|F1s], L1, L2, [S_|S]) :- step_str(1, 'F1', 'G1', S_), f([1], F1s, L1, L2, S).
f([], F1, [1|L1s], L2, [S_|S]) :- step_str(1, 'L1', 'G1', S_), f([1], F1, L1s, L2, S).
f([], F1, L1, [1|L2s], [S_|S]) :- step_str(1, 'L2', 'G1', S_), f([1], F1, L1, L2s, S).

% free cell to goal
f([G1|G1s], [F1], L1, L2, [S_|S]) :- F1 =:= G1 + 1, step_str(F1, 'F1', 'G1', S_), f([F1,G1|G1s], [], L1, L2, S),!.

% lanes to goal
f([G1|G1s], F1, [L1|L1s], L2, [S_|S]) :- L1 =:= G1 + 1, step_str(L1, 'L1', 'G1', S_), f([L1,G1|G1s], F1, L1s, L2, S),!.
f([G1|G1s], F1, L1, [L2|L2s], [S_|S]) :- L2 =:= G1 + 1, step_str(L2, 'L2', 'G1', S_), f([L2,G1|G1s], F1, L1, L2s, S),!.

% free cell to lanes
f(G1, [F1], [L1|L1s], L2, [S_|S]) :- F1 + 1 =:= L1, step_str(F1, 'F1', 'L1', S_), f(G1, [], [F1,L1|L1s], L2, S).
f(G1, [F1], L1, [L2|L2s], [S_|S]) :- F1 + 1 =:= L2, step_str(F1, 'F1', 'L2', S_), f(G1, [], L1, [F1,L2|L2s], S).

% lane to lane
f(G1, F1, [L1|L1s], [L2|L2s], [S_|S]) :- L1 =:= L2 + 1, step_str(L2, 'L2', 'L1', S_), f(G1, F1, [L2,L1|L1s], L2s, S).
f(G1, F1, [L1|L1s], [L2|L2s], [S_|S]) :- L2 =:= L1 + 1, step_str(L1, 'L1', 'L2', S_), f(G1, F1, L1s, [L1,L2|L2s], S).

% lanes to free cell
f(G1, [], [L1|L1s], L2, [S_|S]) :- step_str(L1, 'L1', 'F1', S_), f(G1, [L1], L1s, L2, S).
f(G1, [], L1, [L2|L2s], [S_|S]) :- step_str(L2, 'L2', 'F1', S_), f(G1, [L2], L1, L2s, S).
