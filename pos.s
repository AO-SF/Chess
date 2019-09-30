requireend lib/curses/curses.s
requireend lib/std/io/fput.s
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

; use lowest 3 bits of piece as lookup, then if white xor with ColourWhite to make capital
db pieceChars '.','q','p','n','k','r','b','?'

db posArrayStartPos 37,43,38,33,60,38,43,37,0,0,0,0,0,0,0,0,42,42,42,42,42,42,42,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,74,74,74,74,74,74,74,74,0,0,0,0,0,0,0,0,69,75,70,65,92,70,75,69,0,0,0,0,0,0,0,0

db posDrawStmStr 'Side to move: ',0
db posDrawStmWhiteStr 'white',0
db posDrawStmBlackStr 'black',0

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

label posDraw ; draw ascii board to stdout
; Place cursor to start 8th rank
mov r0 0
mov r1 0
call cursesSetPosXY
; Loop over all rows, starting from Rank 8
mov r1 7 ; y
label posDrawYLoopStart
; Loop over all squares in this row, starting from File A
mov r0 0 ; x
label posDrawXLoopStart
; Print piece on this square
push8 r0
push8 r1
call posDrawSquareByXYRaw
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
; Print stm
call posDrawStmRaw
ret

label posDrawStm ; updates stm on screen
; Move cursor to correct place
mov r0 0
mov r1 8
call cursesSetPosXY
; Use posDrawStmRaw to do actual updating
jmp posDrawStmRaw

label posDrawStmRaw ; like posDrawStm but assumes cursor is already in correct position
; Print prefix string
mov r0 posDrawStmStr
call puts0
; Print colour string
mov r0 posDrawStmWhiteStr
mov r1 posStm
load8 r1 r1
mov r2 ColourBlack
cmp r1 r1 r2
skipneq r1
mov r0 posDrawStmBlackStr
call puts0
ret

label posDrawSquare ; (r0=sq) - moves cursor and draws character
; Extract y
mov r1 4
shr r1 r0 r1
; Mask x
mov r2 7
and r0 r0 r2
; Jump to xy version to do most of the work
jmp posDrawSquareByXY

label posDrawSquareByXY ; (r0=x, r1=y) - moves cursor and draws character
; Move cursor
push8 r0
push8 r1
mov r2 7
sub r1 r2 r1
call cursesSetPosXY
pop8 r1
pop8 r0
; Jump to raw function to do actual drawing
jmp posDrawSquareByXYRaw

label posDrawSquareByXYRaw ; (r0=x, r1=y) - assumes cursor is in correct position already
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

label posGetXStm ; returns side NOT to move in r0
mov r0 posStm
load8 r0 r0
mov r1 ColourBoth
xor r0 r0 r1
ret
