ENTRY                           ; Mark first instruction to execute

menu:
    MOV R1, #1                  ; Estado inicial del menú

print_menu:
    ; Imprime opciones del menú
    LDR R0, =menu_string
    BL printf                  ; Simular llamada a función de impresión de menú
    LDR R0, =input_string
    BL scanf                   ; Simular lectura de entrada del usuario

    ; Código que simula la lectura de entrada del usuario, debería ser ajustado a su entorno específico
    LDR R0, [R2]               ; Suponemos que R2 tiene la entrada del usuario

    CMP R0, #0
    BEQ done
    CMP R0, #1
    BEQ luciernagas         ; Cambia el número de opción a la función deseada
    CMP R0, #2
    BEQ cohete        ; Cambia el número de opción a la función deseada
    B print_menu               ; Si no es válida, imprime menú nuevamente

.text

.global cohete
cohete:
    PUSH {R4, R5, R6, R7, LR}

    LDR R0, =msg_cohete
    BL printf

    MOV R5, #0x80
    MOV R6, #0xC0
    MOV R4, #0x0
    MOV R7, #5

    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    MOV R0, #3
    BL delay

loopC:
    MOV R4, R6
    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    LSR R6, R6, #1
    MOV R0, #3
    BL delay

    SUBS R7, R7, #1
    BNE loopC

end_loopC:
    MOV R5, #0xFF
    MOV R7, #2

loopF:
    MOV R0, R5
    BL disp_binary
    MOV R0, R5
    BL ledShow
    MOV R0, #3
    BL delay

    SUBS R7, R7, #1
    BNE loopF

    MOV R0, #0
    BL turnOff

    POP {R4, R5, R6, R7, PC}

.global luciernagas
luciernagas:
    PUSH {R4, R5, R6, R7, LR}

    LDR R0, =msg_luciernagas
    BL printf

    LDR R2, =tabla_luciernagas
    MOV R1, #0
    MOV R3, #12

loopL:
    LDRB R4, [R2, R1]
    ADD R1, R1, #1

    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    MOV R0, #2
    BL delay

    SUBS R3, R3, #1
    BNE loopL

end_loopL:
    MOV R0, #0
    BL turnOff

    POP {R4, R5, R6, R7, PC}

.data
msg_cohete:
    .asciz "INICIANDO COHETE...\n"

msg_luciernagas:
    .asciz "INICIANDO LUCIERNAGAS...\n"

tabla_luciernagas:
    .byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00
