;=================================================================
; CONSTANTS
;-----------------------------------------------------------------
; Text window
TERM_READ       EQU     FFFFh
TERM_WRITE      EQU     FFFEh
TERM_STATUS     EQU     FFFDh
TERM_CURSOR     EQU     FFFCh
TERM_COLOR      EQU     FFFBh
; 7 segment display
DISP7_D0        EQU     FFF0h
DISP7_D1        EQU     FFF1h
DISP7_D2        EQU     FFF2h
DISP7_D3        EQU     FFF3h
DISP7_D4        EQU     FFEEh
DISP7_D5        EQU     FFEFh
; Stack
SP_INIT         EQU     7000h
; timer
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h
TIMER_SETSTART  EQU     1
TIMER_SETSTOP   EQU     0
TIMERCOUNT_MAX  EQU     20
TIMERCOUNT_MIN  EQU     1
TIMERCOUNT_INIT EQU     1
; interruptions
INT_MASK        EQU     FFFAh
INT_MASK_VAL    EQU     FFFFh

;=================================================================
; Program global variables
;-----------------------------------------------------------------
                ORIG    0
TIMER_COUNTVAL  WORD    TIMERCOUNT_INIT ;states the current counting period
TIMER_TICK      WORD    0               ; indicates the number of unattended
                                        ; timer interruptions
TIME            WORD    0               ; time elapsed

                ORIG    4000h
atualizajogotab TAB     80

                ORIG    4200h
X               WORD    5 ; valor inicial, nao vale a pena mudar
ALTURAMAX       EQU     6
ALTURACACTO     EQU     4

                ;mete as tuas variaveis aqui em baixo
ALTURA          WORD    0
SALTO           WORD    0

;=================================================================
; MAIN: the starting point of your program
;-----------------------------------------------------------------
                ORIG    0
MAIN:           MVI     R6,SP_INIT
                
                ; CONFIGURE TIMER ROUNTINES
                ; interrupt mask
                MVI     R1,INT_MASK
                MVI     R2,INT_MASK_VAL
                STOR    M[R1],R2
                ; enable interruptions
                ENI

                ; START TIMER
                MVI     R2,TIMERCOUNT_INIT
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count 10x100ms
                MVI     R1,TIMER_TICK
                STOR    M[R1],R0          ; clear all timer ticks
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                
                ; WAIT FOR EVENT (TIMER/KEY)
                MVI     R5,TIMER_TICK
.LOOP:          LOAD    R1,M[R5]
                CMP     R1,R0
                JAL.NZ  PROCESS_TIMER_EVENT
                BR      .LOOP

;========================================================================
; PROCESS_CHAR: utiliza isto como base para fazer a tua de mostrar o jogo
;------------------------------------------------------------------------
PROCESS_CHAR:   ; ECHO CHARACTER FROM TERMINAL
                MVI     R1,TERM_WRITE
                STOR    M[R1],R2
;=================================================================
; PROCESS_TIMER_EVENT: processes events from the timer
;-----------------------------------------------------------------
PROCESS_TIMER_EVENT:
                ; DEC TIMER_TICK
                MVI     R2,TIMER_TICK
                DSI     ; critical region: if an interruption occurs, value might become wrong
                LOAD    R1,M[R2]
                DEC     R1
                STOR    M[R2],R1
                ENI
                ; UPDATE TIME
                MVI     R1,TIME
                LOAD    R2,M[R1]
                INC     R2
                STOR    M[R1],R2
                
                ; falta converter para decimal - Mateus
               
                ; SHOW TIME ON DISP7_D0
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D0
                STOR    M[R1],R3
                ; SHOW TIME ON DISP7_D1
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D1
                STOR    M[R1],R3
                ; SHOW TIME ON DISP7_D2
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D2
                STOR    M[R1],R3
                ; SHOW TIME ON DISP7_D3
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D3
                STOR    M[R1],R3
                
                JMP     R7


;*****************************************************************
; AUXILIARY INTERRUPT SERVICE ROUTINES
;*****************************************************************
AUX_TIMER_ISR:  ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                ; RESTART TIMER
                MVI     R1,TIMER_COUNTVAL
                LOAD    R2,M[R1]
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count value
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                ; INC TIMER FLAG
                MVI     R2,TIMER_TICK
                LOAD    R1,M[R2]
                INC     R1
                STOR    M[R2],R1
                
                ; salto para atualizajogo, tem que ser feito aqui, idk why
                PUSH    R6
                PUSH    R1
                PUSH    R2
                PUSH    R7
                JAL     REALIZA_SALTO
                JAL     atualizajogo
                PUSH    R3
                JAL     derrota
                MVI     R1, 1
                CMP     R3,R1
                BR.NZ   passa
