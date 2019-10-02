require lib/sys/sys.s

requireend lib/curses/curses.s
requireend lib/std/io/fget.s
requireend lib/std/io/fput.s
requireend lib/std/io/fputdec.s
requireend lib/std/io/fputtime.s
requireend lib/std/proc/exit.s
requireend lib/std/str/strtoint.s
requireend lib/std/time/timemonotonic.s

require defs.s

requireend attacks.s
requireend makemove.s
requireend move.s
requireend movefromstr.s
requireend moveislegal.s
requireend movetostr.s
requireend pos.s
requireend posdraw.s
requireend search.s
requireend square.s

db commandPromptStr 'Enter command: ',0
db commandHelpStr '(m - player move, c - computer move, l - list moves, p - perft, r - reset, q - quit)',0
db commandInvalidStr 'Invalid command: ',0

db listMovesPrefixStr 'Moves: ',0

db humanMovePromptStr 'Enter move: ',0
db humanMoveInvalidStr 'Invalid move',0
db humanMoveIllegalStr 'Illegal move',0

db perftPromptStr 'Depth limit: ',0
db perftBadDepthStr 'Bad depth',0
db perftStatusStr 'Perft:\n',0

const scratchBufSize 8
ab scratchBuf scratchBufSize

aw perftStartTime 1

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
call resetGame

; Command loop
label commandLoopStart
call runCommand
; TODO: check for end of game
jmp commandLoopStart

; Quit
label quit
mov r0 1
call cursesSetEcho
call cursesReset

; Exit
mov r0 0
call exit

; Reset board and screen for new game
label resetGame
call cursesClearScreen
call posReset
call posDraw
ret

; Run command - grab and run command
label runCommand
; Print help string
mov r0 0
mov r1 LineYHelp
call cursesSetPosXY
call cursesClearLine
mov r0 commandHelpStr
call puts0
; Print prompt
mov r0 0
mov r1 LineYInput
call cursesSetPosXY
call cursesClearLine
mov r0 commandPromptStr
call puts0
; Wait for character from user
label runCommandWaitForInput
mov r0 15
mov r1 LineYInput
call cursesSetPosXY
label runCommandWaitForInputLoop
call cursesGetChar
mov r1 256
cmp r1 r0 r1
skipneq r1
jmp runCommandWaitForInputLoop
; Clear status line
push8 r0
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
call cursesClearLine
pop8 r0
; Handle command
mov r1 'c'
cmp r1 r0 r1
skipneq r1
jmp runCommandComputer
mov r1 'm'
cmp r1 r0 r1
skipneq r1
jmp runCommandMove
mov r1 'l'
cmp r1 r0 r1
skipneq r1
jmp runCommandList
mov r1 'p'
cmp r1 r0 r1
skipneq r1
jmp runCommandPerft
mov r1 'q'
cmp r1 r0 r1
skipneq r1
jmp quit ; lack of ret means stack is broken but does no harm
mov r1 'r'
cmp r1 r0 r1
skipneq r1
jmp runCommandReset
; Otherwise bad command - print message and loop again for another attempt
push8 r0
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
mov r0 commandInvalidStr
call puts0
pop8 r0
call putc0
jmp runCommandWaitForInput

; runCommand sub functions
label runCommandComputer
; Choose move
call search
; Make move (also updating screen)
; TODO: uncomment below once above actually returns a move
; call makeMoveWithScreen
ret

label runCommandMove
; grab and make move
call humanMove
; reset prompt str
mov r0 0
mov r1 LineYInput
call cursesSetPosXY
call cursesClearLine
mov r0 commandPromptStr
call puts0
ret

label runCommandList
; Move cursor to status line
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
; Print prefix string
mov r0 listMovesPrefixStr
call puts0
; Print moves
call searchList
ret

label runCommandPerft
; grab max depth
call perftGetDepth
mov r1 0
cmp r1 r0 r1
skipgt r1
jmp runCommandPerftBadDepth
; Move cursor ready to output
push8 r0
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
; Print perft string
mov r0 perftStatusStr
call puts0
pop8 r0
; Loop from depth=1 to max
mov r1 r0 ; max
mov r0 1 ; current
label runCommandPerftLoopStart
; Print depth and space
push8 r1
push8 r0
call putdec
mov r0 ' '
call putc0
; Grab start time for timing
call gettimemonotonic
mov r1 perftStartTime
store16 r1 r0
; Call perft function
pop8 r0 ; grab and save depth
push8 r0
call searchPerft
; Print result, time and newline
call putdec
mov r0 ' '
call putc0
call gettimemonotonic
mov r1 perftStartTime
load16 r1 r1
sub r0 r0 r1
call puttime
mov r0 '\n'
call putc0
; Next iteration?
pop8 r0 ; grab depth
pop8 r1 ; grab max depth
inc r0
cmp r2 r0 r1
skipgt r2
jmp runCommandPerftLoopStart
ret
; Error case
label runCommandPerftBadDepth
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
mov r0 perftBadDepthStr
call puts0
ret

label perftGetDepth ; returns depth in r0, 0 on failure
; Print prompt
mov r0 0
mov r1 LineYInput
call cursesSetPosXY
call cursesClearLine
mov r0 perftPromptStr
call puts0
; Grab move string
mov r0 1
call cursesSetEcho
mov r0 scratchBuf
mov r1 scratchBufSize
call gets0
mov r0 0
call cursesSetEcho
; Convert string to integer and return
mov r0 scratchBuf
call strtoint
ret

label runCommandReset
call resetGame ; reset game state and redraw screen
ret ; return from runCommand

; user move input - prompt for legal move and make it on virtual board and on screen
label humanMove
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
call makeMoveWithScreen
ret
label humanMoveInvalid
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
mov r0 humanMoveInvalidStr
call puts0
ret
label humanMoveIllegal
mov r0 0
mov r1 LineYStatus
call cursesSetPosXY
mov r0 humanMoveIllegalStr
call puts0
ret

label humanMoveGrab ; Prompts once for a move, returns move in r0
; Print prompt
mov r0 0
mov r1 LineYInput
call cursesSetPosXY
call cursesClearLine
mov r0 humanMovePromptStr
call puts0
; Grab move string
mov r0 1
call cursesSetEcho
mov r0 scratchBuf
mov r1 scratchBufSize
call gets0
mov r0 0
call cursesSetEcho
; Convert string to move and return
mov r0 scratchBuf
call moveFromStr
ret
