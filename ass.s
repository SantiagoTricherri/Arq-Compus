.text 

.global cascadaDescendente
cascadaDescendente:
    PUSH {R4, R5, LR}
    MOV R4, #0x1  // Inicia con el LED más a la derecha encendido

loop_down:
    MOV R0, R4    // Carga el valor actual de los LEDs
    BL leeds
    BL disp_binary
    LSL R4, R4, #1  // Desplaza hacia la izquierda para el próximo LED
    CMP R4, #0x100  // Verifica si todos los LEDs ya se encendieron
    BNE wait_down
    MOV R4, #0x80   // Reinicia desde el LED más a la izquierda

loop_up:
    MOV R0, R4
    BL leeds
    BL disp_binary
    LSR R4, R4, #1  // Desplaza hacia la derecha para el próximo LED
    CMP R4, #0      // Verifica si se apagaron todos los LEDs
    BNE wait_up

    POP {R4, R5, LR}
    BX LR

wait_down:
    MOV R0, #2      // Usa el índice 2 para el delay
    BL retardo
    B loop_down

wait_up:
    MOV R0, #2      // Usa el índice 2 para el delay
    BL retardo
    B loop_up

.global parpadeoCentral
parpadeoCentral:
    PUSH {R4, R5, R6, LR}
    LDR R4, =grupos

    MOV R6, #7      // Contador para el ciclo de grupos

loop:
    LDR R5, [R4], #1  // Carga el valor del grupo de LEDs y avanza el puntero
    MOV R0, R5
    BL leeds
    BL disp_binary
    MOV R0, #2
    BL retardo
    SUBS R6, R6, #1
    CMP R6, #0
    BNE loop

    POP {R4, R5, R6, LR}
    BX LR

.data
grupos:
    .byte 0x18, 0x3C, 0x7E, 0xFF, 0x7E, 0x3C, 0x18
