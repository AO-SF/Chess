requireend lib/std/mem/memmove.s

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
; Create piece to test against
mov r1 PieceTypeKing
or r1 r0 r1
; Loop over squares (test piece in r1)
mov r0 0
label posGetKingSqLoopStart
; Grab piece on square and test for match
push8 r0
push8 r1
call posGetPieceOnSq
cmp r2 r0 r1
pop8 r1
pop8 r0
skipneq r2
jmp posGetKingSqFound
; Advance square and loop around
inc9 r0
mov r2 119 ; =~8
and r0 r0 r2
jmp posGetKingSqLoopStart
label posGetKingSqFound
ret ; r0 already contains square

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
