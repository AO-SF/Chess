; Moves are composed of 16 bits of the form promotype:fromsq:tosq, (with 2,7,7 bits, respectively), from MSB to LSB.

requireend pos.s

const MoveInvalid 0
const moveToStrMinSize 6

label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
mov r0 0 ; TODO: this
ret

label moveCreateSimple ; (r0=fromsq, r1=tosq)=moveCreate(fromsq, tosq, PieceTypeNone)
mov r2 PieceTypeNone
jmp moveCreate

label moveCreate ; (r0=fromsq, r1=tosq, r2=promopiecetype) - returns move in r0
mov r0 MoveInvalid ; TODO: this
ret

label makeMoveWithScreen ; (r0=move) - makes a move on the virtual board, and updates the board on screen
; TODO: this
ret
