.global _start

.section .text
_start:
    ldr sp, =0x8000        // Set stack pointer
    bl main                // Branch to main
hang:
    b hang                 // Infinite loop
