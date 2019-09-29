const MoveInvalid 0

label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
mov r0 0 ; TODO: this
ret

label moveFromStr ; (r0=str) - returns move in r0, or MoveInvalid if bad str. str can be terminated by null byte or newline
mov r0 MoveInvalid ; TODO: this
ret

label makeMoveWithScreen ; (r0=move) - makes a move on the virtual board, and updates the board on screen
; TODO: this
ret
