.text
.global cascadaDescendente
cascadaDescendente:
    PUSH {R4, R5, LR}
    MOV R4, #0x1  // Inicia con el LED más a la derecha encendido

loop_down:
    MOV R0, R4    // Carga el valor actual de los LEDs
    BL ledShow
    BL disp_binary
    MOV R0, #2    // Usa el índice 2 para el delay
    BL delay
    LSL R4, R4, #1  // Desplaza hacia la izquierda para el próximo LED
    CMP R4, #0x100  // Verifica si todos los LEDs ya se encendieron
    BNE loop_down

    MOV R4, #0x80   // Reinicia desde el LED más a la izquierda

loop_up:
    MOV R0, R4
    BL ledShow
    BL disp_binary
    MOV R0, #2    // Usa el índice 2 para el delay
    BL delay
    LSR R4, R4, #1  // Desplaza hacia la derecha para el próximo LED
    CMP R4, #0      // Verifica si se apagaron todos los LEDs
    BNE loop_up

    B cascadaDescendente  // Repite la secuencia

    POP {R4, R5, LR}
    BX LR

.global parpadeoCentral
parpadeoCentral:
    PUSH {R4, R5, R6, LR}
    LDR R4, =grupos

loop:
    MOV R6, #7      // Contador para el ciclo de grupos
grupo_loop:
    LDRB R5, [R4, R6]  // Carga el valor del grupo de LEDs
    MOV R0, R5
    BL ledShow
    BL disp_binary
    MOV R0, #2    // Usa el índice 2 para el delay
    BL delay
    SUBS R6, R6, #1
    CMP R6, #0
    BNE grupo_loop
    LDR R4, =grupos    // Reinicia el puntero del grupo

    B parpadeoCentral  // Repite la secuencia

    POP {R4, R5, R6, LR}
    BX LR

.data
grupos:
    .byte 0x18, 0x3C, 0x7E, 0xFF, 0x7E, 0x3C, 0x18
