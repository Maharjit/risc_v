#include "uart.h"
#define UART0_BASE 0x3F201000

#define UART0_DR     ((volatile unsigned int *)(UART0_BASE + 0x00))
#define UART0_FR     ((volatile unsigned int *)(UART0_BASE + 0x18))

void uart_send(char c) {
    while (*UART0_FR & (1 << 5)); // Wait while TX FIFO full
    *UART0_DR = c;
}

void uart_puts(const char *s) {
    while (*s)
        uart_send(*s++);
}

// minimal printf
void printf(const char *s, ...) {
    uart_puts(s); // no format parsing
}
