%divisors of each direction
direction(n, 3).
direction(e, 2).
direction(s, 1).
direction(w, 0).

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

%examples
track(1025).
track(32800).
track(2136).

%print
%modulo(D, M) :- divisor(D), M = 15\D.
#show track_from_to/3.
%#show bit_value/3.
