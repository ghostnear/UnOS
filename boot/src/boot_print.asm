; https://stanislavs.org/helppc/int_10-e.html

; This assumes BX has the base pointer of the string
; and that the string is null terminated.
boot_print:
    pusha
    mov AH, 0x0E
    
    boot_print.inside_loop:
        mov AL, [BX]
        cmp AL, 0
        je boot_print.done
        int 0x10
        inc BX
        jmp boot_print.inside_loop

boot_print.done:
    popa
    ret
; end of boot_print

; This assumes DX has the number to be converted.
boot_print_hex:
    pusha
    mov CX, 4
    mov AH, 0x0E
    mov AL, '0'
    int 0x10
    mov AL, 'x'
    int 0x10

    boot_print_hex.inside_loop:
        mov AL, DH
        and AL, 0xF0
        shr AL, 4
        add AL, 0x30
        cmp AL, 0x39    ; Hex digit?
        jle boot_print_hex.inside_loop.skip_not_hex
        add AL, 7
    boot_print_hex.inside_loop.skip_not_hex:
        int 0x10
        rol DX, 4       ; Rotate 1 hex digit to the left.
        dec CX
        cmp CX, 0
        jne boot_print_hex.inside_loop

boot_print_hex.done:
    popa
    ret
; end of boot_print_hex

; https://stanislavs.org/helppc/int_10-2.html
; https://stanislavs.org/helppc/int_10-6.html
boot_clear_screen:
    pusha
    mov BH, 0x0F    ; Colors
    mov AH, 0x06    ; Scroll operation
    mov AL, 0x00    ; 0 lines - entire screen
    mov CH, 0       ;
    mov CL, 0       ;
    mov DH, 24      ;
    mov DL, 79      ; Affected area - Display is 80x25
    int 10h

    mov AH, 0x02    ; Move cursor
    mov BH, 0x00	; Page 0
    mov DH, 0x00	;
    mov DL, 0x00    ; Position
    int 10h

    popa
    ret
; end of boot_clear_screen