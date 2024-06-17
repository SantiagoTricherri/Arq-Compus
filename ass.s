.section .text
.global luciernagas, cohete

luciernagas:
    PUSH {R4, R5, R6, R7, LR}  ; Guardar registros en la pila
    LDR R0, =msg_luciernagas
    BL printf

    LDR R0, =tabla_luciernagas
    MOV R1, #0
    MOV R2, #12

loop_luciernagas:
    LDRB R3, [R0, R1]
    ADD R1, R1, #1

    ; Llamar a ledShow (simulado aquí)
    ; MOV R0, R3
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; MOV R0, R3
    ; BL disp_binary

    ; Llamar a delay
    MOV R0, #2
    BL delay
    CMP R0, #0
    BEQ end_luciernagas

    SUBS R2, R2, #1
    BNE loop_luciernagas

end_luciernagas:
    ; Llamar a turnOff
    BL turnOff

    POP {R4, R5, R6, R7, PC}  ; Restaurar registros y regresar

cohete:
    PUSH {R4, R5, R6, R7, LR}  ; Guardar registros en la pila

    ; Lanzamiento del cohete con aceleración
    LDR R0, =msg_cohete
    BL printf

    MOV R4, #0
    MOV R7, #5
loop_cohete_lanzamiento:
    MOV R0, #1
    LSL R0, R0, R4  ; Desplazar un bit a la izquierda por R4

    ; Llamar a ledShow (simulado aquí)
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; BL disp_binary

    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete

    ADD R4, R4, #1
    CMP R4, #8
    BNE loop_cohete_lanzamiento

    ; Vuelo del cohete
    MOV R7, #5
loop_cohete_vuelo:
    MOV R0, #0xFF

    ; Llamar a ledShow (simulado aquí)
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; BL disp_binary

    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete

    MOV R0, #0x00

    ; Llamar a ledShow (simulado aquí)
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; BL disp_binary

    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete

    SUBS R7, R7, #1
    BNE loop_cohete_vuelo

    ; Explosión del cohete
    MOV R7, #10
loop_cohete_explosion:
    MOV R0, #0xAA

    ; Llamar a ledShow (simulado aquí)
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; BL disp_binary

    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete

    MOV R0, #0x55

    ; Llamar a ledShow (simulado aquí)
    ; BL ledShow

    ; Llamar a disp_binary (simulado aquí)
    ; BL disp_binary

    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete

    SUBS R7, R7, #1
    BNE loop_cohete_explosion

end_cohete:
    ; Restablecer el tiempo de retardo después de la explosión
    LDR R0, =10000
    STR R0, [delayTime, #3]

    ; Llamar a turnOff
    BL turnOff

    POP {R4, R5, R6, R7, PC}  ; Restaurar registros y regresar

.data
msg_luciernagas:
    .asciz "INICIANDO LUCIERNAGAS...\n"

tabla_luciernagas:
    .byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00

msg_cohete:
    .asciz "INICIANDO COHETE...\n"
