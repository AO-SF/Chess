require lib/sys/sys.s

requireend lib/curses/curses.s
requireend lib/std/io/fget.s
requireend lib/std/io/fput.s
requireend lib/std/proc/exit.s

requireend move.s
requireend pos.s

db humanMovePromptStr 'Your move: ',0
db humanMoveInvalidStr 'Invalid move',0
db humanMoveIllegalStr 'Illegal move',0

ab humanMoveInputStr 8

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
mov r0 0
call cursesSetEcho
call cursesClearScreen
call posReset
call posDraw

label gameLoopStart

; Human to move
call humanMove

; TODO: check for end of game

; Computer move
call computerMove

; TODO: check for end of game

; Loop for next move
jmp gameLoopStart

; Quit
label quit
call cursesReset

; Exit
mov r0 0
call exit

label humanMove ; Prompt for legal move and make it on virtual board and on screen
label humanMoveGrabLoopStart
; Prompt for a move and check if invalid
call humanMoveGrab
mov r1 MoveInvalid
cmp r1 r0 r1
skipneq r1
jmp humanMoveInvalid
; Check if move is legal
push16 r0 ; protect move
call moveIsLegal
cmp r1 r0 r0
pop16 r0 ; restore move
skipneqz r1
jmp humanMoveIllegal
; Make move (contained in r0)
; TODO: update board virtually and on screen
ret
label humanMoveInvalid
call cursesClearLine ; clear existing message (if any)
mov r0 humanMoveInvalidStr
call puts0
jmp humanMoveGrabLoopStart
label humanMoveIllegal
call cursesClearLine ; clear existing message (if any)
mov r0 humanMoveIllegalStr
call puts0
jmp humanMoveGrabLoopStart

label humanMoveGrab ; Prompts once for a move, returns move in r0
; Print prompt
mov r0 0
mov r1 9
call cursesSetPosXY
call cursesClearLine ; clear existing value (if any)
mov r0 humanMovePromptStr
call puts0
; Grab move string
mov r0 humanMoveInputStr
mov r1 8
call gets0
; Convert string to move and return
call moveFromStr
ret

label computerMove
; TODO: this - choose move then make it both virtually and on screen
ret
