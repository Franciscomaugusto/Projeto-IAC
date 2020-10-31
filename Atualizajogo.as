ORIG            4000h
Atualiza        TAB     5
ORIG            0000h
                MVI     R1, 4006
                MOV     R2, R1
                DEC     R2
                MVI     R3, 5
                JAL     ATUALIZA
FIM:            BR      FIM
ATUALIZA:       DEC     R6
                STOR    M[R6], R7; guardei o R7(endereço de retorno)
                DEC     R6
                STOR    M[R6], R5; guardei o R5, vou usar
                DEC     R6
                STOR    M[R6], R4; igual com o R4
                LOAD    R5, M[R1]; Quardei o valor do endereço de memória guardado em R1 no R3
                LOAD    R4, M[R2]; Guardei o valor do e.m em R2 em R4
                STOR    M[R2], R5; Guardei o valor do endereço n em n-1
                DEC     R3; Fiz uma movimentação, logo diminui R3
Ciclo:          MOV     R1, R4
                DEC     R2        
                LOAD    R4, M[R2]
                STOR    M[R2], R1
                DEC     R3
                CMP     R3, R0
                JMP.Z    Repair
                JMP     Ciclo
Repair:         LOAD    R4,M[R6]
                INC     R6
                LOAD    R5,M[R6]
                INC     R6
                LOAD    R7,M[R6]
                INC     R6
                JMP     R7