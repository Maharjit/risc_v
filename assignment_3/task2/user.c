void el0_main() {
    asm volatile (
        "mov x0, #'A'\n"   // char to print
        "svc #0\n"         // syscall to EL1
    );

    while (1);
}
