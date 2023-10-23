% example:
% ?- fc([1,9,4],[8,5,2],[3,6,7],S).
% S = ['1:L1-G1', '8:L2-L1', '8:L1-F1', '9:L1-F2', '4:L1-L2', '8:F1-L1', '3:L3-L2', '8:L1-F1', '9:F2-L1', '8:F1-L1',
%      '3:L2-F1', '4:L2-F2', '5:L2-L3', '2:L2-G1', '3:F1-G1', '4:F2-G1', '5:L3-G1', '6:L3-G1', '7:L3-G1', '8:L1-G1',
%      '9:L1-G1']

fc(L1,L2,L3,S) :-
    append(L1,[b],L1_),
    append(L2,[b],L2_),
    append(L3,[b],L3_),
    f([b],[],[],L1_,L2_,L3_,S,[],_).

% G1 for Goal 1 [n,n-1,...,1]
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
%   G1, F1, F2, L1, L2, L3, S, P, P_)
% )
f(_,[],[],[b],[b],[b],[],P,P).

% free cells to goal
f([G1|G1s], [F1], F2, L1, L2, L3, [S_|S], P, P_) :- (G1 = b; (G1 \= b, F1 =:= G1 + 1)), step_str(F1, 'F1', 'G1', S_), f([F1,G1|G1s], [], F2, L1, L2, L3, S, [[L1,L2,L3]|P], P_),!.
f([G1|G1s], F1, [F2], L1, L2, L3, [S_|S], P, P_) :- (G1 = b; (G1 \= b, F2 =:= G1 + 1)), step_str(F2, 'F2', 'G1', S_), f([F2,G1|G1s], F1, [], L1, L2, L3, S, [[L1,L2,L3]|P], P_),!.

