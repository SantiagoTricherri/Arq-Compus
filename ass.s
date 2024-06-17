.text

.global cohete
cohete:
    PUSH {R4, R5, R6, R7, LR}
.extern delay 
.extern disp_binary
.extern turnOff
.extern ledShow

    MOV R5, #0x80
    MOV R6, #0xC0
    MOV R4, #0x0
    MOV R7, #5

    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    MOV R0, #10
    BL delay

loopC:
    MOV R4, R6
    MOV R0, R4
    BL disp_binary
    MOV R0, R4
    BL ledShow
    LSR R6, R6, #1
    MOV R0, #10
    BL delay
.global luciernagas
luciernagas:
    PUSH {R4, R5, R6, LR}

    SUBS R7, R7, #1
    BNE loopC
    LDR R4, =pattern
    MOV R5, #12  // Tamaño del patrón

end_loopC:
    MOV R5, #0xFF
    MOV R7, #2
loop_luciernagas:
    LDRB R6, [R4], #1

loopF:
    MOV R0, R5
    MOV R0, R6
    BL disp_binary
    MOV R0, R5

    MOV R0, R6
    BL ledShow
    MOV R0, #10

    MOV R0, #2
    BL delay

    SUBS R7, R7, #1
    BNE loopF
    SUBS R5, R5, #1
    BEQ end_luciernagas

    CMP R0, #0
    BNE loop_luciernagas

    MOV R0, #0
    BL turnOff

    POP {R4, R5, R6, R7, PC}
end_luciernagas:
    POP {R4, R5, R6, PC}

.global luciernagas
luciernagas:
    PUSH {R4, R5, R6, R7, LR}
.data
pattern:
.byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00

    LDR R2, =tabla_luciernagas
    MOV R1, #0
    MOV R3, #12
.global cohete
cohete:
    PUSH {R4, R5, R6, R7, LR}

    MOV R0, R4
    // Lanzamiento del cohete con aceleración
    MOV R6, #8  // NUM_LEDS
launch_loop:
    MOV R5, #1
    LSL R5, R5, R7  // Desplazar un bit a la izquierda según el valor de R7
    MOV R0, R5
    BL disp_binary
    MOV R0, R4
    MOV R0, R5
    BL ledShow
    MOV R0, #10
    MOV R0, #3
    BL delay

loopL:
    LDRB R4, [R2, R1]
    ADD R1, R1, #1

    MOV R0, R4
    SUBS R6, R6, #1
    BEQ flight
    ADD R7, R7, #1
    BNE launch_loop

flight:
    MOV R6, #5
flight_loop:
    MOV R0, #0xFF
    BL disp_binary
    MOV R0, R4
    MOV R0, #0xFF
    BL ledShow
    MOV R0, #2
    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete
    MOV R0, #0x00
    BL disp_binary
    MOV R0, #0x00
    BL ledShow
    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete
    SUBS R6, R6, #1
    BNE flight_loop

explosion:
    MOV R6, #10
explosion_loop:
    MOV R0, #0xAA
    BL disp_binary
    MOV R0, #0xAA
    BL ledShow
    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete
    MOV R0, #0x55
    BL disp_binary
    MOV R0, #0x55
    BL ledShow
    MOV R0, #3
    BL delay
    CMP R0, #0
    BEQ end_cohete
    SUBS R6, R6, #1
    BNE explosion_loop

    SUBS R3, R3, #1
    BNE loopL

end_loopL:
    MOV R0, #0
end_cohete:
    BL turnOff

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
    POP {R4, R5, R6, R7, PC}
