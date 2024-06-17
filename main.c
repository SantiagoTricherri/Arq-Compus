#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <stdbool.h>
#include <fcntl.h>
#include <ncurses.h>
#include "EasyPIO.h"
#include "funciones_ass.h"

// Definiciones
#define PASSWORD_LENGTH 5   // Longitud de la contraseña
#define NUM_LEDS 8          // Numero de LEDs

// Declaraciones de funciones
void disp_binary(int);                     // Mostrar valor en binario
void getPassword(char *password);          // Obtener la contraseña del usuario
void showMenu();                           // Mostrar el menu principal
void autoFantastico();                     // Secuencia "Auto Fantastico"
void choque();                             // Secuencia "Choque"
//void luciernagas();                        // Secuencia "Luciernagas"
//void cohete();                             // Secuencia "Cohete"
struct termios modifyTerminalConfig(void); // Configurar terminal
void restoreTerminalConfig(struct termios);// Restaurar configuracion del terminal
bool keyHit(int index);                    // Verificar pulsacion de teclas
void pinSetup(void);                       // Configurar pines
int delay(int index);                      // Funcion de retardo
void clearInputBuffer();                   // Limpiar el buffer de entrada
void turnOff();                            // Apagar los LEDs
void ledShow(unsigned char output);        // Mostrar LEDs

// Variables globales
const unsigned char led[NUM_LEDS] = {14, 15, 18, 23, 24, 25, 8, 7}; // Pines de los LEDs
int delayTime[] = {10000, 10000, 10000, 10000};                    // Tiempo de retardo inicial

// Función principal
int main(void) {
    pinSetup(); // Inicializar los pines de los LEDs
    char setPassword[PASSWORD_LENGTH] = {'1', '2', '3', '4', '5'}; // Contraseña predeterminada
    char passwordInput[PASSWORD_LENGTH]; // Arreglo para la contraseña ingresada por el usuario

    // Recepción de la contraseña y validación
    for (int i = 0; i < 3; i++) { // Permitir hasta 3 intentos
        bool passwordFlag = true; // Bandera para indicar si la contraseña es correcta
        getPassword(passwordInput); // Obtener la contraseña del usuario

        // Verificar la contraseña
        for (int j = 0; j < PASSWORD_LENGTH; j++) {
            if (setPassword[j] != passwordInput[j]) { // Comparar caracteres
                passwordFlag = false; // Si hay una diferencia, la contraseña es incorrecta
                break;
            }
        }

        // Si la contraseña es correcta, mostrar el menu
        if (passwordFlag) {
            printf("Bienvenido :)\n\n");
            showMenu();
            printf("Trabajo terminado!!\n");
            break;
        } else {
            printf("La clave es incorrecta...!\n\n"); // Mensaje de error
        }
    }

    return 0; // Terminar el programa
}

// Función para mostrar un valor en binario
void disp_binary(int i) {
    int t;
    for (t = 128; t > 0; t = t / 2) { // Iterar sobre los bits
        if (i & t) printf("1 ");      // Si el bit esta encendido, mostrar "1"
        else printf("0 ");            // Si el bit esta apagado, mostrar "0"
    }
    fflush(stdout); // Vaciar el buffer de salida
    printf("\r");   // Retorno de carro
}

// Función para obtener la contraseña del usuario
void getPassword(char *password) {
    struct termios oldattr = modifyTerminalConfig(); // Configurar el terminal
    printf("Ingrese su clave: ");
    for (int i = 0; i < PASSWORD_LENGTH; i++) {
        password[i] = getchar(); // Leer caracter por caracter
        printf("*");             // Mostrar un asterisco por cada caracter
        fflush(stdout);          // Vaciar el buffer de salida
    }
    restoreTerminalConfig(oldattr); // Restaurar configuracion del terminal
    printf("\n");
}

