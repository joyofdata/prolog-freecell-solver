% Simplified single suit Free Cell with two lanes (A,B), 
% one free cell (F) and one foundation pile (G).

% example:
% ?- fc([2,1],[4,3],S).
% S = ["2 from A to F", '1 from A to G', "2 from F to G",
%      "4 from B to F", "3 from B to G", "4 from F to G"].

fc(A,B,S) :-
    f([],[],A,B,S).

% G for Goal [n,n-1,...,1]
% F for Free Cell [m]
% A for Lane A [a_1,...,a_k]
% B for Lane B [b_1,...,b_l]
% S for Solution

step_str(Val, From, To, Str) :-
    atomic_list_concat([Val,' from ',From,' to ',To], Str).

% done
% f(
%   Goal, Free Cell, Lane A, Lane B, Solution)
% )
f(_,[],[],[],[]).

% first goal
f([], [1|Fs], A, B, [Step|S]) :-
    step_str(1, 'F', 'G', Step),
    f([1], Fs, A, B, S).

f([], F, [1|As], B, [Step|S]) :-
    step_str(1, 'A', 'G', Step),
    f([1], F, As, B, S).

f([], F, A, [1|Bs], [Step|S]) :-
    step_str(1, 'B', 'G', Step),
    f([1], F, A, Bs, S).

% free cell to goal
f([G|Gs], [F], A, B, [Step|S]) :-
    F =:= G + 1,
    step_str(F, 'F', 'G', Step),
    f([F,G|Gs], [], A, B, S).

% lanes to goal
f([G|Gs], F, [A|As], B, [Step|S]) :-
    A =:= G + 1,
    step_str(A, 'A', 'G', Step),
    f([A,G|Gs], F, As, B, S).

f([G|Gs], F, A, [B|Bs], [Step|S]) :-
    B =:= G + 1,
    step_str(B, 'B', 'G', Step),
    f([B,G|Gs], F, A, Bs, S).

% free cell to lanes
f(G, [F], [A|As], B, [Step|S]) :-
    F + 1 =:= A,
    step_str(F, 'F', 'A', Step),
    f(G, [], [F,A|As], B, S).

f(G, [F], A, [B|Bs], [Step|S]) :-
    F + 1 =:= B,
    step_str(F, 'F', 'B', Step),
    f(G, [], A, [F,B|Bs], S).

% lane to lane
f(G, F, [A|As], [B|Bs], [Step|S]) :-
    A =:= B + 1,
    step_str(B, 'B', 'A', Step),
    f(G, F, [B,A|As], Bs, S).

f(G, F, [A|As], [B|Bs], [Step|S]) :-
    B =:= A + 1,
    step_str(A, 'A', 'B', Step),
    f(G, F, As, [A,B|Bs], S).

% lanes to free cell
f(G, [], [A|As], B, [Step|S]) :-
    step_str(A, 'A', 'F', Step),
    f(G, [A], As, B, S).

f(G, [], A, [B|Bs], [Step|S]) :-
    step_str(B, 'B', 'F', Step),
    f(G, [B], A, Bs, S).
