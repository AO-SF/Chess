db movementTableStarts 0,10,0,1,10,14,19 ; use lowest 3 bits of piece as index into this array, provides index to start from in movementSteps array
dw movementSteps 0,-33,-31,-18,-14,14,18,31,33,0,-17,-15,15,17,-16,-1,1,16,0,-17,-15,15,17,0 ; list of movement steps/deltas for each piece. only supports knights, bishops, rooks, queens and kings (no castling)

label search ; returns move in r0
; TODO: Generate other moves: pawns (all types), castling
; Loop over all from-squares
mov r0 0 ; fromSq=A1
label searchFromSqLoopStart
; Grab piece on from sq (place fromPiece in r1)
push8 r0
call posGetPieceOnSq
mov r1 r0
pop8 r0
; If piece is not friendly then skip
mov r2 posStm
load8 r2 r2
and r2 r1 r2
cmp r2 r2 r2
skipneqz r2
jmp searchFromSqLoopContinue
; Lookup start index into movementSteps array (placing current step ptr into r2)
mov r2 7
and r2 r1 r2
mov r3 movementTableStarts
add r2 r2 r3
load8 r2 r2
add r2 r2 r2 ; double offset due to 16 bit array entries
mov r3 movementSteps
add r2 r2 r3
; Step-index loop over possible move steps for this piece type (i.e. all possible 'directions')
label searchMovementStepLoopStart
; Check for end of steps due to 0 step terminator
load16 r3 r2
cmp r4 r3 r3
skipneqz r4
jmp searchMovementStepLoopEnd
; to-sq loop start (to sq in r3)
mov r3 r0 ; start with toSq=fromSq
label searchMovementToSqLoopStart
; toSq+=step
load16 r4 r2
add r3 r3 r4
; Check toSq is valid (i.e. not off the board), if not then break out of loop
mov r4 136
and r4 r3 r4
cmp r4 r4 r4
skipeqz r4
jmp searchMovementToSqLoopEnd
; If piece on toSq is friendly then cannot capture or move beyond, so break out of loop
push8 r0
mov r0 r3
call posGetPieceOnSq ; special function which does not use regs
mov r4 r0 ; to-piece is in r4 (for now only)
pop8 r0
mov r5 posStm
load8 r5 r5
and r4 r4 r5
cmp r4 r4 r4
skipeqz r4
jmp searchMovementToSqLoopEnd
; Create move (move in r4)
mov r4 r0
mov r5 7
shl r4 r4 r5
or r4 r4 r3
; Make move
push8 r0
push8 r1
push16 r2
push8 r3
push16 r4
mov r0 r4
call makeMove
mov r5 r0
pop16 r4
pop8 r3
pop16 r2
pop8 r1
pop8 r0
push8 r5 ; save capPiece on stack for now (used by undoMove and other logic)
; Is king left attacked (i.e. in check)?
; TODO: this - if so, skip 'recursive search' part and skip straight to 'undo move'
; Recursive search
; TODO: this
; Undo move
pop8 r5 ; grab capPiece
push8 r5 ; also save capPiece again for later
push8 r0
push8 r1
push16 r2
push8 r3
mov r0 r4
mov r1 r5
call undoMove
pop8 r3
pop16 r2
pop8 r1
pop8 r0
; If move captured a piece then end of ray so break out of loop
pop8 r5 ; grab capPiece
cmp r5 r5 r5
skipeqz r5
jmp searchMovementToSqLoopEnd
; TODO: this
; If moving piece is not a slider, break out of loop
mov r5 PieceFlagNotSlider
and r5 r1 r5
cmp r5 r5 r5
skipeqz r5
jmp searchMovementToSqLoopEnd
; Loop again to try next toSq in this direction
jmp searchMovementToSqLoopStart
label searchMovementToSqLoopEnd
; Advance to next step index to try a new direction
inc2 r2 ; 16 bit array entries
jmp searchMovementStepLoopStart
label searchMovementStepLoopEnd
; Final square? If so, break out of from-sq loop
label searchFromSqLoopContinue
mov r5 119
cmp r5 r0 r5
skipneq r5
jmp searchFromSqLoopEnd
; Increment from-sq for next iteration
inc9 r0
mov r5 119 ; =~8
and r0 r0 r5
jmp searchFromSqLoopStart
label searchFromSqLoopEnd
; For now simply return invalid move until above is finished
mov r0 MoveInvalid ; TODO: update this when above ready
ret
