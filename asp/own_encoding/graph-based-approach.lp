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
cardinal_direction(n, 3).
cardinal_direction(e, 2).
cardinal_direction(s, 1).
cardinal_direction(w, 0).

% move direction (from cardinal direction change)
move_direction(0, move_forward).
move_direction(1, move_right).
move_direction(3, move_left).

% move_left or move_right is move_forward
is_move_forward(1, move_forward, move_forward). %if one move possible it is move_forward
is_move_forward(1, move_left, move_forward). %if one move possible it is move_forward
is_move_forward(1, move_right, move_forward). %if one move possible it is move_forward
is_move_forward(2, move_forward, move_forward). %if one move possible it is move_forward
is_move_forward(2, move_left, move_left). %if two moves possible it stays move_left
is_move_forward(2, move_right, move_right). %if two moves possible it stays move_right

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
from_to(DirFrom, DirTo, D) :- cardinal_direction(DirFrom, D/4), cardinal_direction(DirTo, D\4), divisor(D).

%use direction mapping and bit values to generate valid directions for each track
track_from_to(TrackNum, DirFrom, DirTo) :- bit_value(D, TrackNum, 1), from_to(DirFrom, DirTo, D).

%xy_change_direction(XDiff,YDiff,Dir,NumericDir) for x1-x2, y1-y2
%Dir: Direction after move ends
xy_change_direction(1,0,n,3).
xy_change_direction(0,-1,e,2).
xy_change_direction(-1,0,s,1).
xy_change_direction(0,1,w,0).

%extra arrival time due to malfunctions
malfunction_extra_time(ID, 0) :- train(ID).

