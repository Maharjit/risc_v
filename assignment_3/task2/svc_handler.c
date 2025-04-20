#include "uart.h"

void handle_svc_from_el0() {
    unsigned long x0;
    asm volatile ("mov %0, x0" : "=r"(x0));

    uart_send((char)x0); // EL1 does UART output
}
