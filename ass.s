.text

.global luciernagas
luciernagas:
    PUSH {R4, R5, LR}

    MOV R0, #0           // Seed for random generator
    BL srand             // srand(time(NULL))

loopLuciernagas:
    MOV R0, #255         // Max value for rand() % 256
    BL rand
    AND R4, R0, #0xFF    // Mask to get a random 8-bit number

    MOV R0, R4
    BL display_binary

    MOV R0, R4
    BL mostrar_leds

    MOV R0, #0           // Index for delay array
    BL retardo

    CMP R0, #0
    BNE loopLuciernagas

    BL apagar_leds
    POP {R4, R5, PC}


.global parpadeo
parpadeo:
    PUSH {R4, LR}

    MOV R4, #0xFF        // Initialize output for blinking

loopParpadeo:
    MOV R0, R4
    BL display_binary

    MOV R0, R4
    BL mostrar_leds

    EOR R4, R4, #0xFF    // Toggle bits
    MOV R0, #1           // Index for delay array
    BL retardo

    CMP R0, #0
    BNE loopParpadeo

    BL apagar_leds
    POP {R4, PC}
