.text

.global luciernagas
luciernagas:
PUSH {R4, LR}

loopLuciernagas:
BL random
AND R4, R0, #0xFF // Mask to get a value between 0 and 255
MOV R0, R4
BL disp_binary

MOV R0, R4
BL ledShow

MOV R0, #0 // Index for delay array
BL delay

MOV R0, #0
BL adjustSpeed // Adjust speed

CMP R0, #0
BNE loopLuciernagas

BL turnOff
POP {R4, PC}

.global parpadeo
parpadeo:
PUSH {R4, R5, R6, LR}

MOV R4, #0xFF // Initialize output for blinking
MOV R5, #10   // Loop counter

loopParpadeo:
MOV R0, R4
BL disp_binary

MOV R0, R4
BL ledShow

EOR R4, R4, #0xFF // Toggle bits
MOV R0, #1 // Index for delay array
BL delay

MOV R0, #1
BL adjustSpeed // Adjust speed

SUBS R5, R5, #1
BNE loopParpadeo

BL turnOff
POP {R4, R5, R6, PC}

.data
random_values:
.word 0x94A5A5A5, 0x32597A9B, 0x7B8CDE5F, 0xA5F0D7A5
random_index:
.word 0

.global random
random:
    LDR R1, =random_index
    LDR R2, [R1]
    LDR R3, =random_values
    LDR R0, [R3, R2, LSL #2]
    ADD R2, R2, #1
    AND R2, R2, #3
    STR R2, [R1]
    BX LR
