%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%intersection((X,Y), ID) -- ID is train-specific intersection
%intersection((X,Y), -1) :- cell((X,Y), Track), Track=2.
%intersection((X,Y), -1) :- cell((X,Y), Track), Track=4.
%intersection((X,Y), -1) :- cell((X,Y), Track), Track=5.
%intersection((X,Y), -1) :- cell((X,Y), Track), Track=6.

%Assigning Intersections
intersection((X,Y), -1) :- cell((X,Y), Track), Track!=0, Track!=32800, Track!=1025, Track!=4608, Track!=16386, Track!=72, Track!=2064, Track!=33825.
intersection((X,Y), ID) :- start(ID,(X,Y), _, _).
intersection((X,Y), ID) :- end(ID,(X,Y), _).

%%min_intersection((X,Y), ID) :- intersection((X,Y), ID), #min {(XX,YY):  intersection((XX,YY), _)} = (X,Y).
%%sec_min_intersection((X,Y), ID) :- intersection((X,Y), ID), #min {(XX,YY):  intersection((XX,YY), _), min_intersection((MX,MY), ID), (XX,YY)!=(MX,MY)} = (X,Y).

%min_intersection((X,Y), TID, 0) :- intersection((X,Y), TID), #min {(XX,YY):  intersection((XX,YY), _)} = (X,Y).
%section(IID) :- min_intersection((X,Y), TID, IID).
%%Not working yet iterativelly
%min_intersection((X,Y), TID, IID+1) :- intersection((X,Y), TID), #min {(XX,YY):  intersection((XX,YY), _), min_intersection((MX,MY), _, _), (XX,YY)!=(MX,MY)} = (X,Y),  #max {ID, 1: section(ID) } = IID, IID < 5.


%New approach for sections
% from intersection to intersection
% intersection(intersection_from_tuple, intersection_to_tuple, DirFrom, TID1, Time) TODO: remove duplicate intersection/4?
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=n, Y1=Y2, X1=X2+1.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=e, Y1=Y2-1, X1=X2.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=s, Y1=Y2, X1=X2-1.
intersection((X1,Y1), (X2,Y2), DirFrom, DirTo, TID1, 1) :- intersection((X1,Y1), TID1), cell((X1,Y1), Track1), intersection((X2,Y2), TID2), cell((X2,Y2), _), track_from_to(Track1, DirFrom, DirTo), DirTo=w, Y1=Y2+1, X1=X2.

% from intersection to cell
% section_cell(intersection_from_tuple, some_section_tuple, track_of_some_section_tuple)
% Track2 := Track of connecting cell for adding more cells later
% DirFrom := Direction the first intersection is entered
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=n, Y1=Y2, X1=X2+1, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=e, Y1=Y2-1, X1=X2, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=s, Y1=Y2, X1=X2-1, not intersection((X2,Y2), _).
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, TID) :- intersection((X1,Y1), TID), cell((X1,Y1), Track1), cell((X2,Y2), Track2), track_from_to(Track1, DirFrom, DirTo), DirTo=w, Y1=Y2+1, X1=X2, not intersection((X2,Y2), _).

% from section cell to other cell
% Track2 := Track of connecting cell for adding more cells later
% DirFrom := Direction the first intersection is entered
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=n, Y1=Y2, X1=X2+1, not intersection((X2,Y2), _).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=e, Y1=Y2-1, X1=X2, not intersection((X2,Y2), _).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=s, Y1=Y2, X1=X2-1, not intersection((X2,Y2), _).
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, TID) :- section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, TID), cell((X2,Y2), Track2), track_from_to(Track1, _, DirTo), DirTo=w, Y1=Y2+1, X1=X2, not intersection((X2,Y2), _).

% from section cell to intersection (to get arriving direction)
arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=n, Y1=Y2, X1=X2+1.
arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=e, Y1=Y2-1, X1=X2.
arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=s, Y1=Y2, X1=X2-1.
arriving_direction((X0,Y0), (X2,Y2), DirTo) :- section_cell((X0,Y0), (X1,Y1), Track1, _, _), intersection((X2,Y2), _), track_from_to(Track1, _, DirTo), DirTo=w, Y1=Y2+1, X1=X2.

section_cell(A, B, C, Track, DirFrom1, DirTo, TID1) :- section_cell(A, C, Track, DirFrom1, TID1), section_cell(B, C, Track, DirFrom2, TID2), A!=B, arriving_direction(A, B, DirTo).

% take only one combination of section_cell/4; use the "first" section_cell/3 intersection as the first intersection point
% section_cell((X1,Y1), (X2,Y2), C, Track, DirFrom1, TID1) :-  section_cell((X1,Y1), C, Track, DirFrom1, TID1), section_cell((X2,Y2), C, Track, DirFrom2, TID2), X1+Y1<X2+Y2.
% { section_cell((X1,Y1), (X2,Y2), C, Track, DirFrom1, TID1) } :-  section_cell((X1,Y1), C, Track, DirFrom1, TID1), section_cell((X2,Y2), C, Track, DirFrom2, TID2), X1<X2.

% % remove duplicate of each section_cell/4
% :- section_cell(A, B, C, Track, DirFrom, TID), section_cell(B, A, C, Track, DirFrom, TID).
% % each cell must in a section (unless it is an intersection)
% :- cell(C, Track), not section_cell(_, _, C, Track, _, _), not intersection(C, _).

%section_cell_count(A, B, SCC) :- SCC = #count{ C: section_cell(A, B, C, _) }, section_cell(A, B, _, _).
intersection(A, B, DirFrom, DirTo, TID, SCC+1) :- SCC = #count{ C: section_cell(A, B, C, _, DirFrom, DirTo, TID) }, section_cell(A, B, _, _, DirFrom, DirTo, TID).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Agent movement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% move(TID, A, B, ArrivalTime)
%{ move(TID, A, B, Dep + Duration) } :- start(TID, A, Dep, Dir), intersection(A, B, DirFrom, DirTo, TID, Duration).
move(TID, A, B, Dep + Duration) :- start(TID, A, Dep, Dir), intersection(A, B, DirFrom, DirTo, TID, Duration).
% move allowed if DirTo from incoming intersection equals a DirFrom of the destination intersection
move(TID, A, B, Arr + Duration) :- move(TID, X, A, Arr), intersection(X, A, _, DirTo, _, _), intersection(A, B, DirFrom, _, -1, Duration), DirTo=DirFrom.

% %redundant
% { move(TID, A, B, Arr + Duration) } :- move(TID, _, A, Arr), intersection(A, B, Dir, TID, Duration).

% only one move at a time step for same train
% :- move(TID, A, B, Arr), move(TID, A, C, Arr).
% :- move(TID1, A, B, Arr1), move(TID2, A, C, Arr2), TID1=TID2, Arr1=Arr2.
%((exactly one!))

% reach destination...
% :- end(TID, Dest, _), not move(TID, _, Dest, _).

% ... in time (TODO: is this necessary? maybe only statement below required)
% :- end(TID, Dest, ReqArr), move(TID, _, Dest, ActualArr), ReqArr <= ActualArr.

% ... don't move after
% :- end(TID, _, ReqArr), move(TID, _, _, Arr), ReqArr <= Arr.

mc(MC) :- MC = #count { TID, A, B, Arr, 1: move(TID, A, B, Arr) }.
:- MC = #count { TID, A, B, Arr, 1: move(TID, A, B, Arr) }, MC>10.

%#show intersection/2.
%#show intersection/6.
%#show section_cell/6.
#show move/4.
#show start/4.
#show mc/1.
%#show arriving_direction/3.