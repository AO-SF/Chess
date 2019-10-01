requireend lib/std/str/strcpy.s

db moveToStrInvalidStr '????',0

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
mov r3 '1'
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
mov r3 '1'
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