% lanes to goal
f([G1|G1s], F1, F2, [L1|L1s], L2, L3, [S_|S], P, P_) :- L1 \= b, (G1 = b; (G1 \= b, L1 =:= G1 + 1)), step_str(L1, 'L1', 'G1', S_), f([L1,G1|G1s], F1, F2, L1s, L2, L3, S, [[L1s,L2,L3]|P], P_),!.
f([G1|G1s], F1, F2, L1, [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, (G1 = b; (G1 \= b, L2 =:= G1 + 1)), step_str(L2, 'L2', 'G1', S_), f([L2,G1|G1s], F1, F2, L1, L2s, L3, S, [[L1,L2s,L3]|P], P_),!.
f([G1|G1s], F1, F2, L1, L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, (G1 = b; (G1 \= b, L3 =:= G1 + 1)), step_str(L3, 'L3', 'G1', S_), f([L3,G1|G1s], F1, F2, L1, L2, L3s, S, [[L1,L2,L3s]|P], P_),!.

% free cells to lanes
f(G1, [F1], F2, [L1|L1s], L2, L3, [S_|S], P, P_) :- (L1 = b; (L1 \= b, F1 + 1 =:= L1)), \+ member([[F1,L1|L1s],L2,L3],P), step_str(F1, 'F1', 'L1', S_), f(G1, [], F2, [F1,L1|L1s], L2, L3, S, [[[F1,L1|L1s],L2,L3]|P], P_).
f(G1, [F1], F2, L1, [L2|L2s], L3, [S_|S], P, P_) :- (L2 = b; (L2 \= b, F1 + 1 =:= L2)), \+ member([L1,[F1,L2|L2s],L3],P), step_str(F1, 'F1', 'L2', S_), f(G1, [], F2, L1, [F1,L2|L2s], L3, S, [[L1,[F1,L2|L2s],L3]|P], P_).
f(G1, [F1], F2, L1, L2, [L3|L3s], [S_|S], P, P_) :- (L3 = b; (L3 \= b, F1 + 1 =:= L3)), \+ member([L1,L2,[F1,L3|L3s]],P), step_str(F1, 'F1', 'L3', S_), f(G1, [], F2, L1, L2, [F1,L3|L3s], S, [[L1,L2,[F1,L3|L3s]]|P], P_).
f(G1, F1, [F2], [L1|L1s], L2, L3, [S_|S], P, P_) :- (L1 = b; (L1 \= b, F2 + 1 =:= L1)), \+ member([[F2,L1|L1s],L2,L3],P), step_str(F2, 'F2', 'L1', S_), f(G1, F1, [], [F2,L1|L1s], L2, L3, S, [[[F2,L1|L1s],L2,L3]|P], P_).
f(G1, F1, [F2], L1, [L2|L2s], L3, [S_|S], P, P_) :- (L2 = b; (L2 \= b, F2 + 1 =:= L2)), \+ member([L1,[F2,L2|L2s],L3],P), step_str(F2, 'F2', 'L2', S_), f(G1, F1, [], L1, [F2,L2|L2s], L3, S, [[L1,[F2,L2|L2s],L3]|P], P_).
f(G1, F1, [F2], L1, L2, [L3|L3s], [S_|S], P, P_) :- (L3 = b; (L3 \= b, F2 + 1 =:= L3)), \+ member([L1,L2,[F2,L3|L3s]],P), step_str(F2, 'F2', 'L3', S_), f(G1, F1, [], L1, L2, [F2,L3|L3s], S, [[L1,L2,[F2,L3|L3s]]|P], P_).

% lane to lane
f(G1, F1, F2, [L1|L1s], [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, (L1 = b ; (L1 \= b, L1 =:= L2 + 1)), \+ member([[L2,L1|L1s],L2s,L3],P), step_str(L2, 'L2', 'L1', S_), f(G1, F1, F2, [L2,L1|L1s], L2s, L3, S, [[[L2,L1|L1s],L2s,L3]|P], P_).
f(G1, F1, F2, L1, [L2|L2s], [L3|L3s], [S_|S], P, P_) :- L2 \= b, (L3 = b ; (L3 \= b, L3 =:= L2 + 1)), \+ member([L1,L2s,[L2,L3|L3s]],P), step_str(L2, 'L2', 'L3', S_), f(G1, F1, F2, L1, L2s, [L2,L3|L3s], S, [[L1,L2s,[L2,L3|L3s]]|P], P_).
f(G1, F1, F2, [L1|L1s], [L2|L2s], L3, [S_|S], P, P_) :- L1 \= b, (L2 = b ; (L2 \= b, L2 =:= L1 + 1)), \+ member([L1s,[L1,L2|L2s],L3],P), step_str(L1, 'L1', 'L2', S_), f(G1, F1, F2, L1s, [L1,L2|L2s], L3, S, [[L1s,[L1,L2|L2s],L3]|P], P_).
f(G1, F1, F2, [L1|L1s], L2, [L3|L3s], [S_|S], P, P_) :- L1 \= b, (L3 = b ; (L3 \= b, L3 =:= L1 + 1)), \+ member([L1s,L2,[L1,L3|L3s]],P), step_str(L1, 'L1', 'L3', S_), f(G1, F1, F2, L1s, L2, [L1,L3|L3s], S, [[L1s,L2,[L1,L3|L3s]]|P], P_).
f(G1, F1, F2, [L1|L1s], L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, (L1 = b ; (L1 \= b, L1 =:= L3 + 1)), \+ member([[L3,L1|L1s],L2,L3s],P), step_str(L3, 'L3', 'L1', S_), f(G1, F1, F2, [L3,L1|L1s], L2, L3s, S, [[[L3,L1|L1s],L2,L3s]|P], P_).
f(G1, F1, F2, L1, [L2|L2s], [L3|L3s], [S_|S], P, P_) :- L3 \= b, (L2 = b ; (L2 \= b, L2 =:= L3 + 1)), \+ member([L1,[L3,L2|L2s],L3s],P), step_str(L3, 'L3', 'L2', S_), f(G1, F1, F2, L1, [L3,L2|L2s], L3s, S, [[L1,[L3,L2|L2s],L3s]|P], P_).

% lanes to free cells
f(G1, [], F2, [L1|L1s], L2, L3, [S_|S], P, P_) :- L1 \= b, \+ member([L1s,L2,L3],P), step_str(L1, 'L1', 'F1', S_), f(G1, [L1], F2, L1s, L2, L3, S, [[L1s,L2,L3]|P], P_).
f(G1, [], F2, L1, [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, \+ member([L1,L2s,L3],P), step_str(L2, 'L2', 'F1', S_), f(G1, [L2], F2, L1, L2s, L3, S, [[L1,L2s,L3]|P], P_).
f(G1, [], F2, L1, L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, \+ member([L1,L2,L3s],P), step_str(L3, 'L3', 'F1', S_), f(G1, [L3], F2, L1, L2, L3s, S, [[L1,L2,L3s]|P], P_).
f(G1, F1, [], [L1|L1s], L2, L3, [S_|S], P, P_) :- L1 \= b, \+ member([L1s,L2,L3],P), step_str(L1, 'L1', 'F2', S_), f(G1, F1, [L1], L1s, L2, L3, S, [[L1s,L2,L3]|P], P_).
f(G1, F1, [], L1, [L2|L2s], L3, [S_|S], P, P_) :- L2 \= b, \+ member([L1,L2s,L3],P), step_str(L2, 'L2', 'F2', S_), f(G1, F1, [L2], L1, L2s, L3, S, [[L1,L2s,L3]|P], P_).
f(G1, F1, [], L1, L2, [L3|L3s], [S_|S], P, P_) :- L3 \= b, \+ member([L1,L2,L3s],P), step_str(L3, 'L3', 'F2', S_), f(G1, F1, [L3], L1, L2, L3s, S, [[L1,L2,L3s]|P], P_).
