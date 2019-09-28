require lib/sys/sys.s

requireend lib/curses/curses.s
requireend lib/std/proc/exit.s

requireend pos.s

; Signal handlers (must be in first 256 bytes)
jmp start

label suicideHandler
jmp quit

label start

; Register suicide handler
mov r0 SyscallIdRegisterSignalHandler
mov r1 SignalIdSuicide
mov r2 suicideHandler
syscall

; New game - reset board in memory and on screen
call cursesClearScreen
call posReset
call posDraw

; TODO: rest

; Quit
label quit
call cursesReset

; Exit
mov r0 0
call exit
