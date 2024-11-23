%cell((X,Y), Track).
%train(ID).
%start(ID, (X,Y), Dep, Dir).
%end(ID, (X,Y), Arr ).
%action(train(ID), move_left, T).
%action(train(ID), move_right, T).
%action(train(ID), wait, T).
%action(train(ID), move_forward, T).
%occupation(train(ID), (X,Y), T, Dir).

%remove actions after reaching destination
arrival(ID, ArrActual) :- end(ID, (X,Y), _), occupation(train(ID), (X,Y), ArrActual, _).
:- arrival(ID, 	ArrActual), action(train(ID), _, ArrActual+1).

%occupation(cell, direction) + tracktype -> action+move_direction
%TODO: replace >= with =

%generate actions
%{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, (X,Y), Arr ), T < Arr.

% Track Type #1
%variation 32800
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 32800), { Dir = s; Dir = n } >= 1, end(ID, _, Arr), T < Arr.
%variation 1025
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 1025), { Dir = w; Dir = e } >= 1, end(ID, _, Arr), T < Arr.
%variation 4608
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 4608), { Dir = e; Dir = s } >= 1, end(ID, _, Arr), T < Arr.
%variation 16386
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 16386), { Dir = n; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 72
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 72), { Dir = s; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 2064
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 2064), { Dir = e; Dir = s } >= 1, end(ID, _, Arr), T < Arr.

% Track Type #2
%variation 37408
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, n), cell((X,Y), 37408), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 37408), { Dir = s; Dir = e } >= 1, end(ID, _, Arr), T < Arr.
%variation 17411
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, w), cell((X,Y), 17411), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 17411), { Dir = n; Dir = e } >= 1, end(ID, _, Arr), T < Arr.
%variation 32872
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, s), cell((X,Y), 32872), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 32872), { Dir = n; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 3089
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, e), cell((X,Y), 3089), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 3089), { Dir = s; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 49186
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, n), cell((X,Y), 49186), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 49186), { Dir = s; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 1097
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, w), cell((X,Y), 1097), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 1097), { Dir = s; Dir = e } >= 1, end(ID, _, Arr), T < Arr.
%variation 34864
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, s), cell((X,Y), 34864), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 34864), { Dir = n; Dir = e } >= 1, end(ID, _, Arr), T < Arr.
%variation 5633
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, e), cell((X,Y), 5633), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 5633), { Dir = n; Dir = w } >= 1, end(ID, _, Arr), T < Arr.

% Track Type #3
%variation 33825
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, _), cell((X,Y), 33825).

% Track Type #4
%variation 38433
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 38433), { Dir = w; Dir = s } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, n), cell((X,Y), 38433), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, e), cell((X,Y), 38433), end(ID, _, Arr), T < Arr.
%variation 50211
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 50211), { Dir = e; Dir = s } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, w), cell((X,Y), 50211), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, n), cell((X,Y), 50211), end(ID, _, Arr), T < Arr.
%variation 33897
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 33897), { Dir = e; Dir = n } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, s), cell((X,Y), 33897), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, w), cell((X,Y), 33897), end(ID, _, Arr), T < Arr.
%variation 35889
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 35889), { Dir = w; Dir = n } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, e), cell((X,Y), 35889), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, s), cell((X,Y), 35889), end(ID, _, Arr), T < Arr.

% Track Type #5
%variation 38505
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 38505), { Dir = n; Dir = s } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 38505), { Dir = e; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 52275
{ action(train(ID), move_forward, T+1); action(train(ID), move_left, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 52275), { Dir = e; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 52275), { Dir = n; Dir = s } >= 1, end(ID, _, Arr), T < Arr.

% Track Type #6
%variation 20994
{ action(train(ID), move_left, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, n), cell((X,Y), 20994), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 20994), { Dir = e; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 16458
{ action(train(ID), move_left, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, w), cell((X,Y), 16458), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 16458), { Dir = n; Dir = s } >= 1, end(ID, _, Arr), T < Arr.
%variation 2136
{ action(train(ID), move_left, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, s), cell((X,Y), 2136), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 2136), { Dir = e; Dir = w } >= 1, end(ID, _, Arr), T < Arr.
%variation 6672
{ action(train(ID), move_left, T+1); action(train(ID), move_right, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, e), cell((X,Y), 6672), end(ID, _, Arr), T < Arr.
{ action(train(ID), move_forward, T+1); action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), (X,Y), T, Dir), cell((X,Y), 6672), { Dir = n; Dir = s } >= 1, end(ID, _, Arr), T < Arr.




%------------------------------------------------------------------------------------------------------------------------------------------------------%






%init train occupations on second time step
occupation(train(ID), (X,Y), Dep+1, Dir) :- start(ID, (X,Y), Dep, Dir).
%and action of the past for whatever reason
action(train(ID), wait, Dep) :- start(ID, _, Dep, _).
action(train(ID), move_forward, Dep+1) :- start(ID, _, Dep, _).

%action+move_direction + occupation(cell, direction) -> new occupation + direction

%move_forward != keeping direction for Track Type #1, #2 and #6!!!
%but should work for move_left and move_right
occupation(train(ID), (X-1,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), not forward_is_left(Track, n), not forward_is_right(Track, n). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y-1), T+1, w) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), move_left, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y-1), T+1, w) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_left(Track, n). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y+1), T+1, e) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), move_right, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y+1), T+1, e) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_right(Track, n). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, n), not end(ID, (X,Y), _), action(train(ID), wait, T+1). %TODO: probably only action/3 or end/3 necessary

