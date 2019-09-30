label makeMoveWithScreen ; (r0=move) - makes a move on the virtual board, and update the board on screen to match
; TODO: when redrawing need to support many special cases e.g. castling, ep, promotion
; Make move
push16 r0
call makeMove
pop16 r0
; Update board on screen by redrawing from and to squares
push16 r0 ; grab from sq
mov r1 7
shr r0 r0 r1
mov r1 127
and r0 r0 r1
call posDrawSquare ; redraw from sq
pop16 r0
mov r1 127 ; grab to sq
and r0 r0 r1
call posDrawSquare ; redraw to sq
ret

label makeMove ; (r0=move) - makes a move on the virtual board
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
; place piece on to sq (piece is in r3)
mov r2 posArray
add r2 r1 r2
store8 r2 r3
ret