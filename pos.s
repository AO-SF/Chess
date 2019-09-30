requireend lib/std/mem/memmove.s

const ColourWhite        32 ; 0010 0000
const ColourBlack        64 ; 0100 0000
const ColourBoth         96 ; 0110 0000

const PieceFlagNotSlider  8 ; 0000 1000
const PieceFlagKing      16 ; 0001 0000

const PieceTypeNone       0 ; 0000 0000
const PieceTypePawn      10 ; 0000 1010
const PieceTypeKnight    11 ; 0000 1011
const PieceTypeBishop     6 ; 0000 0110
const PieceTypeRook       5 ; 0000 0101
const PieceTypeQueen      1 ; 0000 0001
const PieceTypeKing      28 ; 0001 1100

const PN                  0 ; 0000 0000
const PWP                42 ; 0010 1010
const PWN                43 ; 0010 1011
const PWB                38 ; 0010 0110
const PWR                37 ; 0010 0101
const PWQ                33 ; 0010 0001
const PWK                60 ; 0011 1100
const PBP                74 ; 0100 1010
const PBN                75 ; 0100 1011
const PBB                70 ; 0100 0110
const PBR                69 ; 0100 0101
const PBQ                65 ; 0100 0001
const PBK                92 ; 0101 1100

db posArrayStartPos 37,43,38,33,60,38,43,37,0,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,74,74,74,74,74,74,74,74,0,0,0,0,0,0,0,0,69,75,70,65,92,70,75,69,0,0,0,0,0,0,0,0

ab posArray 128
ab posStm 1

label posReset ; reset board to start position
; Simply copy pre-initialised array of start position into board array
mov r0 posArray
mov r1 posArrayStartPos
mov r2 128
call memmove
; Set stm=white
mov r0 posStm
mov r1 ColourWhite
store8 r0 r1
ret

label posGetKingSq ; (r0=colour) - places king sq into r0
; TODO: this - loop over board looking for king piece of correct colour
mov r0 0
ret

label posGetKingSqXStm ; =posGetKingSq(xstm)
call posGetXStm
jmp posGetKingSq ; this function will return for us

label posGetXStm ; returns side NOT to move in r0
mov r0 posStm
load8 r0 r0
mov r1 ColourBoth
xor r0 r0 r1
ret

label posGetPieceOnXY ; (r0=x, r1=y) - returns piece in r0
call sqMake ; convert x and y to square
jmp posGetPieceOnSq ; this function will return for us

label posGetPieceOnSq ; (r0=square) - returns piece in r0. note: only uses r0 and r5 (scratch reg) so caller does not need to protect any others
call posGetSqPtr
load8 r0 r0
ret

label posGetSqPtr ; (r0=square) - returns ptr (in posArray) in r0. note: only uses r0 and r5 (scratch reg) so caller does not need to protect any others
mov r5 posArray
add r0 r0 r5
ret
