; Moves are composed of 16 bits of the form promotype:fromsq:tosq, (with 2,7,7 bits, respectively), from MSB to LSB.

requireend pos.s

const MoveInvalid 0

label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
mov r0 0 ; TODO: this
ret

label moveCreateSimple ; (r0=fromsq, r1=tosq)=moveCreate(fromsq, tosq, PieceTypeNone)
mov r2 PieceTypeNone
jmp moveCreate

label moveCreate ; (r0=fromsq, r1=tosq, r2=promopiecetype) - returns move in r0
; incorporate fromsq
mov r3 7
shl r0 r0 r3
; incorporate tosq
or r0 r0 r1
; incorporate promo type
mov r3 14
shl r2 r2 r3
or r0 r0 r2
ret

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
