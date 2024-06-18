.text

.global luciernagas
luciernagas:
    PUSH {R4, R5, LR}

    MOV R0, #0           // Genera numero random
    BL srand             // srand(time(NULL))

loopLuciernagas:
    MOV R0, #255         // Maximo valor para rand() % 256
    BL rand
    AND R4, R0, #0xFF    // Obtener un número aleatorio de 8 bits

    MOV R0, R4
    BL display_binary

    MOV R0, R4
    BL mostrar_leds

    MOV R0, #0           //Indice para el arreglo de retardo
    BL retardo

    CMP R0, #0
    BNE loopLuciernagas

    BL apagar_leds
    POP {R4, R5, PC}


.global parpadeo
parpadeo:
    PUSH {R4, LR}

    MOV R4, #0xFF        // Inicializar output para parpadeo

loopParpadeo:
    MOV R0, R4
    BL display_binary

    MOV R0, R4
    BL mostrar_leds

    EOR R4, R4, #0xFF    // Alternar bits
    MOV R0, #1           // Indice para el arreglo de retardo
    BL retardo

    CMP R0, #0
    BNE loopParpadeo

    BL apagar_leds
    POP {R4, PC}
    .END
