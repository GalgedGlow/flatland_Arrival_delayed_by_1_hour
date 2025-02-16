%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input and initial Conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Arranging Sections and Intersections %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Assigning Intersections
%intersection((X,Y), ID) -- ID is train-specific intersection
intersection((X,Y), -1) :- cell((X,Y), Track), Track!=0, Track!=32800, Track!=1025, Track!=4608, Track!=16386, Track!=72, Track!=2064, Track!=33825.
intersection((X,Y), ID) :- start(ID,(X,Y), _, _).
intersection((X,Y), ID) :- end(ID,(X,Y), _).

% from intersection to intersection
% intersection(intersection_from_tuple, intersection_to_tuple, DirFrom, TID1, Time)
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=n, Y1=Y2, X1=X2+1.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=e, Y1=Y2-1, X1=X2.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=s, Y1=Y2, X1=X2-1.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=w, Y1=Y2+1, X1=X2.

% from intersection to cell
% section_cell(intersection_from_tuple, some_section_tuple, track_of_some_section_tuple)
% Track2 := Track of connecting cell for adding more cells later
% DirFrom := Direction the first intersection is entered
% SCID :- rank/order of cell in section
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID, 1) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=n, Y1=Y2, X1=X2+1, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID, 1) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=e, Y1=Y2-1, X1=X2, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID, 1) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=s, Y1=Y2, X1=X2-1, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID, 1) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=w, Y1=Y2+1, X1=X2, not intersection((X2,Y2), _).

% from section cell to other cell
% Track2 := Track of connecting cell for adding more cells later
% DirFrom := Direction the first intersection is entered
% SCID :- rank/order of cell in section
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID+1) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID, SCID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=n, Y1=Y2, X1=X2+1, not intersection((X2,Y2), _), not section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID-1).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID+1) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID, SCID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=e, Y1=Y2-1, X1=X2, not intersection((X2,Y2), _), not section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID-1).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID+1) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID, SCID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=s, Y1=Y2, X1=X2-1, not intersection((X2,Y2), _), not section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID-1).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID+1) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID, SCID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=w, Y1=Y2+1, X1=X2, not intersection((X2,Y2), _), not section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID-1).

:- section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID1), section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID, SCID2), SCID1!=SCID2.
%#maximize { 1, A, C, Track, DirFrom, TID, SCID: section_cell(A, C, Track, DirFrom, TID, SCID) }.

% % from section cell to intersection (to get arriving direction)
% % DirTo := outgoing direction from section to other intersection
% arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=n, Y1=Y2, X1=X2+1.
% arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=e, Y1=Y2-1, X1=X2.
% arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=s, Y1=Y2, X1=X2-1.
% arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=w, Y1=Y2+1, X1=X2.

% % combine section_cells to get a connection between two intersections through all passed section cells
% section_cell(A, B, C, Track, DirFrom1, DirTo, TID1, SCID) :- section_cell(A, C, Track, DirFrom1, TID1, SCID), section_cell(B, C, Track, DirFrom2, TID2, SCID), A!=B, arriving_direction(A, B, DirTo).

% % create intersection from section_cell connection and its cell count
% intersection(A, B, DirFrom, DirTo, TID, SCC+1, SCID) :- SCC = #count{ C: section_cell(A, B, C, _, DirFrom, DirTo, TID, SCID) }, section_cell(A, B, _, _, DirFrom, DirTo, TID, SCID).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Agent movement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % move(TID, A, B, ArrivalTime)
% % Always move from start as only one direction is possible
% move(TID, A, B, Dep + Duration + 1, StartDir) :- start(TID, A, Dep, StartDir), intersection(A, B, DirFrom, _, TID, Duration), StartDir=DirFrom.
% % move allowed if DirTo from incoming intersection equals a DirFrom of the destination intersection
% { move(TID, A, B, Arr + Duration, DirFrom) } :- move(TID, X, A, Arr, _), intersection(X, A, _, DirTo, _, _), intersection(A, B, DirFrom, _, -1, Duration), DirTo=DirFrom, end(TID, _, ReqArr), Arr + Duration <= ReqArr.

% % %redundant
% % { move(TID, A, B, Arr + Duration) } :- move(TID, _, A, Arr), intersection(A, B, Dir, TID, Duration).

% % only one move at a time step for same train
% :- move(TID, A, B, Arr, _), move(TID, A, C, Arr, _), B!=C.
% %((exactly one!))


% % reach destination...
% :- end(TID, Dest, _), not move(TID, _, Dest, _, _).

% % ... in time (TODO: is this necessary? maybe only statement below required)
% :- end(TID, Dest, ReqArr), move(TID, _, Dest, ActualArr, _), ReqArr <= ActualArr.

% % ... don't move after
% :- end(TID, _, ReqArr), move(TID, _, _, Arr, _), ReqArr <= Arr.

% % mc(MC) :- MC = #count { TID, A, B, Arr, 1: move(TID, A, B, Arr) }.
% % :- MC = #count { TID, A, B, Arr, 1: move(TID, A, B, Arr) }, MC>10.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Optimize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ma(MA) :- MA = #max { Arr: move(TID, A, B, Arr, DirFrom) }.
#minimize { MA: ma(MA) }.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Conversion to Actions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%xy_change_direction(XDiff,YDiff,Dir,NumericDir) for x1-x2, y1-y2
xy_change_direction(1,0,n,3).
xy_change_direction(0,-1,e,2).
xy_change_direction(-1,0,s,1).
xy_change_direction(0,1,w,0).

