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
