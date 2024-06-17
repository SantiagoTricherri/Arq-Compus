.text

.extern delay 
.extern disp_binary
.extern turnOff
.extern ledShow

.global cohete
cohete:
    PUSH {R4, R5, R6, R7, LR}

    MOV R6, #8 
launch_loop:
    MOV R5, #1
    LSL R5, R5, R7 
    MOV R0, R5
    BL disp_binary
    MOV R0, R5
    BL ledShow
    MOV R0, #3
    BL delay
    SUBS R6, R6, #1
    BEQ flight
    ADD R7, R7, #1
    BNE launch_loop

flight:
    MOV R6, #5
flight_loop:
    MOV R0, #0xFF
    BL disp_binary
    MOV R0, #0xFF
    BL ledShow
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

end_cohete:
    BL turnOff
    POP {R4, R5, R6, R7, PC}
