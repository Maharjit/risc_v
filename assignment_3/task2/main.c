#include "uart.h"

extern void el0_main();

void switch_to_el0(void *el0_entry) {
    asm volatile (
        "msr sp_el0, %0\n"       // save EL0 stack
        "msr elr_el1, %1\n"      // set return addr
        "mov x0, 0\n"            // set SPSR_EL1 (no interrupts masked)
        "msr spsr_el1, x0\n"
        "eret\n"
        :: "r"(0x80000), "r"(el0_entry) : "x0"
    );
}

void main() {
    uart_init();
    uart_puts("Running in EL1\n");

    switch_to_el0(el0_main);
}
