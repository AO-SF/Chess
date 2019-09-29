
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
