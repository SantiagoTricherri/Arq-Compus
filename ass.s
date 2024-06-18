.text

.global carrera
carrera:
PUSH {R4, R5, R6, LR}

MOV R4, #0x1 // Initialize output
MOV R5, #8   // Loop counter

loopCarrera:
MOV R0, R4
BL disp_binary

MOV R0, R4
BL ledShow

LSL R4, R4, #1 // Shift left
MOV R0, #0 // Index for delay array
BL delay

MOV R0, #0
BL adjustSpeed // Adjust speed

SUBS R5, R5, #1
BNE loopCarrera

BL turnOff
POP {R4, R5, R6, PC}

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
