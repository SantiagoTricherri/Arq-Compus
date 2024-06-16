#include <stdio.h>
//#include "EasyPIO.h"
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <termios.h>

const char led[] = {14, 15, 18, 23, 24, 25, 8, 7};

void disp(int i) {
    int t;
    for (t = 128; t > 0; t = t / 2) {
        if (t & i) {
            printf("*");
        } else {
            printf("_");
        }
    }
    printf("\n");
}

void displ(int i, int estela) {
    int t;
    for (t = 128; t > 0; t = t / 2) {
        if (t & i) {
            printf("*");
        } else if (t & estela) {
            printf("*");
        } else {
            printf("_");
        }
    }
    printf("\n");
}

int leeds(int num) {
    int i, valnum;
    for (i = 0; i < 8; i++) {
        valnum = (num >> i) & 0x01;
        //digitalWrite(led[i], valnum);
    }
    return 0;
}

void set_input_mode(bool enable) {
    static struct termios oldt, newt;
    if (enable) {
        tcgetattr(STDIN_FILENO, &oldt);
        newt = oldt;
        newt.c_lflag &= ~(ICANON | ECHO);
        tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    } else {
        tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    }
}

int retardo(int velocidad){
    int a=velocidad;
    while (a>0){
        a--;
    }
    
    
    return velocidad;
}
int auto_fantastico(int velocidad) {
    printf("INICIANDO AUTO FANTASTICO...\n");
    int num = 0x80;
    set_input_mode(true); // Desactiva el modo canónico y el eco
    getchar();
    for (int i = 0; i < 8; i++) {
        disp(num);
        leeds(num);
        velocidad=retardo(velocidad);
        num = num / 2;
    }
    num = 0x02;
    for (int i = 0; i < 7; ++i) {
        disp(num);
        leeds(num);
        velocidad=retardo(velocidad);
        num = num * 2;
    }
     while (getchar() != '\n');
        set_input_mode(false);
    return velocidad;
}

int choque(int velocidad) {
    printf("INICIANDO CHOQUE...\n");
    int tabla[8] = {0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81};
    set_input_mode(true); // Desactiva el modo canónico y el eco
    getchar();
    for (int i = 0; i < 8; i++) {
        disp(tabla[i]);
        leeds(tabla[i]);
        velocidad = retardo(velocidad);
        
    }
    // Limpiar el buffer de entrada
        while (getchar() != '\n');
        set_input_mode(false);
    return velocidad;
}

// Por tabla
int luciernagas(int velocidad) {
    printf("INICIANDO LUCIERNAGAS...\n");
    int tabla[12] = {0x00, 0x44, 0x80, 0x25, 0x60, 0x00, 0x3A, 0x91, 0x04, 0x00, 0x48, 0x00};
    set_input_mode(true); // Desactiva el modo canónico y el eco
    getchar();
    for (int i = 0; i < 12; i++) {
        disp(tabla[i]);
        leeds(tabla[i]);
        velocidad=retardo(velocidad);
    }
     while (getchar() != '\n');
        set_input_mode(false);
    return velocidad;
}

int cohete(int velocidad) {
    printf("INICIANDO COHETE...\n");
    int num = 0x80;
    set_input_mode(true); // Desactiva el modo canónico y el eco
    getchar();
        disp(num);
        leeds(num);
        velocidad=retardo(velocidad);
        num= 0xC0;
    for (int i = 0; i < 5; i++) {
        disp(num);
        leeds(num);
        num = num >> 1;
        velocidad=retardo(velocidad);
    }
    num = 0xFF;
    for (int i = 0; i < 2; i++) {
        disp(num);
        leeds(num);
        velocidad=retardo(velocidad);
    }
     while (getchar() != '\n');
        set_input_mode(false);
    return velocidad;
}

bool acceso() {
    const char *password = "12345";
    char input[6];
    for (int i = 0; i < 3; ++i) {
        printf("Ingrese la contrasena (5 digitos): ");
        scanf("%5s", input);

        if (strcmp(input, password) != 0) {
            printf("Contrasena incorrecta.\n");
        } else {
            printf("Acceso concedido.\n");
            return true;
        }
    }
    return false;
}



int main() {
    int opcion, velocidad;
    velocidad = 200000000;

    //pioInit();
    int i;
    for (i = 0; i < 8; i++) {
        //pinMode(led[i], OUTPUT);
    }

    leeds(0xFF);
    bool ac = acceso();
    if (!ac) {
        printf("Contrasena incorrecta. Acceso denegado.\n");
        return 1;
    }

    getchar();

    do {
        leeds(0x00);
        printf("Menu:\n");
        printf("1. Auto Fantastico\n");
        printf("2. Choque\n");
        printf("3. Luciernagas\n");
        printf("4. Cohete\n");
        printf("5. Resetear velocidad\n");
        printf("0. Salir\n");
        printf("Seleccione una opcion: ");
        
        opcion = getchar() - '0'; // Leer opción del usuario

        switch (opcion) {
            case 1:
                velocidad = auto_fantastico(velocidad);
                break;
            case 2:
                velocidad = choque(velocidad);
                break;
            case 3:
                velocidad = luciernagas(velocidad);
                break;
            case 4:
                velocidad = cohete(velocidad);
                break;
            case 5:
                printf("Se reseteo la velocidad\n");
                velocidad = 200000;
                break;
            case 0:
                printf("Saliendo...\n");
                break;
            default:
                printf("Opcion no valida\n");
                break;
        }

        

    } while (opcion != 0);

     // Restaura la configuración de la terminal

    return 0;
}
