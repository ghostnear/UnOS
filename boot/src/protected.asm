[bits 16]
_boot_protected_switch:
    cli                                     ; 1. disable interrupts
    lgdt [gdt_descriptor]                   ; 2. load the GDT descriptor
    mov eax, cr0                            ;
    or eax, 0x1                             ; 3. set 32-bit mode bit in cr0
    mov cr0, eax                            ;
    jmp CODE_SEGMENT:_boot_init_protected   ; 4. far jump by using a different segment

[bits 32]
_boot_init_protected:
    mov ax, DATA_SEGMENT    ;
    mov ds, ax              ;
    mov ss, ax              ;
    mov es, ax              ;
    mov fs, ax              ;
    mov gs, ax              ; 5. update the segment registers
    mov ebp, 0x90000        ;
    mov esp, ebp            ; 6. update the stack right at the top of the free space
    call _protected_start   ; 7. Call a well-known label with useful code


VIDEO_MEMORY equ 0xB8000    ; Address for VGA VRAM
WHITE_ON_BLACK equ 0x0F     ; the color byte for each character

[bits 32]
_protected_print_string:
    pusha
    mov edx, VIDEO_MEMORY

    .loop:
        mov al, [ebx] ; [ebx] is the address of our character
        mov ah, WHITE_ON_BLACK

        cmp al, 0 ; check if end of string
        je .done

        mov [edx], ax ; store character + attribute in video memory
        add ebx, 1 ; next char
        add edx, 2 ; next video memory position

        jmp .loop

    .done:
        popa
        ret

[bits 32]
_protected_start:
    call KERNEL_OFFSET
    jmp $