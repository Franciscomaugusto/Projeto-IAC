ORIG            4000h
atualizajogo    TAB     80

ORIG            4200h
X               WORD    5 ; valor inicial, nao vale a pena mudar

STACKBASE       EQU     8000h
                ORIG    0000h
                JAL     ATUALIZA
                

FIM:            BR      FIM

ATUALIZA:       PUSH    R7
                MVI     R2, 4
                JAL     GeraCacto
                MVI     R1, 404Fh
                PUSH    R4
                LOAD    R4, M[R1]; Guardei o valor do e.m em R2 em R4
                STOR    M[R1], R3; Guardei o valor do endereço n em n-1
                MVI     R2, 80
                DEC     R2; Fiz uma movimentação, logo diminui R3
Ciclo:          DEC     R1
                LOAD    R3, M[R1]
                STOR    M[R1], R4
                MOV     R4, R3
                DEC     R2
                CMP     R2, R0
                JMP.Z   Repair
                JMP     Ciclo
Repair:         POP     R4
                POP     R7
                JMP     R7
                
GeraCacto:      MVI     R3, X
                LOAD    R1, M[R3]
                MOV     R3,R0
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
