% Simplified single suit Free Cell with two lanes (L1,L2),
% one free cell (F) and one foundation pile (G).

% example:
% ?- fc([2,1],[4,3],S).
% S = ['2 from L1 to F', '1 from L1 to G', '2 from F to G', '4 from L2 to F', '3 from L2 to G', '4 from F to G'].

fc(L1,L2,S) :-
    f([],[],L1,L2,S).

% G for Goal [n,n-1,...,1]
% F for Free Cell [m]
% L1 for Lane 1 [l1_1,...,l1_k]
% L2 for Lane 2 [l2_1,...,l2_l]
% S for Solution

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,' from ',From,' to ',To], Str).

% done
% f(
%   Goal, Free Cell, Lane 1, Lane 2, Solution)
% )
f(_,[],[],[],[]).

% first goal
f([], [1|Fs], L1, L2, [Step|S]) :-
    step_str(1, 'F', 'G', Step),
    f([1], Fs, L1, L2, S).

f([], F, [1|L1s], L2, [Step|S]) :-
    step_str(1, 'L1', 'G', Step),
    f([1], F, L1s, L2, S).

f([], F, L1, [1|L2s], [Step|S]) :-
    step_str(1, 'L2', 'G', Step),
    f([1], F, L1, L2s, S).

% free cell to goal
f([G|Gs], [F], L1, L2, [Step|S]) :-
    F =:= G + 1,
    step_str(F, 'F', 'G', Step),
    f([F,G|Gs], [], L1, L2, S),!.

% lanes to goal
f([G|Gs], F, [L1|L1s], L2, [Step|S]) :-
    L1 =:= G + 1,
    step_str(L1, 'L1', 'G', Step),
    f([L1,G|Gs], F, L1s, L2, S),!.

f([G|Gs], F, L1, [L2|L2s], [Step|S]) :-
    L2 =:= G + 1,
    step_str(L2, 'L2', 'G', Step),
    f([L2,G|Gs], F, L1, L2s, S),!.

% free cell to lanes
f(G, [F], [L1|L1s], L2, [Step|S]) :-
    F + 1 =:= L1,
    step_str(F, 'F', 'L1', Step),
    f(G, [], [F,L1|L1s], L2, S).

f(G, [F], L1, [L2|L2s], [Step|S]) :-
    F + 1 =:= L2,
    step_str(F, 'F', 'L2', Step),
    f(G, [], L1, [F,L2|L2s], S).

% lane to lane
f(G, F, [L1|L1s], [L2|L2s], [Step|S]) :-
    L1 =:= L2 + 1,
    step_str(L2, 'L2', 'L1', Step),
    f(G, F, [L2,L1|L1s], L2s, S).

f(G, F, [L1|L1s], [L2|L2s], [Step|S]) :-
    L2 =:= L1 + 1,
    step_str(L1, 'L1', 'L2', Step),
    f(G, F, L1s, [L1,L2|L2s], S).

% lanes to free cell
f(G, [], [L1|L1s], L2, [Step|S]) :-
    step_str(L1, 'L1', 'F', Step),
    f(G, [L1], L1s, L2, S).

f(G, [], L1, [L2|L2s], [Step|S]) :-
    step_str(L2, 'L2', 'F', Step),
    f(G, [L2], L1, L2s, S).
