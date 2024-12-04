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
:- arrival(ID, 	ArrActual), action(train(ID), _, AfterArrival), AfterArrival > ArrActual.


% Track Type #1
track(1025).
track(32800).
track(4608).
track(16386).
track(72).
track(2064).

% Track Type #2
track(37408).
track(17411).
track(32872).
track(3089).
track(49186).
track(1097).
track(34864).
track(5633).

% Track Type #3
track(33825).

% Track Type #4
track(38433).
track(50211).
track(33897).
track(35889).

% Track Type #5
track(38505).
track(52275).

% Track Type #6
track(20994).
track(16458).
track(2136).
track(6672).

% divisors of each direction
direction(n, 3).
direction(e, 2).
direction(s, 1).
direction(w, 0).

% convert direction to coordinate change
move_x_y(n, -1, 0).
move_x_y(e, 0, 1).
move_x_y(s, 1, 0).
move_x_y(w, 0, -1).

%all 16 bits/divisors for track numbers
#const highest = 15.
divisor(0..highest).

%bit and its remainder for highest(=15) tracknum
bit(highest, TrackNum, TrackNum) :- track(TrackNum).

%calculate remainders of other bits
bit(Bit-1, TrackNum, Remainder\(2**Bit)) :- bit(Bit, TrackNum, Remainder), Bit > 0.

%bit value is 1, if remainder divided by divisor is at least 1
bit_value(Bit, TrackNum, Remainder/(2**Bit)) :- bit(Bit, TrackNum, Remainder).

%map each bit to a from_to direction
from_to(DirFrom, DirTo, D) :- direction(DirFrom, D/4), direction(DirTo, D\4), divisor(D).

%use direction mapping and bit values to generate valid directions for each track
track_from_to(TrackNum, DirFrom, DirTo) :- bit_value(D, TrackNum, 1), from_to(DirFrom, DirTo, D).


% If there is a track_from_to with DirFrom equals DirTo, then we can move forward
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), DirFrom = DirTo, end(ID, _, Arr), T < Arr.
% using numbers of direction, we can calculate possible directions with DirFrom modulo DirTo for move_left or move_right; +4, because clingo struggles with modulo of negative values
% move_left is move_left if multiple DirTo exist
{ action(train(ID), move_left, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC != 1, end(ID, _, Arr), T < Arr.
% move_left is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1, end(ID, _, Arr), T < Arr.
% move_right is move_right if multiple DirTo exist
{ action(train(ID), move_right, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC != 1, end(ID, _, Arr), T < Arr.
% move_right is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1, end(ID, _, Arr), T < Arr.
% we could always wait (until time is over)
%{ action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, _, Arr), T < Arr.

%action_count(T, AC) 
%:- occupation(TID, _, T, _), AC = #count{ A : action(TID, A, T ) }, AC > 1.

% only one action for each train at a time step
:- action(train(ID), Action1, T), action(train(ID), Action2, T), Action1 != Action2.
%wait_action(T, AC) :- AC = #count{ T : action(TID, wait, T ) }, action(TID, A, T).

%max n wait actions
:- AC = #count{ T : action(TID, wait, T ) }, AC > 4.

%------------------------------------------------------------------------------------------------------------------------------------------------------%

%init train occupations on second time step
occupation(train(ID), (X,Y), Dep+1, Dir) :- start(ID, (X,Y), Dep, Dir).
%and action of the past for whatever reason TODO: check if it works for each start time
action(train(ID), wait, Dep) :- start(ID, _, Dep, _).
action(train(ID), move_forward, Dep+1) :- start(ID, _, Dep, _).

% regular move_forward if DirFrom = DirTo
occupation(train(ID), (X + XChange, Y + YChange), T+1, DirTo) :- occupation(train(ID), (X,Y), T, DirFrom), action(train(ID), move_forward, T+1), move_x_y(DirTo, XChange, YChange), track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), DirFrom = DirTo.
% move_forward is move_left if there is only one DirTo
occupation(train(ID), (X + XChange, Y + YChange), T+1, DirTo) :- occupation(train(ID), (X,Y), T, DirFrom), action(train(ID), move_forward, T+1), move_x_y(DirTo, XChange, YChange), track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.
% move_forward is move_right if there is only one DirTo
occupation(train(ID), (X + XChange, Y + YChange), T+1, DirTo) :- occupation(train(ID), (X,Y), T, DirFrom), action(train(ID), move_forward, T+1), move_x_y(DirTo, XChange, YChange), track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.

% regular move_left
occupation(train(ID), (X + XChange, Y + YChange), T+1, DirTo) :- occupation(train(ID), (X,Y), T, DirFrom), action(train(ID), move_left, T+1), direction(DirFrom, FromVal), ToVal = (FromVal + 1) \ 4, direction(DirTo, ToVal), move_x_y(DirTo, XChange, YChange).
% regular move_right
occupation(train(ID), (X + XChange, Y + YChange), T+1, DirTo) :- occupation(train(ID), (X,Y), T, DirFrom), action(train(ID), move_right, T+1), direction(DirFrom, FromVal), ToVal = (FromVal + 3) \ 4, direction(DirTo, ToVal), move_x_y(DirTo, XChange, YChange).

% just waiting
occupation(train(ID), (X, Y), T+1, Dir) :- occupation(train(ID), (X,Y), T, Dir), action(train(ID), wait, T+1).

% train has to be on track that exists
:- occupation(_, (X,Y), _, _), not cell((X,Y), _). 
:- occupation(_, (X,Y), _, _), cell((X,Y), 0).
% two trains cannot be on the same track on the same time
:- occupation(train(ID1), (X,Y), T, _), occupation(train(ID2), (X,Y), T, _), ID1 < ID2.
% or swap tiles within one time step
:- occupation(train(ID1), (X1,Y1), T, _), occupation(train(ID2), (X2,Y2), T, _), occupation(train(ID1), (X2,Y2), T+1, _), occupation(train(ID2), (X1,Y1), T+1, _), ID1 < ID2.
% no move for train after scheduled arrival
:- occupation(train(ID), _, T, _), end(ID, _, Arr), Arr < T.
:- action(train(ID), _, T), end(ID, _, Arr), Arr < T.
% train has to reach target...
:- not occupation(train(ID), (X,Y), _, _), end(ID, (X,Y), _).
% ... in time
:- occupation(train(ID), (X,Y), T, _), end(ID, (X,Y), Arr ), Arr < T.
% and no actions after destination reached
:- end(ID, _, Arr), action(train(ID), _, T), T > Arr.

%Minimize train journey times
%action_count(AC) :- AC = #count{ TID, A, T: action(TID, A, T) }.
%action_wait_count(AWC) :- AWC = #count{ TID, A, T: action(TID, T, T ), A = wait }.
%#minimize { AC@1: action_count(AC) }.
#minimize { 1, TID, A, T: action(TID, A, T) }.

%&sum { AWC } <= 1 :- action_wait_count(AWC).

%#show occupation/4.
#show action/3.
%#show action_count/2.
%#show wait_action/1.


%test
:- end(ID, _, T), action(train(ID), _, T).
