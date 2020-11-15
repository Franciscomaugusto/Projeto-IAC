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
