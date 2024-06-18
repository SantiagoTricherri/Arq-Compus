#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <stdbool.h>
#include <fcntl.h>
#include <ncurses.h>
#include "EasyPIO.h"
#include "assembly_functions.h"

#define PASSWORD_LENGTH 5

void disp_binary(int);
void getPassword(char *password);
void menu();
void autoFantastico();
void choque();
void cascadaDescendente();
void parpadeoCentral();
struct termios modifyTerminalConfig(void);
void restoreTerminalConfig(struct termios);
bool keyHit(int index);
void pinSetup(void);
void ledShow(unsigned char);
int delay(int index);
void clearInputBuffer();
void turnOff();

const unsigned char led[] = {14, 15, 18, 23, 24, 25, 8, 7};
int delayTime[] = {10000, 10000, 10000, 10000};

int main(void) {
    pinSetup();
    char setPassword[5] = {'h', 'e', 'l', 'l', 'o'};
    char passwordInput[5];

    for (int i = 0; i < 3; i++) {
        bool passwordFlag = true;
        getPassword(passwordInput);
        for (int j = 0; j < 5; j++) {
            if (setPassword[j] != passwordInput[j]) {
                passwordFlag = false;
                break;
            }
        }
        if (passwordBet: "Welcome to the system!\n\n");
            menu();
            printf("Goodbye!\n");
            break;
        } else {
            printf("Invalid password\n\n");
        }
    }
    return 0;
}

void disp_binary(int i) {
    for (int t = 128; t > 0; t = t / 2)
        printf("%d ", i & t ? 1 : 0);
    fflush(stdout);
    printf("\r");
}

void getPassword(char *password) {
    struct termios oldattr = modifyTerminalConfig();
    printf("Enter your password: ");
    for (int i = 0; i < PASSWORD_LENGTH; i++) {
        password[i] = getchar();
        printf("*");
        fflush(stdout);
    }
    restoreTerminalConfig(oldattr);
    printf("\n");
}

void menu() {
    int option;
    do {
        clearInputBuffer();
        printf("Select an option:\n");
        printf("1: Auto Fantastico\n");
        printf("2: El Choque\n");
        printf("3: Cascada Descendente\n");
        printf("4: Parpadeo Central\n");
        printf("0: Exit\n");
        scanf("%d", &option);

        switch (option) {
            case 1: autoFantastico(); break;
            case 2: choque(); break;
            case 3: cascadaDescendente(); break;
            case 4: parpadeoCentral(); break;
            case 0: break;
            default: printf("Select a valid option\n");
        }
    } while (option != 0);
}

void cascadaDescendente() {
    printf("Press ESC to end the sequence\n");
    printf("Press W to increase speed\n");
    printf("Press S to decrease speed\n");
    printf("Cascada Descendente:\n");

    unsigned char output = 0x1;
    for (int i = 0; i < 8; i++) {
        ledShow(output);
        disp_binary(output);
        output <<= 1;
        if (delay(2) == 0) {
            turnOff();
            return;
        }
    }
    output = 0x80;
    for (int i = 0; i < 8; i++) {
        ledShow(output);
        disp_binary(output);
        output >>= 1;
        if (delay(2) == 0) {
            turnOff();
            return;
        }
    }
}

void parpadeoCentral() {
    printf("Press ESC to end the sequence\n");
    printf("Press W to increase speed\n");
    printf("Press S to decrease speed\n");
    printf("Parpadeo Central:\n");

    unsigned char grupos[] = {0x18, 0x3C, 0x7E, 0xFF, 0x7E, 0x3C, 0x18};
    int indiceGrupo = 0;
    while (true) {
        ledShow(grupos[indiceGrupo]);
        disp_binary(grupos[indiceGrupo]);
        indiceGrupo = (indiceGrupo + 1) % 7;
        if (delay(2) == 0) {
            turnOff();
            return;
        }
    }
}

struct termios modifyTerminalConfig(void) {
    struct termios oldattr, newattr;
    tcgetattr(STDIN_FILENO, &oldattr);
    newattr = oldattr;
    newattr.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newattr);
    return oldattr;
}

void restoreTerminalConfig(struct termios oldattr) {
    tcsetattr(STDIN_FILENO, TCSANOW, &oldattr);
}

bool keyHit(int index) {
    struct termios oldattr = modifyTerminalConfig();
    int ch, oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
    ch = getchar();
    if (ch == 119 && delayTime[index] > 1000) delayTime[index] -= 1000;
    if (ch == 115) delayTime[index] += 1000;
    restoreTerminalConfig(oldattr);
    fcntl(STDIN_FILENO, F_SETFL, oldf);
    if (ch == 27) {
        ungetc(ch, stdin);
        return true;
    }
    return false;
}

void pinSetup(void) {
    pioInit();
    for (int i = 0; i < 8; i++) pinMode(led[i], OUTPUT);
}

void ledShow(unsigned char output) {
    for (int j = 0; j < 8; j++) digitalWrite(led[j], (output >> j) & 1);
}

int delay(int index) {
    for (int i = delayTime[index]; i > 0; --i) if (keyHit(index)) return 0;
    return 1;
}

void clearInputBuffer() {
    printf("Press ENTER to confirm\n");
    int c;
    while ((c = getchar()) != '\n' && c != EOF) {} // Discard characters
}

void turnOff() {
    unsigned char off = 0x0;
    ledShow(off);
}
