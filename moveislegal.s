label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
; First check if move is even pseudo legal
push16 r0
call moveIsPseudoLegal
cmp r1 r0 r0
pop16 r0
skipneqz r1
jmp moveIsLegalFalse
; Now we need to test for leaving ourselves in check
; Make move
push16 r0
call makeMove
mov r1 r0
pop16 r0
push8 r1 ; protect makeMove capPiece
; Test if our king is attacked
; TODO: if move was castling, extra squares need testing
push16 r0
call posGetKingSqXStm
call isSqAttackedByStm
mov r1 r0
pop16 r0
; Undo move
pop8 r2 ; grab capPiece
push8 r1
mov r1 r2
call undoMove
pop8 r1
; Invert result and place in r0 (based on check test - so if inCheck=1 then isLegal=0)
mov r0 1
xor r0 r0 r1
ret
; Move is illegal
label moveIsLegalFalse
mov r0 0
ret

label moveIsPseudoLegal ; (r0=move) - like moveIsLegal, but does not care if making the move leaves (original) side to move in check. Verifies things like is the piece on from square friendly, can it move to the to square, etc.
; check piece on to sq is not friendly (so need empty or opponent colour)
push16 r0
call moveGetToSq
call posGetPieceOnSq
mov r1 posStm
and r0 r0 r1
cmp r1 r0 r0
pop16 r0
skipeqz r1
jmp moveIsPseudoLegalFalse
; Grab from piece (placing into r1)
push16 r0
call moveGetFromSq
call posGetPieceOnSq
mov r1 r0 ; move piece into r1
pop16 r0
; Check piece on from sq is friendly
mov r2 posStm
load8 r2 r2
and r2 r1 r2
cmp r2 r2 r2
skipneqz r2
jmp moveIsLegalFalse
; Check from piece can move in the needed way (move in r0, from piece in r1)
; TODO: this
; Move is legal
mov r0 1
ret
label moveIsPseudoLegalFalse
mov r0 0
ret
