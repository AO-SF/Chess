; Moves are composed of 16 bits of the form promotype:fromsq:tosq, (with 2,7,7 bits, respectively), from MSB to LSB.

requireend lib/std/str/strcpy.s

requireend pos.s

const MoveInvalid 0
const moveToStrMinSize 6

db moveToStrInvalidStr '????',0

label moveIsLegal ; (r0=move) - returns 1/0 in r0 for legal/illegal
mov r0 0 ; TODO: this
ret

label moveFromStr ; (r0=str) - returns move in r0, or MoveInvalid if bad str. str can be terminated by null byte or newline
; TODO: handle promption character
; Create 'empty' move for us to incrementally fill
mov r4 0
; Inspect 1st character for from-sq X coordinate
load8 r1 r0
inc r0
mov r2 'a'
sub r1 r1 r2
; Bad 1st character?
mov r2 0
cmp r2 r1 r2
skipge r2
jmp moveFromStrInvalid
mov r2 7
cmp r2 r1 r2
skiple r2
jmp moveFromStrInvalid
; Store coordinate from 1st character
mov r3 7 ; lower 3 bits of fromSq
shl r1 r1 r3
or r4 r4 r1
; Inspect 2nd character for from-sq Y coordinate
load8 r1 r0
inc r0
mov r2 '0'
sub r1 r1 r2
; Bad 2nd character?
mov r2 0
cmp r2 r1 r2
skipge r2
jmp moveFromStrInvalid
mov r2 7
cmp r2 r1 r2
skiple r2
jmp moveFromStrInvalid
; Store coordinate from 2nd character
mov r3 11 ; upper 3 bits of fromSq
shl r1 r1 r3
or r4 r4 r1
; Inspect 3rd character for to-sq X coordinate
load8 r1 r0
inc r0
mov r2 'a'
sub r1 r1 r2
; Bad 3rd character?
mov r2 0
cmp r2 r1 r2
skipge r2
jmp moveFromStrInvalid
mov r2 7
cmp r2 r1 r2
skiple r2
jmp moveFromStrInvalid
; Store coordinate from 3rd character
or r4 r4 r1 ; lower 3 bits of toSq
; Inspect 4th character for from-sq Y coordinate
load8 r1 r0
inc r0
mov r2 '0'
sub r1 r1 r2
; Bad 4th character?
mov r2 0
cmp r2 r1 r2
skipge r2
jmp moveFromStrInvalid
mov r2 7
cmp r2 r1 r2
skiple r2
jmp moveFromStrInvalid
; Store coordinate from 4th character
mov r3 4 ; upper 3 bits of toSq
shl r1 r1 r3
or r4 r4 r1
; Success
mov r0 r4
ret
; Common bad return path
label moveFromStrInvalid
mov r0 MoveInvalid
ret

label moveToStr ; (r0=move, r1=buf) writes null terminated move to buffer (which should have space for at least moveToStrMinSize bytes)
; TODO: add promotion character
; Special case for invalid move
mov r2 MoveInvalid
cmp r2 r0 r2
skipneq r2
jmp moveToStrInvalid
; Extract from-x
mov r3 7
shr r2 r0 r3
mov r3 7
and r2 r2 r3
mov r3 'a'
add r2 r2 r3
store8 r1 r2
inc r1
; Extract from-y
mov r3 11
shr r2 r0 r3
mov r3 7
and r2 r2 r3
mov r3 '0'
add r2 r2 r3
store8 r1 r2
inc r1
; Extract to-x
mov r2 r0
mov r3 7
and r2 r2 r3
mov r3 'a'
add r2 r2 r3
store8 r1 r2
inc r1
; Extract to-y
mov r3 4
shr r2 r0 r3
mov r3 7
and r2 r2 r3
mov r3 '0'
add r2 r2 r3
store8 r1 r2
inc r1
; Add null terminator
mov r2 0
store8 r1 r2
ret
label moveToStrInvalid
mov r0 r1
mov r1 moveToStrInvalidStr
call strcpy
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
