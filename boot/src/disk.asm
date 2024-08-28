; This assumes that the sector count is loaded in DH and the drive itself is set up in DL.
; The data for the sectors is loaded at the ES:BX address.
; https://stanislavs.org/helppc/int_13-2.html
disk_load:
    pusha
    push DX
    mov AH, 0x02                        ; Read
    mov AL, DH                          ; DH sectors
    mov DL, [sector_1.data.BOOT_DRIVE]  ; What drive
    mov CH, 0x00                        ; What cylinder
    mov DH, 0x00                        ; What head
    int 0x13
    jc disk_load.disk_error
    pop DX
    cmp AL, DH
    jne disk_load.sectors_error
disk_load.done:
    popa
    ret
disk_load.data:
    disk_load.data.DISK_ERROR: db "An error has occured while reading sector from disk. (Error, Disk) = ", 0
    disk_load.data.SECTORS_ERROR: db "Wrong number of sectors have been read from disk.", 0

disk_load.disk_error:
    mov BX, disk_load.data.DISK_ERROR
    call boot_print
    mov DH, AH
    call boot_print_hex
    sti
    jmp $

disk_load.sectors_error:
    mov BX, disk_load.data.SECTORS_ERROR
    call boot_print
    sti
    jmp $