passa:          POP     R3
                POP     R7
                POP     R2
                POP     R1
                POP     R6
                
                ; RESTORE CONTEXT
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7

;*****************************************************************
; atualizajogo e geracacto
;*****************************************************************
atualizajogo:   PUSH    R7
                PUSH    R1
                MVI     R2, ALTURACACTO
                JAL     geracacto
                MVI     R1, 404Fh
                PUSH    R4
                LOAD    R4, M[R1]; Guardei o valor do e.m em R2 em R4
                STOR    M[R1], R3; Guardei o valor do endereço n em n-1
                MVI     R2, 80
                DEC     R2; Fiz uma movimentação, logo diminui R3
.Ciclo:         DEC     R1
                LOAD    R3, M[R1]
                STOR    M[R1], R4
                MOV     R4, R3
                DEC     R2
                CMP     R2, R0
                JMP.Z   .Repair
                JMP     .Ciclo
.Repair:        POP     R4
                POP     R1
                POP     R7
                JMP     R7
                
geracacto:      PUSH    R3
                MVI     R3, X
                LOAD    R1, M[R3]
                POP     R3
                PUSH    R7
                PUSH    R5
                PUSH    R4
                MVI     R5,1
                AND     R4, R1, R5
                SHR     R1
                MVI     R3, X
                STOR    M[R3],R1
                MOV     R3,R0
                
                CMP     R4,R0
                JAL.NZ  .ChangeBit
                
                MVI     R5, 29491
                CMP     R1, R5
                JAL.N   .Funcao
                
                MVI     R5,1
                SUB     R2,R2,R5
                AND     R2,R1,R2
                ADD     R3,R2,R5
                
                POP     R4
                POP     R5
                POP     R7
                
                JMP     R7

.ChangeBit:     MVI     R5, b400h
                XOR     R1, R1, R5
                MVI     R3, X
                STOR    M[R3],R1
                MOV     R3,R0
                JMP     R7

.Funcao:        MOV     R3, R0
                POP     R4
                POP     R5
                POP     R7
                JMP     R7
                
                
REALIZA_SALTO:  DEC     R6
                STOR    M[R6], R4
                MVI     R1,ALTURA
                LOAD    R4, M[R1]
                MVI     R2,ALTURAMAX
                CMP     R2,R4
                BR.Z    .desce
                MOV     R2, R0
                CMP     R4,R2
                BR.Z    .chao
.realizacao:    MVI     R1, SALTO
                LOAD    R2, M[R1]
                ADD     R4,R4,R2
                MVI     R1, ALTURA
                STOR    M[R1],R4 
                POP     R4
                JMP     R7
.desce:         MVI     R1,SALTO
                MVI     R2, -1
                STOR    M[R1],R2
                BR      .realizacao
.chao:          MVI     R1,SALTO
                CMP     R0,R1
                BR.N    .realizacao
                STOR    M[R1],R0
                BR      .realizacao
                
                
derrota:        MVI   R1, ALTURA
                MVI   R2, atualizajogo
                CMP   R1,R2
                BR.N  .perdeu
                MOV   R3,R0
                JMP   R7
.perdeu:        MVI   R3, 1
                JMP   R7
 
                
Salto:          DEC     R6
                STOR    M[R6],R3
                MVI     R1, SALTO
                MVI     R2, 1
                STOR    M[R1], R2
                LOAD    R3,M[R6]
                INC     R6
                JMP     R7
                

;*****************************************************************
; INTERRUPT SERVICE ROUTINES
;*****************************************************************
                ORIG    7FF0h
TIMER_ISR:      ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R7
                ; CALL AUXILIARY FUNCTION
                JAL     AUX_TIMER_ISR
                ; RESTORE CONTEXT
                LOAD    R7,M[R6]
                INC     R6
                RTI

                ORIG    7F30h
KEYUP:          ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R7
                
                JAL     Salto
                ; RESTORE CONTEXT
                LOAD    R7,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                RTI
