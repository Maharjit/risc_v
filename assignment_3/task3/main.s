.section .text.boot
.globl _start
_start:
    // Set up exception vector
    ldr x0, =vector_table
    msr vbar_el1, x0

    // Set up UART for output
    bl uart_init

    // Init MMU: kernel TTBR1, user TTBR0
    bl mmu_init

    // Set up EL0 stack
    ldr x0, =user_stack_top
    msr sp_el0, x0

    // Set up syscall handler
    bl enable_svc_handler

    // Print from EL1
    ldr x0, =msg_el1
    bl printf

    // Set up EL0 context
    mov x0, #0                // Clear SPSR_EL1 (EL0, SP_EL0)
    msr spsr_el1, x0
    ldr x1, =user_entry       // User program VA
    msr elr_el1, x1
    eret                      // Enter EL0

.section .text
user_entry:
    svc #0
hang:
    b hang

.align 12
vector_table:
    b .                       // reset
    b .                       // undef
    b svc_handler             // svc
    b .                       // pabt
    b .                       // dabt
    b .                       // hyp
    b .                       // irq
    b .                       // fiq

svc_handler:
    ldr x0, =msg_el0
    bl printf
    eret

enable_svc_handler:
    ret

// Minimal printf
printf:
    ldr x1, =UART0_DR
.loop:
    ldrb w2, [x0], #1
    cbz w2, .done
    strb w2, [x1]
    b .loop
.done:
    ret

uart_init:
    ret

mmu_init:
    ldr x0, =mair_val
    msr mair_el1, x0

    ldr x0, =tcr_val
    msr tcr_el1, x0

    ldr x0, =ttbr0_base
    msr ttbr0_el1, x0

    ldr x0, =ttbr1_base
    msr ttbr1_el1, x0

    mrs x0, sctlr_el1
    orr x0, x0, #(1 << 0)
    msr sctlr_el1, x0
    ret

.data
msg_el1:
    .asciz "Hello from EL1\n"
msg_el0:
    .asciz "Hello from EL0 via syscall!\n"

.bss
.align 12
ttbr0_base: .space 4096
.align 12
ttbr1_base: .space 4096
user_stack_top: .space 1024

// Constants
.equ UART0_DR, 0x3F201000
mair_val: .quad 0x00FF
tcr_val: .quad 0x0000000000000000
```