requireend lib/std/io/fput.s
requireend lib/std/mem/memmove.s

const ColourWhite        32 ; 0010 0000
const ColourBlack        64 ; 0100 0000

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

; use lowest 3 bits of piece as lookup, then if white xor with ColourWhite to make capital
db pieceChars '.','q','p','n','k','r','b','?'

db posArrayStartPos 37,43,38,33,60,38,43,37,0,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,74,74,74,74,74,74,74,74,0,0,0,0,0,0,0,0,69,75,70,65,92,70,75,69,0,0,0,0,0,0,0,0

ab posArray 128

label posReset ; reset board to start position
; Simply copy pre-initialised array of start position into board array
mov r0 posArray
mov r1 posArrayStartPos
mov r2 128
call memmove
ret

label posDraw ; draw ascii board to stdout
; Loop over all rows, starting from Rank 8
mov r1 7 ; y
label posDrawYLoopStart
; Loop over all squares in this row, starting from File A
mov r0 0 ; x
label posDrawXLoopStart
; Print piece on this square
push8 r0
push8 r1
call posDrawSquareRaw
pop8 r1
pop8 r0
; Printed all squares in this row?
mov r5 7
cmp r5 r0 r5
skipneq r5
jmp posDrawXLoopEnd
; Jump back to start of x-loop
inc r0
jmp posDrawXLoopStart
label posDrawXLoopEnd
; Print a new line at the end of this row
push8 r1
mov r0 '\n'
call putc0
pop8 r1
; Printed all rows?
cmp r5 r1 r1
skipneqz r5
jmp posDrawYLoopEnd
; Jump back to start of y-loop
dec r1
jmp posDrawYLoopStart
label posDrawYLoopEnd
ret

label posDrawSquareRaw ; (r0=x, r1=y) - assumes cursor is in correct position already
; Load piece on this square
mov r2 16
mul r2 r2 r1 ; y*16
add r2 r2 r0 ; +x
mov r5 posArray
add r2 r2 r5
load8 r2 r2
; Use lowest 3 bits of piece as unique index into array of characters
mov r5 7
and r5 r2 r5
mov r4 pieceChars
add r5 r5 r4
load8 r3 r5
; Make character capital if a white piece
mov r5 ColourWhite
and r5 r2 r5
xor r0 r3 r5
; Print character
call putc0
ret
