.section .text
.globl _start

_start:
    // Set up stack pointer for EL1
    ldr x0, =_stack_top
    mov sp, x0

    // Load vector base address
    ldr x0, =_vectors
    msr VBAR_EL1, x0

    bl main

    b .
