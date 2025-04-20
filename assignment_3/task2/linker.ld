SECTIONS {
    . = 0x80000;

    .text : {
        *(.text)
    }

    .vectors : {
        *(.vectors)
    }

    .bss : {
        *(.bss)
    }

    .data : {
        *(.data)
    }

    _stack_top = . + 0x10000;
}
