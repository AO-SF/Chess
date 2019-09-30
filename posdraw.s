requireend lib/curses/curses.s
requireend lib/std/io/fput.s

; use lowest 3 bits of piece as lookup, then if white xor with ColourWhite to make capital
db pieceChars '.','q','p','n','k','r','b','?'

db posDrawStmStr 'Side to move: ',0
db posDrawStmWhiteStr 'white',0
db posDrawStmBlackStr 'black',0

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
call posGetPieceOnXY
; Use lowest 3 bits of piece as unique index into array of characters
mov r1 7
and r1 r0 r1
mov r2 pieceChars
add r1 r1 r2
load8 r1 r1
; Make character capital if a white piece
mov r2 ColourWhite
and r2 r0 r2
xor r0 r1 r2
; Print character
call putc0
ret
