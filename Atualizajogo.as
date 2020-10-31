ORIG            4000h
atualizajogo    TAB     100
ORIG            0000h
                JAL     ATUALIZA
                

FIM:            BR      FIM

atualizajogo:   PUSH    R7
                MVI     R2, 4
                JAL     geracacto
                MVI     R1, 4100
                PUSH    R4
                LOAD    R4, M[R1]; Guardei o valor do e.m em R1 em R4
                STOR    M[R1], R3; Guardei o valor do endereço n em n-1
                MVI     R2,100
                DEC     R2; Fiz uma movimentação, logo diminui R3
Ciclo:          DEC     R1
                MVI     R3, M[R1]
                STOR    M[R1], R4
                MOV     R4, R3
                DEC     R2
                CMP     R2, R0
                JMP.Z    Repair
                JMP     Ciclo
Repair:         POP     R4
                POP     R7
                MVI     R3, 0
                JMP     R7
