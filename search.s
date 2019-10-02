db movementTableStarts 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,14,19,0,0,0,24,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,10,0,0,0,14,19,0,0,0,28,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,14,19,0,0,0,24,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,10,0,0,0,14,19,0,0,0,28,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; use 8-bit piece as index into this array to lookup index to start at in movementSteps array. this table could obviously be condensed considerably, however read-only space is cheap so this is a good trade off to save instructions when generating moves

dw movementSteps 0,-33,-31,-18,-14,14,18,31,33,0,-17,-15,15,17,-16,-1,1,16,0,-17,-15,15,17,0,16,15,17,0,-16,-17,-15,0 ; list of movement steps/deltas for each piece. indexes: knight 1, queen/king 10, rook 14, bishop 19, white pawn 24, black pawn 28

const SearchModeSearch 0 ; search for best move, returning move in r0
const SearchModeListMoves 1 ; print list of legal moves for current position
ab searchMode 1

ab searchDepth 1
aw searchLeafCount 1 ; count of all depth=0 nodes

label searchList ; print all legal moves
mov r0 searchMode
mov r1 SearchModeListMoves
store8 r0 r1
jmp searchCommon

label search ; returns move in r0
mov r0 searchMode
mov r1 SearchModeSearch
store8 r0 r1
jmp searchCommon

label searchPerft ; (r0=depth) - returns count in r0
; Set search depth
mov r1 searchDepth
store8 r1 r0
; Reset global counter
mov r0 searchLeafCount
mov r1 0
store16 r0 r1
; Set search mode (reusing search mode)
mov r0 searchMode
mov r1 SearchModeSearch
store8 r0 r1
; Call searchCommon
call searchCommon
; Return global counter
mov r0 searchLeafCount
load16 r0 r0
ret

label searchCommon ; search (returning move in r0) or print legal moves
; Leaf node?
mov r0 searchDepth
load8 r0 r0
cmp r0 r0 r0
skipeqz r0
jmp searchNotLeafNode
; Increment leaf counter
mov r1 searchLeafCount
load16 r2 r1
inc r2
store16 r1 r2
; End of leaf node code
mov r0 MoveInvalid
ret
label searchNotLeafNode
; TODO: Generate other moves: pawns (promotions and en-passent captures), castling
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
mov r2 movementTableStarts
add r2 r2 r1
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
mov r4 r0 ; to-piece is in r4 (for now and next section only)
pop8 r0
mov r5 posStm
load8 r5 r5
and r5 r4 r5
cmp r5 r5 r5
skipeqz r5
jmp searchMovementToSqLoopEnd
; Special logic for pawns: straight moves cannot be captures, while diagonal moves must be captures
push8 r4 ; protect toPiece
mov r5 PieceTypeMask
and r4 r1 r5
mov r5 PieceTypePawn
cmp r5 r4 r5
pop8 r4 ; restore toPiece
skipeq r5
jmp searchPawnMoveTestEnd ; skip test if from piece not pawn
cmp r4 r4 r4
mov r5 1
skipneqz r4
mov r5 0 ; r5 now contains 1 if capture, 0 if not
push8 r5
load16 r4 r2 ; load current step value
mov r5 1
and r4 r4 r5 ; r4 now contains 1 if diagonal move, 0 if straight
pop8 r5
xor r4 r4 r5
cmp r4 r4 r4 ; 0 is legal, 1 is illegal
skipeqz r4
jmp searchMovementToSqLoopEnd
label searchPawnMoveTestEnd
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
push16 r5 ; save makeMove return value on stack for now (used by undoMove and other logic)
; Is king left attacked (i.e. in check)?
; TODO: if move was castling, extra squares need testing
push8 r0
push8 r1
push16 r2
push8 r3
push16 r4
call posGetKingSqXStm
call isSqAttackedByStm
mov r5 r0
pop16 r4
pop8 r3
pop16 r2
pop8 r1
pop8 r0
cmp r5 r5 r5
skipeqz r5
jmp searchSwitchEnd ; jump straight to undoMove
; Switch based on mode
mov r5 searchMode
load8 r5 r5
cmp r5 r5 r5
skipneqz r5
jmp searchSwitchModeSearch
jmp searchSwitchModeListMoves
; Print move (mode = list moves)
label searchSwitchModeListMoves
push8 r0
push8 r1
push16 r2
push8 r3
push16 r4
mov r0 r4
call movePrint
mov r0 ' '
call putc0
pop16 r4
pop8 r3
pop16 r2
pop8 r1
pop8 r0
jmp searchSwitchEnd
; Recursive search (mode = search)
label searchSwitchModeSearch
push8 r0
push8 r1
push16 r2
push8 r3
push16 r4
call searchCommon ; TODO: better (alpha-beta)
pop16 r4
pop8 r3
pop16 r2
pop8 r1
pop8 r0
jmp searchSwitchEnd
; End of mode switch statment
label searchSwitchEnd
; Undo move
pop16 r5 ; grab makeMove return value
push16 r5 ; also save it again for later
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
pop16 r4 ; grab makeMove return value and extract capPiece
mov r5 255
and r4 r4 r5
cmp r4 r4 r4
skipeqz r4
jmp searchMovementToSqLoopEnd
; Special case of step below to support double first move for pawns
mov r4 PieceTypeMask
mov r5 PieceTypePawn
and r4 r1 r4
cmp r4 r4 r5
skipeq r4
jmp searchDoublePawnTestEnd ; not a pawn moving
mov r4 PieceFlagVirgin
and r4 r1 r4
cmp r4 r4 r4
skipneqz r4
jmp searchMovementToSqLoopEnd ; pawn had already moved before we moved it during above makemove/undomove pair
load16 r5 r2 ; load current step value
mov r4 1
and r4 r4 r5
cmp r4 r4 r4
skipeqz r4
jmp searchMovementToSqLoopEnd ; diagonal move
add r5 r0 r5
cmp r5 r3 r5
skipeq r5
jmp searchMovementToSqLoopEnd ; not first iteration of toSq loop?
jmp searchMovementToSqLoopStart ; pawn can do 2nd move
label searchDoublePawnTestEnd
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
