; load DH sectors from drive DL into ES:BX
; DL is given by the bootloader after boot.
_boot_disk_load:
    pusha

    ; Save DX for later.
    push dx

    ; Set up stuff.
    mov ah, 0x02 ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh   ; al <- number of sectors to read (0x01 .. 0x80)
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
    ; dl <- drive number. Our caller sets it as a parameter and gets it from BIOS
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)

    ; [es:bx] <- pointer to buffer where the data will be stored
    ; caller sets it up for us, and it is actually the standard location for int 13h
    int 0x13        ; BIOS interrupt
    jc .disk_error  ; if error (stored in the carry bit)

    ; Check the number of sectors read from AL (BIOS sets it).
    pop dx
    cmp al, dh
    jne .sectors_error

    ; End.
    popa
    ret

    .disk_error:
        mov si, .disk_error_message
        call _boot_print_string

        ; ah = error code, dl = disk drive that dropped the error
        mov dh, ah 
        call _boot_print_hex_word

        jmp .disk_loop

    .sectors_error:
        mov si, .sectors_error_message
        call _boot_print_string

    .disk_loop:
        jmp $

    .disk_error_message:
        db "An error occured while reading from disk. ", 0x00

    .sectors_error_message:
        db "Incorrect number of sectors read."
        char_newline
        db 0x00