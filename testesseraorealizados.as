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
RECOMECO        WORD    0

;=================================================================
; MAIN: the starting point of your program
;-----------------------------------------------------------------
                ORIG    0
MAIN:           MVI     R6,SP_INIT
                MVI     R1,INT_MASK
                MVI     R2,INT_MASK_VAL
                STOR    M[R1],R2
                ; enable interruptions
                ENI

                ; START TIMER
                ;faz o reset da pontuação aqui
                MVI     R2,TIMERCOUNT_INIT
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count 10x100ms
                MVI     R1,TIMER_TICK
                STOR    M[R1],R0          ; clear all timer ticks
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                
                JAL     GRAFICO_CHAO
                
                ; WAIT FOR EVENT (TIMER/KEY)
                MVI     R5,TIMER_TICK
.LOOP:          LOAD    R1,M[R5]
                CMP     R1,R0
                JAL.NZ  PROCESS_TIMER_EVENT
                BR      .LOOP

;========================================================================
; GRAFICOS_CHAO: DESENHA CHAO
;------------------------------------------------------------------------
GRAFICO_CHAO:   ;GO GO GO
                PUSH    R1
                PUSH    R2
                PUSH    R4
                PUSH    R5
                
                MVI     R4, 881
                
                MVI     R1,TERM_CURSOR
                MVI     R2, 2200h
                STOR    M[R1],R2
                
.LOOP:          DEC     R4
                BR.Z    .RETURN
                MVI     R1,TERM_WRITE
                MVI     R2,'█'
                STOR    M[R1],R2
                BR      .LOOP
                
.RETURN:        POP     R5
                POP     R4
                POP     R2
                POP     R1
                JMP     R7
                

;========================================================================
; GRAFICOS_CACTOS: DESENHA CACTOS
;------------------------------------------------------------------------
GRAFICO_CACTOS: ;GO GO GO
                PUSH    R1
                PUSH    R2
                PUSH    R4
                PUSH    R5
                
                MVI     R4, atualizajogotab
                DEC     R4
                MVI     R1,TERM_CURSOR
                MVI     R2, 1D00h
                STOR    M[R1],R2
                PUSH    R7
                JAL     .LOOP5
                POP     R7
                
                MVI     R4, atualizajogotab
                DEC     R4
                MVI     R1,TERM_CURSOR
                MVI     R2, 1E00h
                STOR    M[R1],R2
                PUSH    R7
                JAL     .LOOP4
                POP     R7
                
                MVI     R4, atualizajogotab
                DEC     R4
                MVI     R1,TERM_CURSOR
                MVI     R2, 1F00h
                STOR    M[R1],R2
                PUSH    R7
                JAL     .LOOP3
                POP     R7
                
                MVI     R4, atualizajogotab
                DEC     R4
                MVI     R1,TERM_CURSOR
                MVI     R2, 2000h
                STOR    M[R1],R2
                PUSH    R7
                JAL     .LOOP2
                POP     R7
                
                MVI     R4, atualizajogotab
                DEC     R4
                MVI     R1,TERM_CURSOR
                MVI     R2, 2100h
                STOR    M[R1],R2
                PUSH    R7
                JAL     .LOOP1
                POP     R7
                
                POP     R5
                POP     R4
                POP     R2
                POP     R1
                JMP     R7

.LOOP5:         INC     R4
                MVI     R1,404FH
                CMP     R4,R1
                JMP.Z   R7
                
                LOAD    R5,M[R4]
                MVI     R1,5
                CMP     R5,R1
                BR.NP   .SMALL5
                
                MVI     R1,TERM_WRITE
                MVI     R2,'*'
                STOR    M[R1],R2
                BR      .LOOP5

.SMALL5:        MVI     R1,TERM_WRITE
                MVI     R2,' '
                STOR    M[R1],R2
                BR      .LOOP5

.LOOP4:         INC     R4
                MVI     R1,404FH
                CMP     R4,R1
                JMP.Z   R7
                
                LOAD    R5,M[R4]
                MVI     R1,4
                CMP     R5,R1
                BR.NP   .SMALL4
                
                MVI     R1,TERM_WRITE
                MVI     R2,'*'
                STOR    M[R1],R2
                BR      .LOOP4

.SMALL4:        MVI     R1,TERM_WRITE
                MVI     R2,' '
                STOR    M[R1],R2
                BR      .LOOP4

.LOOP3:         INC     R4
                MVI     R1,404FH
                CMP     R4,R1
                JMP.Z   R7
                
                LOAD    R5,M[R4]
                MVI     R1,3
                CMP     R5,R1
                BR.NP   .SMALL3
                
                MVI     R1,TERM_WRITE
                MVI     R2,'*'
                STOR    M[R1],R2
                BR      .LOOP3

.SMALL3:         MVI     R1,TERM_WRITE
                MVI     R2,' '
                STOR    M[R1],R2
                BR      .LOOP3

