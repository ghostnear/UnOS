[bits 32]
global _start;
_start:
    [extern kernel_main]    ; Define calling point. Must have same name as kernel.c 'main' function
    call kernel_main        ; Calls the C function. The linker will know where it is placed in memory
    jmp $