                ORIG    4000h

X               WORD    5 ; valor inicial, nao vale a pena mudar

STACKBASE       EQU     8000h
                ORIG    0000h
                
                MVI     R2,4 ; altera este valor para mudar a altura max
                
                JAL     GeraCacto
                
Fim:            BR      Fim                
                
                ;R1 é X
                ;R2 é altura
                ;R4 é bit
                
GeraCacto:      MVI     R6, X
                LOAD    R1, M[R6]
                MVI     R6, STACKBASE
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
                JAL.NZ  ChangeBit
                
                MVI     R5, 62258
                CMP     R1, R5
                JAL.N   Funcao
                
                MVI     R5,1
                SUB     R2,R2,R5
                AND     R2,R1,R2
                ADD     R3,R2,R5
                
                POP     R4
                POP     R5
                POP     R7
                
                JMP     R7

ChangeBit:      MVI     R5, b400h
                XOR     R1, R1, R5
                MVI     R3, X
                STOR    M[R3],R1
                MOV     R3,R0
                JMP     R7

Funcao:         MOV     R3, R0
                POP     R4
                POP     R5
                POP     R7
                JMP     R7