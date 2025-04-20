.section .vectors, "a"
.globl _vectors

_vectors:
    // EL0 -> EL1 Sync Exception (SVC)
    b sync_el0_handler

    // Unused
    .space 0x80

sync_el0_handler:
    bl handle_svc_from_el0
    eret