.LOOP2:         INC     R4
                MVI     R1,404FH
                CMP     R4,R1
                JMP.Z   R7
                
                LOAD    R5,M[R4]
                MVI     R1,2
                CMP     R5,R1
                BR.NP   .SMALL2
                
                MVI     R1,TERM_WRITE
                MVI     R2,'*'
                STOR    M[R1],R2
                BR      .LOOP2

.SMALL2:        MVI     R1,TERM_WRITE
                MVI     R2,' '
                STOR    M[R1],R2
                BR      .LOOP2

.LOOP1:         INC     R4
                MVI     R1,404FH
                CMP     R4,R1
                JMP.Z   R7
                
                LOAD    R5,M[R4]
                MVI     R1,1
                CMP     R5,R1
                BR.NP   .SMALL1
                
                MVI     R1,TERM_WRITE
                MVI     R2,'*'
                STOR    M[R1],R2
                BR      .LOOP1

.SMALL1:        MVI     R1,TERM_WRITE
                MVI     R2,' '
                STOR    M[R1],R2
                BR      .LOOP1
                
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
               
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D0
                STOR    M[R1],R3
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D1
                STOR    M[R1],R3
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3,fh
                AND     R3,R2,R3
                MVI     R1,DISP7_D2
                STOR    M[R1],R3
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
                MVI     R1,RECOMECO;se estiver em GAME OVER, impede de avancar
                LOAD    R2,M[R1]
                CMP     R2,R0
                BR.NZ   .derrotado
                JAL     REALIZA_SALTO;realizacao do salto caso haja
                JAL     atualizajogo;atualiza o jogo
                JAL     GRAFICO_CACTOS
                PUSH    R3
                JAL     derrota;verifica se houve derrota
                MVI     R1, 1
                CMP     R3,R1
                BR.NZ   .passa
                JAL     perdeu;se houve derrota, coloca o ecra negro com
.passa:         POP     R3;    game over e faz reset a tudo
.derrotado:     POP     R7
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
                

;***************************************************
;Para realizacao de saltos
;*************************************************
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
                MVI     R1, ALTURA
                LOAD    R4,M[R1]
                ADD     R4, R4,R2
                STOR    M[R1],R4
                POP     R4
                JMP     R7
.desce:         MVI     R1,SALTO
                MVI     R2, -1
                STOR    M[R1],R2
                BR      .realizacao
.chao:          MVI     R1,SALTO
                LOAD    R4,M[R1]
                CMP     R0,R4
                BR.N    .realizacao
                STOR    M[R1],R0
                BR      .realizacao
                
                
;**************************************************
;Confirmacao de derrotas
;***************************************************
derrota:        DEC     R6
                STOR    M[R6],R4
                DEC     R6
                STOR    M[R6],R5
                MVI     R1, ALTURA
                LOAD    R4,M[R1]
                MVI     R2, atualizajogotab
                LOAD    R5,M[R2]
                CMP     R4,R5
                BR.N    .perdeu
                MOV     R3,R0
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4,M[R6]
                INC     R6
                JMP     R7
.perdeu:        MVI     R3, 1
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4,M[R6]
                INC     R6
                JMP     R7
                
;***************************************************
;Se derrota for True fazer reset a tudo
;***************************************************
perdeu:         DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                MVI     R1, TERM_CURSOR
                MVI     R2, FFFFh
                STOR    M[R1],R2
                ;escrever GAME OVER, mas isso acho melhor fazer primeiro o ecrã
                MVI     R1, ALTURA
                STOR    M[R1],R0
                MVI     R1, SALTO
                STOR    M[R1], R0
                MVI     R1,RECOMECO
                MVI     R2,1
                STOR    M[R1],R2
                MVI     R1, INT_MASK
                MVI     R2,7FFFh
                STOR    M[R1],R2
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                JMP     R7

;********************************************
;Inicia o salto
;********************************************
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


;**************************************************
;Caso nao esteja em salto comeca um salto
;**************************************************
                ORIG    7F30h
KEYUP:          ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R7
                DEC     R6
                STOR    M[R6],R2
                MVI     R1,RECOMECO
                LOAD    R2,M[R1]
                CMP     R0,R2
                BR.NZ   .naosalto
                MVI     R1, ALTURA
                LOAD    R2,M[R1]
                CMP     R0,R2
                BR.NZ   .naosalto
                JAL     Salto
                ; RESTORE CONTEXT
.naosalto:      LOAD    R2, M[R6]
                INC     R6
                LOAD    R7,M[R6]
                INC     R6
                LOAD    R1,M[R6]
                INC     R6
                RTI
                
                
;**********************************************
;Altera o valor de Recomeco e faz jmp para o MAIN, recomecando o jogo
;***********************************************
                ORIG    7F00h
KEYZERO:         ; SAVE CONTEXT
                DEC     R6
                STOR    M[R6],R1
                ; INC TIMER FLAG
                MVI     R1,RECOMECO
                LOAD    R2, M[R1]
                CMP     R2,R0
                BR.Z    .naomuda
                STOR    M[R1],R0
                MVI     R1, MAIN
                JMP     R1
                ; RESTORE CONTEXT
.naomuda:       LOAD    R1,M[R6]
                INC     R6
                RTI
