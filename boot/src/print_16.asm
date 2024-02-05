; Print the string in SI to the screen.
[bits 16]
_boot_print_string:
    pusha

    ; int 10h 'print char' function
	mov ah, 0Eh	

    .loop:
        ; Get character from string
        lodsb
        ; If it is 0x00, string is over.
        cmp al, 0
        je .end
        ; Otherwise, print and continue.
        int 10h
        jmp .loop

    .end:
        popa
        ret

; Newline character sequence for printing (0x0A - Newline, 0x0D - Carry return).
%macro char_newline 0
db 0x0A, 0x0D
%endmacro

; Print the hex of the word in DX.
[bits 16]
_boot_print_hex_word:
    pusha

    ; Index.
    mov cx, 0

    .loop:
        ; Only 4 hex digits because we have a word.
        cmp cx, 4
        je .end
        
        ; Calculate hex digit.
        mov ax, dx
        and ax, 0x000f
        add al, 0x30

        ; Check for letter.
        cmp al, 0x39
        jle .skip
        add al, 7   ; Make it be a letter if > 9

        .skip:
            ; Go to the position we need to be at.
            mov si, .output + 5
            sub si, cx

            ; Save the character there,
            mov [si], al

            ; Rotate the hex digits to get to the next one.
            ror dx, 4

            ; increment index and loop
            add cx, 1
            jmp .loop

    .end:
        ; Print the output to the screen.
        mov si, .output
        call _boot_print_string

        popa
        ret

    .output:
        db '0x0000', 0x00 ; reserve memory for our new string