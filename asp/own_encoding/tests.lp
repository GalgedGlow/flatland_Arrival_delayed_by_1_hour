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
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), DirFrom = DirTo.
% using numbers of direction, we can calculate possible directions with DirFrom modulo DirTo for move_left or move_right; +4, because clingo struggles with modulo of negative values
% move_left is move_left if multiple DirTo exist
{ action(train(ID), move_left, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC != 1.
% move_left is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.
% move_right is move_right if multiple DirTo exist
{ action(train(ID), move_right, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC != 1.
% move_right is move_forward if exactly one DirTo exists
{ action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.
% we could always wait
{ action(train(ID), wait, T+1) } :- occupation(train(ID), _, T, _).


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

% integrity constraints - check what has to be transferred

% only 1 action at a time.
:- AC != 1, AC = #count{ A: action(TID, A, T ) }.
%:- action(train(ID), Action1, T), action(train(ID), Action2, T), Action1 != Action2.

% example
occupation(train(1), (1,1), 1, n).
cell((1,1), 49186).
track(49186).

%print
%modulo(D, M) :- divisor(D), M = 15\D.
%#show track_from_to/3.
#show action/3.
#show occupation/4.
%#show move_x_y/3.
%#show cell/2.
%#show bit_value/3.

TODO: move this into main encoding!