occupation(train(ID), (X,Y+1), T+1, e) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), not forward_is_left(Track, e), not forward_is_right(Track, e). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X-1,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), move_left, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X-1,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_left(Track, e). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X+1,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), move_right, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X+1,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_right(Track, e). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y), T+1, e) 	:- occupation(train(ID), (X,Y), T, e), not end(ID, (X,Y), _), action(train(ID), wait, T+1). %TODO: probably only action/3 or end/3 necessary

occupation(train(ID), (X+1,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), not forward_is_left(Track, s), not forward_is_right(Track, s). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y+1), T+1, e) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), move_left, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y+1), T+1, e) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_left(Track, s). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y-1), T+1, w) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), move_right, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y-1), T+1, w) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_right(Track, s). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, s), not end(ID, (X,Y), _), action(train(ID), wait, T+1). %TODO: probably only action/3 or end/3 necessary

occupation(train(ID), (X,Y-1), T+1, w) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), not forward_is_left(Track, w), not forward_is_right(Track, w). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X+1,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), move_left, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X+1,Y), T+1, s) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_left(Track, w). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X-1,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), move_right, T+1). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X-1,Y), T+1, n) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), move_forward, T+1), cell((X,Y), Track), forward_is_right(Track, w). %TODO: probably only action/3 or end/3 necessary
occupation(train(ID), (X,Y), T+1, w) 	:- occupation(train(ID), (X,Y), T, w), not end(ID, (X,Y), _), action(train(ID), wait, T+1). %TODO: probably only action/3 or end/3 necessary

% e -> Y+1
% s -> X+1
% w -> Y-1
% n -> X-1

%Special Cases:

%forward_is_left(Track, Dir).
% Track Type #1
forward_is_left(4608, n).
forward_is_left(16386, w).
forward_is_left(72, s).
forward_is_left(2064, e).
% Track Type #2
forward_is_left(49186, w).
forward_is_left(1097, s).
forward_is_left(34864, e).
forward_is_left(5633, n).
% Track Type #6
forward_is_left(20994, w).
forward_is_left(16458, s).
forward_is_left(2136, e).
forward_is_left(6672, n).

%forward_is_right(Track, Dir).
% Track Type #1
forward_is_right(4608, e).
forward_is_right(16386, n).
forward_is_right(72, w).
forward_is_right(2064, s).
% Track Type #2
forward_is_right(37408, e).
forward_is_right(17411, n).
forward_is_right(32872, w).
forward_is_right(3089, s).
% Track Type #6
forward_is_right(20994, e).
forward_is_right(16458, n).
forward_is_right(2136, w).
forward_is_right(6672, s).



% train has to be on track that exists
:- occupation(_, (X,Y), _, _), not cell((X,Y), _). 
:- occupation(_, (X,Y), _, _), cell((X,Y), 0).
% two trains cannot be on the same track on the same time
:- occupation(train(ID1), (X,Y), T, _), occupation(train(ID2), (X,Y), T, _), ID1 != ID2.%, cell((X,Y), Track), Track != 38505, Track != 52275. %OR: { action(train(ID1), move_left, T+1), action(train(ID2), move_left, T+1) ; action(train(ID1)), move_right, T+1), action(train(ID2), move_right, T+1) } = 1. -> 2 integrity constraints
% or swap tiles within one time step
:- occupation(train(ID1), (X1,Y1), T, _), occupation(train(ID2), (X2,Y2), T, _), occupation(train(ID1), (X2,Y2), T+1, _), occupation(train(ID2), (X1,Y1), T+1, _), ID1 != ID2.
% no move for train after scheduled arrival
:- occupation(train(ID), _, T, _), end(ID, _, Arr), Arr < T.
:- action(train(ID), _, T), end(ID, _, Arr), Arr < T.
% train has to reach target...
:- not occupation(train(ID), (X,Y), _, _), end(ID, (X,Y), _).
% ... in time
:- occupation(train(ID), (X,Y), T, _), end(ID, (X,Y), Arr ), Arr < T.

%Minimize train journey times
action_count(AC) :- AC = #count{ TID, A, T: action(TID, A, T) }.
action_wait_count(AWC) :- AWC = #count{ TID, A, T: action(TID, T, T ), A = wait }.
#minimize { C@1: action_count(C) }.

%&sum { AWC } <= 1 :- action_wait_count(AWC).

#show occupation/4.
%#show action/3.