label sqGetX ; (r0=sq) - returns x in r0. note: only uses r0 and r5 (scratch reg), no others need protecting
mov r5 7
and r0 r0 r5
ret

label sqGetY ; (r0=sq) - returns y in r0. note: only uses r0 and r5 (scratch reg), no others need protecting
mov r5 4
shr r0 r0 r5
mov r5 7
and r0 r0 r5
ret

label sqMake ; (r0=x, r1=y) - returns sq in r0
mov r2 4
shl r1 r1 r2
or r0 r0 r1
ret
