s" ../input11" r/o open-file throw Value fd-in
0 value len
create input
input 230000 fd-in read-line throw drop dup allot to len

: forthify ( addr u )
    bounds DO
        ',' i c@ = IF
            bl i c!
        THEN
    LOOP ;

input len forthify 

\ a N-S, b SE-NW, c SW-NE
variable a 0 a !
variable b 0 b !
variable c 0 c !

( p c c )
: norm-two-dir
    2dup @ swap @ * 0> IF
        dup @ 0> IF
            -1 swap +! -1 swap +! -1 swap +!
        ELSE
            1 swap +! 1 swap +! 1 swap +!
        THEN
    ELSE
        2drop drop
    THEN ;

: norm
    c a b norm-two-dir
    b a c norm-two-dir
    a b c norm-two-dir ;

variable pmax 0 pmax !

: 3abs+ abs swap abs rot abs + + ;
: 3@ @ swap @ rot @ ;
: max! tuck @ max swap ! ;

: norm-and-update norm a b c 3@ 3abs+ pmax max! ;

: n  -1 a +! norm-and-update ;
: s   1 a +! norm-and-update ;
: ne  1 c +! norm-and-update ;
: nw  1 b +! norm-and-update ;
: se -1 b +! norm-and-update ;
: sw -1 c +! norm-and-update ; cr \ because redefined

input len evaluate 

." Final distance: " a b c 3@ 3abs+ 6 .r cr
." Max   distance: " pmax @ 6 .r cr

bye    