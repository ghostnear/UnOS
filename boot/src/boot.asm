[org 0x7C00]
KERNEL_OFFSET equ 0x1000

; boot sector = Sector 1 of cyl 0 of head 0 of hdd 0
sector_1:
main:
    cli                                                         ; Disable external interrupts.
    mov [sector_1.data.BOOT_DRIVE], DL                          ;
    mov BP, 0x9000                                              ;
    mov SP, BP                                                  ; Set up the stack
    call boot_clear_screen                                      ;
    mov BX, sector_1.data.INITIAL_SETUP_MESSAGE                 ;
    call boot_print                                             ; Initial setup complete.

    mov BX, 0x7C00 + 512                                        ; Where
    mov DH, 0x01                                                ; How much
    mov CL, 0x02                                                ; Start sector
    call disk_load                                              ; Load the rest of the bootloader data sectors.   
    mov BX, sector_2.data.READING_REST_MESSAGE                  ;
    call boot_print                                             ; Show message.

    mov BX, KERNEL_OFFSET                                       ; Where
    mov DH, 0x04                                                ; How much
    mov CL, 0x03                                                ; Start sector
    call disk_load                                              ; Load the kernel data sectors.
    mov BX, sector_2.data.READING_KERNEL_MESSAGE                ;
    call boot_print                                             ; Show message.

    mov BX, sector_2.data.RUNNING_KERNEL_MESSAGE                ;
    call boot_print                                             ; Final message from 16-bit mode.
    sti                                                         ; Enable external interrupts
    call switch_to_pm
    jmp $

sector_1.data:
    sector_1.data.BOOT_DRIVE: db 0x00
    sector_1.data.INITIAL_SETUP_MESSAGE: db 'Initial setup complete!', 0xA, 0xD, 0x0

sector_1.code:
    %include 'src/disk.asm'
    %include 'src/boot_print.asm'

sector_1.end:
    times 510-($-sector_1) db 0x11                              ;
    dw 0xAA55                                                   ; Drop the magic bootable bytes at the end of the sector.

sector_2:
    %include 'src/protected.asm'
sector_2.data:
    sector_2.data.READING_REST_MESSAGE: db 'Read the bootloader from the disk!', 0xA, 0xD, 0x0
    sector_2.data.READING_KERNEL_MESSAGE: db 'Read kernel from the disk!', 0xA, 0xD, 0x0
    sector_2.data.RUNNING_KERNEL_MESSAGE: db 'Starting kernel', 0x0
sector_2.end:
    times 512-($-sector_2) db 0x22