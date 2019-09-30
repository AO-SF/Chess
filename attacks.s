label isSqAttackedByColour ; (r0=square, r1=colour) - returns 1/0 in ro
mov r0 0 ; TODO: this - loop over piece types and steps, seeing if any such pieces can be reached from the given square
ret

label isSqAttackedByStm ; (r0=square) - is square attacked by side to move? returns 1/0 in r0
mov r1 posStm
load8 r1 r1
jmp isSqAttackedByColour ; this function will return for us
