; Moves are composed of 16 bits of the form promotype:fromsq:tosq, (with 2,7,7 bits, respectively), from MSB to LSB.

const MoveInvalid 0

label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
mov r0 1 ; TODO: this
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
