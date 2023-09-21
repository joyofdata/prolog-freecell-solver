% Simplified single suit Free Cell with two lanes (A,B), 
% one free cell (F) and one foundation pile (G).

% example:
% ?- fc([2,1],[3,4],S).
% S = ["2 from A to B", '1 from A to G', "2 from B to G", "3 from B to G", "4 from B to G"]

fc(A,B,S) :-
    f([],[],A,B,[],S_),
    reverse(S_,S).

% G for Goal [n,n-1,...,1]
% F for Free Cell [m]
% A for Lane A [a_1,...,a_k]
% B for Lane B [b_1,...,b_l]
% S for Solution

% done
% f(
%   Goal, Free Cell, Lane A, Lane B, Solution)
% )
f(_,[],[],[],S,S).

% first goal
f([], [1|Fs], A, B, S, S_) :- f([1], Fs, A, B, ['1 from F to G'|S], S_).
f([], F, [1|As], B, S, S_) :- f([1], F, As, B, ['1 from A to G'|S], S_).
f([], F, A, [1|Bs], S, S_) :- f([1], F, A, Bs, ['1 from B to G'|S], S_).

% free cell to goal
f([G|Gs], [F], A, B, S, S_) :-
    F =:= G + 1,
    string_concat(F, ' from F to G', Step),
    f([F,G|Gs], [], A, B, [Step|S], S_).

% lanes to goal
f([G|Gs], F, [A|As], B, S, S_) :-
    A =:= G + 1,
    string_concat(A, ' from A to G', Step),
    f([A,G|Gs], F, As, B, [Step|S], S_).

f([G|Gs], F, A, [B|Bs], S, S_) :-
    B =:= G + 1,
    string_concat(B, ' from B to G', Step),
    f([B,G|Gs], F, A, Bs, [Step|S], S_).

% free cell to lanes
f(G, [F], [A|As], B, S, S_) :-
    F + 1 =:= A,
    string_concat(F, ' from F to A', Step),
    f(G, [], [F,A|As], B, [Step|S], S_).

f(G, [F], A, [B|Bs], S, S_) :-
    F + 1 =:= B,
    string_concat(F, ' from F to B', Step),
    f(G, [], A, [F,B|Bs], [Step|S], S_).

% lane to lane
f(G, F, [A|As], [B|Bs], S, S_) :-
    A =:= B + 1,
    string_concat(B, ' from B to A', Step),
    f(G, F, [B,A|As], Bs, [Step|S], S_).

f(G, F, [A|As], [B|Bs], S, S_) :-
    B =:= A + 1,
    string_concat(A, ' from A to B', Step),
    f(G, F, As, [A,B|Bs], [Step|S], S_).

% lanes to free cell
f(G, [], [A|As], B, S, S_) :-
    string_concat(A, ' from A to F', Step),
    f(G, [A], As, B, [Step|S], S_).

f(G, [], A, [B|Bs], S, S_) :-
    string_concat(B, ' from B to F', Step),
    f(G, [B], A, Bs, [Step|S], S_).