// Función para mostrar el menú
void showMenu() {
    int option;

    do {
        clearInputBuffer(); // Limpiar el buffer de entrada
        printf("\n------------------\n");
        printf("   Menu Principal\n");
        printf("------------------\n");
        printf("1. Auto Fantastico\n");
        printf("2. El Choque\n");
        printf("3. Luciernagas\n");
        printf("4. Cohete\n");
        printf("0. Salir\n");
        printf("------------------\n");
        printf("Seleccione una opcion: ");
        scanf("%d", &option); // Leer la opcion seleccionada

        switch (option) {
            case 1:
                autoFantastico(); // Ejecutar la secuencia "Auto Fantastico"
                break;
            case 2:
                choque(); // Ejecutar la secuencia "Choque"
                break;
            case 3:
                luciernagas(); // Ejecutar la secuencia "Luciernagas"
                break;
            case 4:
                cohete(); // Ejecutar la secuencia "Cohete"
                break;
            case 0:
                printf("Saliendo...\n"); // Salir del programa
                break;
            default:
                printf("Seleccione una opcion valida\n"); // Mensaje de error
        }
    } while (option != 0); // Repetir hasta que se seleccione la opcion de salir
}

// Secuencia "Auto Fantastico"
void autoFantastico() {
    printf("\n--- Auto Fantastico ---\n");
    printf("Presione esc para finalizar la secuencia\n");
    printf("Presione W para aumentar la velocidad\n");
    printf("Presione S para disminuir la velocidad\n");

    unsigned char output;

    while (true) {
        output = 0x80; // Comenzar con el bit mas significativo
        for (int i = 0; i < NUM_LEDS; i++) {
            ledShow(output); // Mostrar el valor en los LEDs
            disp_binary(output); // Mostrar el valor en binario en la pantalla
            output >>= 1; // Desplazar a la derecha

            if (delay(0) == 0) { // Esperar el retardo y verificar si se presiono una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }
        output = 0x02; // Comenzar con el segundo bit mas bajo

        for (int i = 0; i < 6; i++) {
            ledShow(output); // Mostrar el valor en los LEDs
            disp_binary(output); // Mostrar el valor en binario en la pantalla
            output <<= 1; // Desplazar a la izquierda

            if (delay(0) == 0) { // Esperar el retardo y verificar si se presiono una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }
    }
}

// Secuencia "Choque"
void choque() {
    printf("\n--- Choque ---\n");
    printf("Presione esc para finalizar la secuencia\n");
    printf("Presione W para aumentar la velocidad\n");
    printf("Presione S para disminuir la velocidad\n");

    unsigned char output, aux1, aux2;

    while (true) {
        aux1 = 0x80; // LED mas significativo
        aux2 = 0x01; // LED menos significativo
        for (int i = 0; i < 7; i++) {
            output = aux1 | aux2; // Combinar los dos LEDs
            ledShow(output); // Mostrar el valor en los LEDs
            disp_binary(output); // Mostrar el valor en binario en la pantalla
            aux1 >>= 1; // Desplazar aux1 a la derecha
            aux2 <<= 1; // Desplazar aux2 a la izquierda

            if (delay(1) == 0) { // Esperar el retardo y verificar si se presiono una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }
    }
}
/*
// Secuencia "Luciernagas"
void luciernagas() {
    printf("\n--- Luciernagas ---\n");
    int pattern[12] = {0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00}; // Patrón de luces

    while (true) {
        for (int i = 0; i < 12; i++) {
            ledShow(pattern[i]); // Mostrar el patrón en los LEDs
            disp_binary(pattern[i]); // Mostrar el patrón en binario en la pantalla
            if (delay(2) == 0) { // Esperar el retardo y verificar si se presiono una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }
    }
}

void cohete() {
    printf("\n--- Cohete ---\n");
    printf("Presione esc para finalizar la secuencia\n");
    printf("Presione W para aumentar la velocidad\n");
    printf("Presione S para disminuir la velocidad\n");

    unsigned char num;

    while (true) {
        // Lanzamiento del cohete con aceleración
        printf("Lanzamiento del cohete:\n");
        for (int i = 0; i < NUM_LEDS; i++) {
            num = 1 << i; // Desplazar un bit a la izquierda
            ledShow(num); // Mostrar el valor en los LEDs
            disp_binary(num); // Mostrar el valor en binario en la pantalla
            if (delay(3) == 0) { // Esperar el retardo y verificar si se presionó una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
            delayTime[3] -= 500; // Acelerar el lanzamiento
        }

        // Vuelo del cohete
        printf("Vuelo del cohete:\n");
        for (int j = 0; j < 5; j++) {
            num = 0xFF; // Todos los LEDs encendidos
            ledShow(num); // Mostrar el valor en los LEDs
            disp_binary(num); // Mostrar el valor en binario en la pantalla
            if (delay(3) == 0) { // Esperar el retardo y verificar si se presionó una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
            num = 0x00; // Todos los LEDs apagados
            ledShow(num); // Mostrar el valor en los LEDs
            disp_binary(num); // Mostrar el valor en binario en la pantalla
            if (delay(3) == 0) { // Esperar el retardo y verificar si se presionó una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }

        // Explosión del cohete
        printf("Explosión del cohete:\n");
        for (int j = 0; j < 10; j++) {
            num = 0xAA; // Patrón alternante
            ledShow(num); // Mostrar el valor en los LEDs
            disp_binary(num); // Mostrar el valor en binario en la pantalla
            if (delay(3) == 0) { // Esperar el retardo y verificar si se presionó una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
            num = 0x55; // Patrón alternante inverso
            ledShow(num); // Mostrar el valor en los LEDs
            disp_binary(num); // Mostrar el valor en binario en la pantalla
            if (delay(3) == 0) { // Esperar el retardo y verificar si se presionó una tecla
                turnOff(); // Apagar los LEDs
                return; // Salir de la secuencia
            }
        }

        // Restablecer el tiempo de retardo después de la explosión
        delayTime[3] = 10000;
    }
}
*/

// Configuración del terminal
struct termios modifyTerminalConfig(void) {
    struct termios oldattr, newattr;
    tcgetattr(STDIN_FILENO, &oldattr); // Obtener configuracion actual del terminal
    newattr = oldattr;
    newattr.c_lflag &= ~(ICANON | ECHO); // Desactivar modo canonico y eco
    tcsetattr(STDIN_FILENO, TCSANOW, &newattr); // Aplicar nueva configuracion
    return oldattr; // Devolver configuracion anterior
}

// Restaurar la configuración del terminal
void restoreTerminalConfig(struct termios oldattr) {
    tcsetattr(STDIN_FILENO, TCSANOW, &oldattr); // Restaurar configuracion anterior
}

// Verificar la pulsación de teclas
bool keyHit(int index) {
    struct termios oldattr = modifyTerminalConfig();
    int ch, oldf;
    oldf = fcntl(STDIN_FILENO, F_GETFL, 0); // Obtener flags actuales
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK); // Establecer modo no bloqueante
    ch = getchar(); // Leer caracter

    if (ch == 'w' && delayTime[index] > 1000) {
        delayTime[index] -= 1000; // Aumentar la velocidad
    }
    if (ch == 's') {
        delayTime[index] += 1000; // Disminuir la velocidad
    }

    restoreTerminalConfig(oldattr); // Restaurar configuracion del terminal
    fcntl(STDIN_FILENO, F_SETFL, oldf); // Restaurar flags originales

    if (ch == 27) { // Si se presiona ESC
        ungetc(ch, stdin); // Devolver caracter al buffer de entrada
        return true; // Indicar que se presiono ESC
    }

    return false; // No se presiono ESC
}

// Inicializar los pines
void pinSetup(void) {
    pioInit(); // Inicializar EasyPIO
    for (int i = 0; i < NUM_LEDS; i++) {
        pinMode(led[i], OUTPUT); // Establecer pines como salida
    }
}

// Mostrar LEDs
void ledShow(unsigned char output) {
    for (int j = 0; j < NUM_LEDS; j++) {
        digitalWrite(led[j], (output >> j) & 1); // Escribir valor en los pines
    }
}

// Función de retardo para las secuencias
int delay(int index) {
    for (int i = delayTime[index]; i > 0; i -= 1000) {
        usleep(1000); // Retardo en microsegundos
        if (keyHit(index)) {
            return 0; // Si se presiono una tecla, salir
        }
    }
    return 1; // Continuar si no se presiono una tecla
}

// Limpiar el buffer de entrada
void clearInputBuffer() {
    printf("Presione ENTER para confirmar\n");
    int c;
    while ((c = getchar()) != '\n' && c != EOF) {
        // Descartar caracteres
    }
}

// Apagar los LEDs
void turnOff() {
    unsigned char off = 0x00; // Valor para apagar los LEDs
    ledShow(off); // Apagar los LEDs
}
