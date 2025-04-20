#define MMIO_BASE       0x3F000000
#define UART0_BASE      (MMIO_BASE + 0x201000)

#define UART0_DR        ((volatile unsigned int*)(UART0_BASE + 0x00))
#define UART0_FR        ((volatile unsigned int*)(UART0_BASE + 0x18))

void uart_send(unsigned int c) {
    while (*UART0_FR & (1 << 5)); // Wait until TXFF is clear
    *UART0_DR = c;
}

void uart_puts(const char* str) {
    while (*str) {
        if (*str == '\n') uart_send('\r');
        uart_send(*str++);
    }
}

void main() {
    uart_puts("Hello World\n");

    while (1);
}
