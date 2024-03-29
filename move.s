; Moves are composed of 16 bits of the form promotype:fromsq:tosq, (with 2,7,7 bits, respectively), from MSB to LSB.

requireend lib/std/io/fput.s

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

label moveGetFromSq ; (r0=move) - places fromSq in r0. note: only uses r0 and r5 (scratch reg), none others need protecting
mov r5 7
shr r0 r0 r5
mov r5 127
and r0 r0 r5
ret

label moveGetToSq ; (r0=move) - places toSq in r0. note: only uses r0 and r5 (scratch reg), none others need protecting
mov r5 127
and r0 r0 r5
ret

label movePrint ; (r0=move)
; Note: this function assumes moveToStrMinSize<=6
; Reserve space on stack to store string
mov r1 r6
inc6 r6
; Convert move to string
call moveToStr
; Print string
mov r0 r6
dec6 r0 ; note we cannot just decrement the stack immediately in case a signal handler is invoked while we are in puts0
call puts0
; Restore stack
dec6 r6
ret
