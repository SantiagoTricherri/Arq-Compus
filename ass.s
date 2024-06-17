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
.extern ledShow
.extern disp_binary
.extern turnOff
.extern delayC

luciernagas:
    push {lr}              
    ldr r4, =pattern       
    mov r5, #12            
    mov r6, #2             

loop_start:
    ldrb r0, [r4]          
    bl ledShow             
    mov r1, r0             
    bl disp_binary         
    bl delay_wrapper       

    add r4, r4, #1         
    subs r5, r5, #1        
    bgt loop_start         

    bl turnOff             
    pop {lr}               
    mov pc, lr             

delay_wrapper:
    push {lr}              
    mov r0, r6             
    bl delayC              
    pop {lr}               
    mov pc, lr             

pattern:
    .byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00

