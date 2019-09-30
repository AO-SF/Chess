label makeMoveWithScreen ; (r0=move) - makes a move on the virtual board, and update the board on screen to match
; TODO: when redrawing need to support many special cases e.g. castling, ep, promotion
; Make move
push16 r0
call makeMove
pop16 r0
; Update board on screen by redrawing from and to squares
push16 r0 ; redraw from sq
call moveGetFromSq
call posDrawSquare
pop16 r0
call moveGetToSq ; redraw to sq
call posDrawSquare
; Update stm string
call posDrawStm
ret

label makeMove ; (r0=move) - makes a move on the virtual board, returns cappiece in r0 (used for undoMove)
; TODO: need to support many special cases e.g. castling, ep, promotion
; grab from sq
mov r2 7
shr r1 r0 r2
mov r2 127
and r1 r1 r2
; grab from piece then clear it (r1 contains from sq)
mov r2 posArray
add r2 r1 r2
load8 r3 r2
mov r4 PN
store8 r2 r4
; grab to sq
mov r2 127
and r1 r0 r2
mov r2 posArray
add r2 r1 r2
; grab piece on to sq - capPiece - used for undoMove (to sq ptr is in r2)
load8 r4 r2
; place piece on to sq (to sq ptr is in r2, piece is in r3)
store8 r2 r3
; flip stm
mov r0 posStm
load8 r1 r0
mov r2 ColourBoth
xor r1 r1 r2
store8 r0 r1
; Move capPiece into r0 to return it
mov r0 r4
ret

label undoMove ; (r0=move, r1=capPiece)
; put move and capPiece on the stack for now
push8 r1
push16 r0
; flip stm
mov r0 posStm
load8 r1 r0
mov r2 ColourBoth
xor r1 r1 r2
store8 r0 r1
; restore move
pop16 r0
; grab to sq ptr
mov r1 127
and r1 r0 r1
mov r2 posArray
add r1 r1 r2
; grab piece on to sq (movingPiece, to sq ptr in r1)
load8 r2 r1
; restore capPiece on to sq
pop8 r3 ; grab capPiece
store8 r1 r3
; grab from sq ptr
mov r1 7
shr r1 r0 r1
mov r3 127
and r1 r1 r3
mov r3 posArray
add r1 r1 r3
; place movingPiece back on from sq (movingPiece in r2, from sq ptr in r1)
store8 r1 r2
ret
