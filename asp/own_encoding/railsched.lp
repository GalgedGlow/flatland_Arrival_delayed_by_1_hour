malfunction_extra_time(ID, 0) :- train(ID).

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
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), DirFrom = DirTo, end(ID, _, Arr), malfunction_extra_time(ID, MET), T < Arr + MET.
% using numbers of direction, we can calculate possible directions with DirFrom modulo DirTo for move_left or move_right; +4, because clingo struggles with modulo of negative values
% move_left is move_left if multiple DirTo exist
{ action(train(ID), move_left, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1, end(ID, _, Arr), malfunction_extra_time(ID, MET), T < Arr + MET.
% move_left is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1, end(ID, _, Arr), malfunction_extra_time(ID, MET), T < Arr + MET.
% move_right is move_right if multiple DirTo exist
{ action(train(ID), move_right, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1, end(ID, _, Arr), malfunction_extra_time(ID, MET), T < Arr + MET.
% move_right is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1, end(ID, _, Arr), malfunction_extra_time(ID, MET), T < Arr + MET.
% we could always wait (until time is over)
%{ action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, _, Arr), T < Arr, AC = #count{ 1, TA, TID : action(TID, wait, TA ) }, AC < 5.
%{ action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, _, Arr), T < Arr.


%action_count(T, AC) 
%:- occupation(TID, _, T, _), AC = #count{ A : action(TID, A, T ) }, AC > 1.

% only one action for each train at a time step
:- action(train(ID), Action1, T), action(train(ID), Action2, T), Action1 != Action2. %must always be true!!
%wait_action(T, AC) :- AC = #count{ T : action(TID, wait, T ) }, action(TID, A, T).

%max n wait actions
%wait_count(AC, TID2, T2) :- AC = #count{ 1, T, TID : action(TID, wait, T ) }, action(TID2, wait, T2 ), AC > 1.
% wait_count(AC, TID2, T2) :- AC = #count{ 1, T, TID : action(TID, wait, T) }, action(TID2, wait, T2).

%------------------------------------------------------------------------------------------------------------------------------------------------------%

%init train occupations on second time step
occupation(train(ID), (X,Y), Dep+1, Dir) :- start(ID, (X,Y), Dep, Dir).
%and action of the past
action(train(ID), wait, 0..Dep) :- start(ID, _, Dep, _).
action(train(ID), move_forward, Dep+1) :- start(ID, _, Dep, _), not action(train(ID), wait, Dep+1).

%Attempt: voluntary wait
%dep(Wait+1, ID) :- Wait = #max { TT: action(train(ID), wait, TT) }, action(train(ID), wait, T).
%occupation(train(ID), (X,Y), Dep, Dir) :- dep(Dep, ID), start(ID, (X,Y), _, Dir).
%action(train(ID), move_forward, Dep) :- dep(Dep, ID), start(ID, _, _, _).

%combine three lines
%occupation(train(ID), (X,Y), WaitMax+1, Dir), action(train(ID), move_forward, WaitMax+1)
% :- WaitMax = #max { TT: action(train(ID), wait, TT) }, action(train(ID), wait, T), start(ID, (X,Y), _, Dir).


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
:- occupation(_, (X,Y), _, _), not cell((X,Y), _). % okay
:- occupation(_, (X,Y), _, _), cell((X,Y), 0). % okay
% two trains cannot be on the same tile on the same time
:- occupation(train(ID1), (X,Y), T, _), occupation(train(ID2), (X,Y), T, _), ID1 < ID2. % has to still hold
% or swap tiles within one time step
:- occupation(train(ID1), (X1,Y1), T, _), occupation(train(ID2), (X2,Y2), T, _), occupation(train(ID1), (X2,Y2), T+1, _), occupation(train(ID2), (X1,Y1), T+1, _), ID1 < ID2.% has to still hold
% train has to reach target, time constraint is applied, by action generation
:- not occupation(train(ID), (X,Y), _, _), end(ID, (X,Y), _). % correct
%remove actions after reaching destination
arrival(ID, ArrActual) :- end(ID, (X,Y), _), occupation(train(ID), (X,Y), ArrActual, _).
:- arrival(ID, 	ArrActual), action(train(ID), _, AfterArrival), AfterArrival > ArrActual. % should be fine

%Minimize train journey times
#minimize { 1, TID, A, T: action(TID, A, T) }.

%convert forced_action from malfunctions to action in order to enforce them.
action(TID, A, T) :- forced_action(TID, A, T).

%#show occupation/4.
#show action/3.
