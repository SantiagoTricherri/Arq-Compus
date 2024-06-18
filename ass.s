.data
delayTime: .word 10000  // Espacio de memoria para almacenar el tiempo de retardo

.text

.global cohete
.extern ledShow
.extern disp_binary
.extern turnOff
.extern delayC
.extern keyHit

cohete:
    PUSH {R4, R5, R6, R7, LR}
    
    // Inicializar variables
    LDR R7, =delayTime  // Cargar la dirección de memoria del tiempo de retardo
    LDR R7, [R7]        // Cargar el valor de tiempo de retardo (10000)
    MOV R5, #8          // Número de LEDs (NUM_LEDS)
    MOV R6, #5          // Contador para vuelo
    MOV R4, #10         // Contador para explosión

launch:
    // Lanzamiento del cohete con aceleración
    MOV R3, #0        // i = 0
launch_loop:
    CMP R3, R5        // Comparar i con NUM_LEDS
    BGE flight        // Si i >= NUM_LEDS, ir a vuelo

    MOV R0, #1
    LSL R0, R0, R3    // Desplazar un bit a la izquierda
    BL ledShow        // Mostrar el valor en los LEDs
    MOV R0, R0        // Pasar el valor a R0 para disp_binary
    BL disp_binary    // Mostrar el valor en binario en la pantalla

    // Llamar a delay_wrapper
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL delay_wrapper
    BL check_key      // Verificar si se presionó una tecla

    // Acelerar el lanzamiento
    SUBS R7, R7, #500 // Reducir el tiempo de retardo
    ADD R3, R3, #1    // Incrementar i
    B launch_loop     // Repetir el ciclo

flight:
    // Vuelo del cohete
    MOV R3, #0        // j = 0
flight_loop:
    CMP R3, R6        // Comparar j con 5
    BGE explosion     // Si j >= 5, ir a explosión

    MOV R0, #0xFF     // Todos los LEDs encendidos
    BL ledShow        // Mostrar el valor en los LEDs
    MOV R0, R0        // Pasar el valor a R0 para disp_binary
    BL disp_binary    // Mostrar el valor en binario en la pantalla

    // Llamar a delay_wrapper
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL delay_wrapper
    BL check_key      // Verificar si se presionó una tecla

    MOV R0, #0x00     // Todos los LEDs apagados
    BL ledShow        // Mostrar el valor en los LEDs
    MOV R0, R0        // Pasar el valor a R0 para disp_binary
    BL disp_binary    // Mostrar el valor en binario en la pantalla

    // Llamar a delay_wrapper
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL delay_wrapper
    BL check_key      // Verificar si se presionó una tecla

    ADD R3, R3, #1    // Incrementar j
    B flight_loop     // Repetir el ciclo

explosion:
    // Explosión del cohete
    MOV R3, #0        // j = 0
explosion_loop:
    CMP R3, R4        // Comparar j con 10
    BGE reset_delay   // Si j >= 10, reiniciar el delay

    MOV R0, #0xAA     // Patrón alternante
    BL ledShow        // Mostrar el valor en los LEDs
    MOV R0, R0        // Pasar el valor a R0 para disp_binary
    BL disp_binary    // Mostrar el valor en binario en la pantalla

    // Llamar a delay_wrapper
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL delay_wrapper
    BL check_key      // Verificar si se presionó una tecla

    MOV R0, #0x55     // Patrón alternante inverso
    BL ledShow        // Mostrar el valor en los LEDs
    MOV R0, R0        // Pasar el valor a R0 para disp_binary
    BL disp_binary    // Mostrar el valor en binario en la pantalla

    // Llamar a delay_wrapper
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL delay_wrapper
    BL check_key      // Verificar si se presionó una tecla

    ADD R3, R3, #1    // Incrementar j
    B explosion_loop  // Repetir el ciclo

reset_delay:
    // Restablecer el tiempo de retardo después de la explosión
    LDR R7, =delayTime // Cargar la dirección de memoria del tiempo de retardo
    LDR R7, [R7]       // Cargar el valor de tiempo de retardo (10000)
    B launch           // Repetir la secuencia completa

check_key:
    MOV R0, #3        // Usar índice 3 para delay
    MOV R1, #1        // isAsm = true
    BL keyHit         // Verificar si se presionó una tecla
    CMP R0, #0        // Comparar el resultado
    BEQ continue_seq  // Si no se presionó ninguna tecla, continuar

    BL turnOff        // Apagar los LEDs
    POP {R4, R5, R6, R7, LR}
    BX LR             // Salir de la secuencia

continue_seq:
    BX LR             // Continuar la secuencia

delay_wrapper:
    PUSH {LR}         // Guardar el valor del enlace de retorno en la pila
    MOV R0, R7        // Usar el valor de R7 como delayTime
    BL delayC
    POP {LR}          // Recuperar el valor del enlace de retorno de la pila
    MOV PC, LR        // Regresar al llamador
   


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
    bl delay_wrappper       

    add r4, r4, #1         
    subs r5, r5, #1        
    bgt loop_start         

    bl turnOff             
    pop {lr}               
    mov pc, lr             

delay_wrappper:
    push {lr}              
    mov r0, r6             
    bl delay              
    pop {lr}               
    mov pc, lr             

pattern:
    .byte 0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00

