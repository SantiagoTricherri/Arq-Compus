.text

.extern delay 
.extern ledShow
.extern disp_binary
.extern turnOff

.global cohete
cohete:
    PUSH {R4, R5, R6, R7, LR}

    MOV R5, #0x80   ; R5 = 0x80 (configuración de LEDs)
    MOV R6, #0xC0   ; R6 = 0xC0 (configuración de LEDs)
    MOV R4, #0x0    ; R4 = 0x0 (índice para bucle)
    MOV R7, #5      ; R7 = 5 (contador de bucle)

    MOV R0, R4
    BL disp_binary  ; Mostrar en pantalla el valor binario de R4
    MOV R0, R4
    BL ledShow      ; Mostrar LEDs según el valor de R4
    MOV R0, #5
    BL delay        ; Delay de 5 unidades

loopC:
    MOV R4, R6      ; R4 = R6 (configuración de LEDs)
    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    LSR R6, R6, #1  ; Shift right R6
    MOV R0, #5
    BL delay

    SUBS R7, R7, #1
    BNE loopC

end_loopC:
    MOV R5, #0xFF   ; Apagar todos los LEDs
    MOV R7, #2      ; Reiniciar contador de bucle

loopF:
    MOV R0, R5
    BL disp_binary
    MOV R0, R5
    BL ledShow
    MOV R0, #5
    BL delay

    SUBS R7, R7, #1
    BNE loopF

    MOV R0, #0
    BL turnOff      ; Apagar todos los LEDs

    POP {R4, R5, R6, R7, PC}


.global luciernagas
luciernagas:
    PUSH {R4, R5, R6, R7, LR}

    LDR R2, =tabla_luciernagas  ; Cargar dirección de la tabla de luciérnagas
    MOV R1, #0                  ; Inicializar índice para tabla
    MOV R3, #12                 ; Número de elementos en la tabla

    MOV R0, #5
    BL delay                    ; Delay inicial

loopL:
    LDRB R4, [R2, R1]           ; Cargar valor de luciérnaga actual
    ADD R1, R1, #1              ; Incrementar índice

    MOV R0, R4
    BL disp_binary              ; Mostrar en pantalla el valor binario de R4
    MOV R0, R4
    BL ledShow                  ; Mostrar LEDs según el valor de R4
    MOV R0, #5
    BL delay                    ; Delay entre luciérnagas

    SUBS R3, R3, #1
    BNE loopL

end_loopL:
    MOV R0, #0
    BL turnOff                  ; Apagar todos los LEDs

    POP {R4, R5, R6, R7, PC}

.data
tabla_luciernagas:
    .byte 0x00
    .byte 0x44
    .byte 0x80
    .byte 0x25
    .byte 0x60
    .byte 0x00
    .byte 0x3A
    .byte 0x91
    .byte 0x04
    .byte 0x00
    .byte 0x48
    .byte 0x00

