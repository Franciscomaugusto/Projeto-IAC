ORIG            4000h
atualiza_jogo   TAB     80

ORIG            4200h
X               WORD    5 ; valor inicial, nao vale a pena mudar
ALTURAMAX       EQU     4

STACKBASE       EQU     8000h
                ORIG    0000h
                MVI     R6, STACKBASE
                
                JAL     atualizajogo

FIM:            BR      FIM

atualizajogo:   DEC     R6
                STOR    M[R6],R7
                MVI     R2, ALTURAMAX
                JAL     geracacto
                MVI     R1, 404Fh
                DEC     R6
                STOR    M[R6],R4
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
Repair:         LOAD    R4,M[R6]
                INC     R6
                LOAD    R7,M[R6]
                INC     R6
                JMP     atualizajogo
                
geracacto:      STOR    M[R6], R6
                DEC     R6
                MVI     R6, X
                LOAD    R1, M[R6]
                INC     R6
                LOAD    R6, M[R6]
                STOR    M[R6], R7
                DEC     R6
                STOR    M[R6], R5
                DEC     R6
                STOR    M[R6], R4
                DEC     R6
                MVI     R5,1
                AND     R4, R1, R5
                SHR     R1
                MVI     R3, X
                STOR    M[R3],R1
                MOV     R3,R0
                
                CMP     R4,R0
                JAL.NZ  ChangeBit
                
                MVI     R5, 29491
                CMP     R1, R5
                JAL.N   Funcao
                
                MVI     R5,1
                SUB     R2,R2,R5
                AND     R2,R1,R2
                ADD     R3,R2,R5
                
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R7, M[R6]
                
                JMP     R7

ChangeBit:      MVI     R5, b400h
                XOR     R1, R1, R5
                MVI     R3, X
                STOR    M[R3],R1
                MOV     R3,R0
                JMP     R7

Funcao:         MOV     R3, R0
                INC     R6
                LOAD    R4, M[R6]
                INC     R6
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R7, M[R6]
                JMP     R7