%%%%%%%%%%%%%%%%%% Next try %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Assigning Intersections
%intersection((X,Y)
intersection((X,Y)) :- cell((X,Y), Track), Track!=0, Track!=32800, Track!=1025, Track!=4608, Track!=16386, Track!=72, Track!=2064.
intersection((X,Y)) :- start(_,(X,Y), _, _).
intersection((X,Y)) :- end(_,(X,Y), _).


% next to other intersection

% treat destination as section_cell in order to simplify move generation
section_cell((X1,Y1), (X2,Y2), (X2,Y2), Track2, DirFrom, DirTo, AdjustedMove) :-
    cell((X1,Y1), Track1), intersection((X1,Y1)),
    cell((X2,Y2), Track2), intersection((X2,Y2)), 
    track_from_to(Track1, DirFrom, DirTo), 
    xy_change_direction(X1-X2,Y1-Y2,DirTo,_),
    cardinal_direction(DirFrom, FromValue),
    cardinal_direction(DirTo, ToValue),
    move_direction((FromValue - ToValue + 4) \ 4, Move), %left/right/forward
    DTC = #count{ DirToC: track_from_to(Track1, DirFrom, DirToC) }, %for converting to move_forward
    is_move_forward(DTC, Move, AdjustedMove).

% through non-intersections

%section_cell(A, C, Track2, DirFrom, FromAction)
section_cell((X1,Y1), (X2,Y2), Track2, DirFrom, AdjustedMove) :- 
    cell((X1,Y1), Track1), intersection((X1,Y1)), 
    cell((X2,Y2), Track2), not intersection((X2,Y2)),
    track_from_to(Track1, DirFrom, DirTo),
    xy_change_direction(X1-X2,Y1-Y2,DirTo,_),
    cardinal_direction(DirFrom, FromValue),
    cardinal_direction(DirTo, ToValue),
    move_direction((FromValue - ToValue + 4) \ 4, Move),
    DTC = #count{ DirToC: track_from_to(Track1, DirFrom, DirToC) },
    is_move_forward(DTC, Move, AdjustedMove).

% from section cell to other cell
% Track2 := Track of connecting cell for adding more cells later
% DirFrom := Direction the first intersection is entered
section_cell((X0,Y0), (X2,Y2), Track2, DirFrom, Move) :- 
    section_cell((X0,Y0), (X1,Y1), Track1, DirFrom, Move), 
    cell((X2,Y2), Track2), not intersection((X2,Y2)),
    % cell connects to existing section_cell
    track_from_to(Track1, _, DirTo), xy_change_direction(X1-X2,Y1-Y2,DirTo,_).

% from section cell to intersection (to get arriving direction)
% DirTo := outgoing direction from section to other intersection
arriving_direction((X0,Y0), (X2,Y2), DirTo, Move) :- 
    section_cell((X0,Y0), (X1,Y1), Track1, _, Move), 
    intersection((X2,Y2)), 
    track_from_to(Track1, _, DirTo), 
    xy_change_direction(X1-X2,Y1-Y2,DirTo,_),
    (X0,Y0) != (X2,Y2).

% combine section_cells to get a connection between two intersections through all passed section cells
section_cell(A, B, C, Track, DirFrom1, DirTo, Move) :- 
    section_cell(A, C, Track, DirFrom1, Move), 
    section_cell(B, C, Track, DirFrom2, _), 
    arriving_direction(A, B, DirTo, Move).

%add Destination as section_cell (this is important to make connections without section_cells equal to connections with section_cells)
section_cell(A, B, B, Track, DirFrom, DirTo, Move):-
    section_cell(A, B, _, _, DirFrom, DirTo, Move),
    cell(B, Track).

% create intersection from section_cell connection and its cell count
intersection(A, B, DirFrom, DirTo, Move, SCC) :- 
    SCC = #count{ C: section_cell(A, B, C, _, DirFrom, DirTo, Move) }, 
    section_cell(A, B, _, _, DirFrom, DirTo, Move).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Agent movement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%first move from start
move(TID, (X1,Y1), B, LatestDep + 2, LatestDep + 2, Duration, StartDir, DirTo, Move) :- 
    start(TID, (X1,Y1), _, StartDir),
    LatestDep = #max { Dep: start(TID, (X1,Y1), Dep, StartDir) }, 
    intersection((X1,Y1), B, StartDir, DirTo, Move, Duration).

{ move(TID, (X1,Y1), B, Arr, Arr, Duration, DirFrom, DirTo, Move) } :- 
    move(TID, X, (X1,Y1), Dep, Arr, 0, _, DirFrom, _),
    intersection((X1,Y1), B, DirFrom, DirTo, Move, Duration),
    end(TID, _, ReqArr),
    Arr + Duration <= ReqArr + MalExTime,
    malfunction_extra_time(TID, MalExTime).

%%%%%%%% Malfunction Stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check if train has to start by checking first forced move forward
start(ID, A, Start-1, Dir) :- 
    Start = #min { T: forced_action(train(ID), move_forward, T) }, 
    forced_action(train(ID), move_forward, _), start(ID, A, _, Dir).

% if train has no forced move actions, start must be after last wait actions if it exists
start(ID, A, Start, Dir) :-
    Start = #max { T: forced_action(train(ID), wait, T) },
    not forced_action(train(ID), move_forward, _), start(ID, A, _, Dir).

%is train disabled at T?
%is_malfunction(TID, T, MalDur)
{ is_malfunction(TID, 0..EndT, 0) } :- global(EndT), train(TID).
is_malfunction(TID, T..T+Dur-1, Dur) :- clean_malfunction(TID, Dur, T).
% one is_malfunction per timestep 
:- global(EndT), train(TID), not is_malfunction(TID, 0..EndT, _).
:- train(TID), is_malfunction(TID, T, IsMal1), is_malfunction(TID, T, IsMal2), IsMal1!=IsMal2.

% we need to merge malfunctions that overlap or are included in other
malfunction_merge(TID, LastArr-T1, T1) :- 
    malfunction(TID, Dur1, T1), malfunction(TID, Dur2, T2),
    LastArr = #max { Dur1+T1; Dur2+T2 },
    (Dur1,T1)!=(Dur2,T2),
    T1<=T2,
    T1+Dur1>=T2.
 
overlap(TID, Dur1, T1, Dur2, T2) :- 
    malfunction(TID, Dur1, T1), malfunction(TID, Dur2, T2),
    (Dur1,T1)!=(Dur2,T2),
    T1<=T2,
    T1+Dur1>=T2.

clean_malfunction(TID, Dur, T):- malfunction_merge(TID, Dur, T).
clean_malfunction(TID, Dur, T):- 
    malfunction(TID, Dur, T), 
    not overlap(TID, _, _, Dur, T), 
    not overlap(TID, Dur, T, _, _).

% check for malfunctions to increase move duration

% no mal at Arr
move(TID, A, B, Dep, Arr+1, MovesLeft-1, DirFrom, DirTo, Move) :-
    is_malfunction(TID, Arr, Dur),
    move(TID, A, B, Dep, Arr, MovesLeft, DirFrom, DirTo, Move),
    Dur=0,
    MovesLeft > 0.

% mal at Arr
move(TID, A, B, Dep, Arr+1, MovesLeft, DirFrom, DirTo, Move) :-
    is_malfunction(TID, Arr, Dur),
    move(TID, A, B, Dep, Arr, MovesLeft, DirFrom, DirTo, Move),
    Dur>0,
    MovesLeft > 0.

%%%%%%%% Action Conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

action(train(TID), wait, 0..LatestDep) :- train(TID), LatestDep = #max { Dep: start(TID, (X1,Y1), Dep, StartDir) }. %start wait
action(train(TID), move_forward, LatestDep+1) :- train(TID), LatestDep = #max { Dep: start(TID, (X1,Y1), Dep, StartDir) }. %spawn move_forward
{ action(train(TID), Move, Dep) } :- move(TID, _, _, Dep, _, 0, _, _, Move). %convert moves to actions
{ action(train(TID), move_forward, Dep+1..Arr-1) } :- move(TID, _, _, Dep, Arr, 0, _, _, _). %fill move_forward in connections

% Enforce wait action for new malfunction
action(train(TID), wait, T..T+Dur-1) :- clean_malfunction(TID, Dur, T).

%%%%%%%%%% Integrity Constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Exactly one action at a time
:- action(TID, A1, T), action(TID, A2, T), A1!=A2.
:- end(TID, X, _), move(TID, _, X, _, Arr, 0, _, _, _), not action(train(TID), _, 0..Arr-1).

% no overlapping moves
:- move(TID, A1, B1, Dep1, Arr1, 0, DirFrom1, DirTo1, Move1), 
    move(TID, A2, B2, Dep2, Arr2, 0, DirFrom2, DirTo2, Move2),
    Arr1!=Arr2, Dep1!=Dep2, Arr1 > Dep2, Arr2 > Dep1.

% no moves to different directions at same time
:- move(TID, A1, B1, Dep, Arr1, 0, DirFrom1, DirTo1, Move1), 
    move(TID, A2, B2, Dep, Arr2, 0, DirFrom2, DirTo2, Move2), B1!=B2.

% reach destination...
:- end(TID, Dest, _), not move(TID, _, Dest, _, _, 0, _, _, _).

% ... don't move after
:- end(TID, _, ReqArr), move(TID, _, _, _, Arr, 0, _, _, _), ReqArr+TotalMalExTime <= Arr, TotalMalExTime = #max { MalExTime: malfunction_extra_time(TID, MalExTime) }.

% no mutliple trains at same intersection at same time
:- move(TID1, _, B, _, Arr, 0, _, _, _),  move(TID2, _, B, _, Arr, 0, _, _, _), TID1!=TID2.

% no trains going into opposite directions on same intersection in the same time period
:- move(TID1, A, B, _, Arr1, 0, _, _, _), move(TID2, B, A, _, Arr2, 0, _, _, _), move(TID1, _, A, _, Dep1, 0, _, _, _), move(TID2, _, B, _, Dep2, 0, _, _, _), Dep2 <= Dep1, Dep1 <= Arr2.
:- move(TID1, A, B, _, Arr1, 0, _, _, _), move(TID2, B, A, _, Arr2, 0, _, _, _), move(TID1, _, A, _, Dep1, 0, _, _, _), move(TID2, _, B, _, Dep2, 0, _, _, _), Dep2 <= Arr1, Arr1 <= Arr2.

%%%%%%%%%%%% Display %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Minimize train journey times
#minimize { 1, TID, A, T: action(TID, A, T) }.

#show action/3.

% To show actual executed moves
% chosen_move(TID, A, B, Dep, Arr, 0, DirFrom, DirTo, Move)
    % :- move(TID, A, B, Dep, Arr, 0, DirFrom, DirTo, Move).
% #show chosen_move/9.