% Create Move Action for moves at the intersection it starts from

% % initial actions for each train
% action(train(ID), wait, Dep) :- start(ID, _, Dep, _).
% action(train(ID), move_forward, Dep+1) :- start(ID, _, Dep, _).


% cell1=intersection, cell2=non_intersection bordering intersection and is section_cell for move from intersection to other intersection
% move_left
% move(TID, (X1,Y1), B, Arr), intersection((X1,Y1), TIDX), cell((X2,Y2), Track), |X1+Y1-X2-Y2|=1, section_cell((X1,Y1), B, (X2,Y2), Track, DirFrom, DirTo, TIDX)
% track_from_to(TrackNum, DirFrom, DirTo), direction(DirFrom, FromVal), direction(DirTo, ToVal), (FromVal - ToVal + 4) \ 4 = 3


% action(train(TID), move_left, Arr-Dur) :- move(TID, (X1,Y1), B, Arr), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _), 
% intersection((X1,Y1), _, _, _, _, Dur), cell((X1,Y1), TrackNum), xy_change_direction(X1-X2, Y1-Y2, DirTo, ToVal),
% track_from_to(TrackNum, DirFrom, DirTo), direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1.


%%% from intersection to intersection

% normal move_forward
action(train(TID), move_forward, Arr-1) :- move(TID, A, B, Arr, DirFrom),  intersection(A, B, DirFrom, DirTo, _, 1), DirFrom=DirTo.

% left is move_left
action(train(TID), move_left, Arr-1) :- move(TID, A, B, Arr, DirFrom),  intersection(A, B, DirFrom, DirTo, _, 1), cell(A, TrackNum), direction(DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1.

% left is move_forward
action(train(TID), move_forward, Arr-1) :- move(TID, A, B, Arr, DirFrom),  intersection(A, B, DirFrom, DirTo, _, 1), cell(A, TrackNum), direction(DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.

% right is move_right
action(train(TID), move_right, Arr-1) :- move(TID, A, B, Arr, DirFrom),  intersection(A, B, DirFrom, DirTo, _, 1), cell(A, TrackNum), direction(DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1.

% right is move_forward
action(train(TID), move_forward, Arr-1) :- move(TID, A, B, Arr, DirFrom),  intersection(A, B, DirFrom, DirTo, _, 1), cell(A, TrackNum), direction(DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.

%%% from intersection to section_cell

% normal move_forward
action(train(TID), move_forward, Arr-Dur) :- move(TID, (X1,Y1), B, Arr, DirFrom), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _, _),
intersection((X1,Y1), B, _, _, _, Dur), xy_change_direction(X1-X2, Y1-Y2, DirTo, _), DirFrom=DirTo.

% left is move_left
action(train(TID), move_left, Arr-Dur) :- move(TID, (X1,Y1), B, Arr, DirFrom), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _, _),
intersection((X1,Y1), B, _, _, _, Dur), cell((X1,Y1), TrackNum), xy_change_direction(X1-X2, Y1-Y2, DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1.

% left is move_forward
action(train(TID), move_forward, Arr-Dur) :- move(TID, (X1,Y1), B, Arr, DirFrom), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _, _),
intersection((X1,Y1), B, _, _, _, Dur), cell((X1,Y1), TrackNum), xy_change_direction(X1-X2, Y1-Y2, DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 3, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.

% right is move_right
action(train(TID), move_right, Arr-Dur) :- move(TID, (X1,Y1), B, Arr, DirFrom), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _, _), 
intersection((X1,Y1), B, _, _, _, Dur), cell((X1,Y1), TrackNum), xy_change_direction(X1-X2, Y1-Y2, DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC > 1.

% right is move_forward
action(train(TID), move_forward, Arr-Dur) :- move(TID, (X1,Y1), B, Arr, DirFrom), section_cell((X1,Y1), B, (X2,Y2), _, DirFrom, _, _, _), 
intersection((X1,Y1), B, _, _, _, Dur), cell((X1,Y1), TrackNum), xy_change_direction(X1-X2, Y1-Y2, DirTo, ToVal),
direction(DirFrom, FromVal), (FromVal - ToVal + 4) \ 4 = 1, DTC = #count{ DirToC: track_from_to(TrackNum, DirFrom, DirToC) }, DTC = 1.


%use SCID to fill out move_forward actions

% do move_forward if cell only allows one direction!
% { action(train(ID), move_forward, T+1) } :- track_from_to(TrackNum, DirFrom, DirTo), cell((X,Y), TrackNum), occupation(train(ID), (X,Y), T, DirFrom), DirFrom = DirTo.


%action(train(TID), move_forward, Arr+1) :- move(TID, (X1,Y1), _, Arr), cell((X,Y), Track), track_from_to(Track, DirFrom, DirTo), cell((X2,Y2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show intersection/2.
%#show start/4.
%#show mc/1.
%#show ma/1.
#show action/3.
#show move/5.
#show section_cell/6.