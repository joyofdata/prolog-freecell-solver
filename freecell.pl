% Simplified single suit Free Cell with two lanes (A,B), 
% one free cell (F) and one foundation pile (G).

% G for Goal [n,n-1,...,1]
% F for Free Cell [m]
% A for Lane A [a_1,...,a_k]
% B for Lane B [b_1,...,b_l]

% done
f(_,[],[],[]).

% first goal
f([], [1|Fs], A, B) :- f([1], Fs, A, B).
f([], F, [1|As], B) :- f([1], F, As, B).
f([], F, A, [1|Bs]) :- f([1], F, A, Bs).

% free cell to goal
f([G|Gs], [F], A, B) :- F =:= G + 1, f([F,G|Gs], [], A, B).

% lanes to goal
f([G|Gs], F, [A|As], B) :- A =:= G + 1, f([A,G|Gs], F, As, B).
f([G|Gs], F, A, [B|Bs]) :- B =:= G + 1, f([B,G|Gs], F, A, Bs).

% free cell to lanes
f(G, [F], [A|As], B) :- F + 1 =:= A, f(G, [], [F,A|As], B).
f(G, [F], A, [B|Bs]) :- F + 1 =:= B, f(G, [], A, [F,B|Bs]).

% lane to lane
f(G, F, [A|As], [B|Bs]) :- A =:= B + 1, f(G, F, [B,A|As], Bs).
f(G, F, [A|As], [B|Bs]) :- B =:= A + 1, f(G, F, As, [A,B|Bs]).

% lanes to free cell
f(G, [], [A|As], B) :- f(G, [A], As, B).
f(G, [], A, [B|Bs]) :- f(G, [B], A, Bs).
