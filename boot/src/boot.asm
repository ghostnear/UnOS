KERNEL_OFFSET equ 0x1000

[org 0x7C00]
;
;   Segment 0x01
;
_boot_segment_01:

[bits 16]
_boot_start:
    ; Set up the stack (BIOS start address - 2, grows backwards to 0x500, careful to not overwrite).
    ; Page 14 of http://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
    mov bp, 0x7C00 - 2
    mov sp, bp

    ; Save the boot drive for later.
    mov [BOOT_DRIVE], dl

    ; Load the next sectors.
    mov bx, _boot_segment_02    ; Load base.
    mov cl, 0x02                ; cl <- sector index (0x01 .. 0x11), 0x01 is the boot sector.
    mov dh, 1                   ; Segment count.
    ; dl is already set by the bios to our disk number.
    call _boot_disk_load

    ; We're done, show it.
    mov si, data.loaded_bootloader
    call _boot_print_string

    ; Load the kernel.
    mov bx, KERNEL_OFFSET   ; Kernel in memory
    mov dh, 3               ; INFO: IF the kernel bootloops on boot, it's because of this.
    mov cl, 0x03            ; Sector 3 is the start of the kernel now.
    mov dl, [BOOT_DRIVE]
    call _boot_disk_load

    ; We're done, show it.
    mov si, data.loaded_kernel
    call _boot_print_string

    mov si, data.introduction
    call _boot_print_string

    ; Enter 32 bit mode.
    call _boot_protected_switch

    ; Infinite loop for safety.
    jmp $

BOOT_DRIVE:
    db 0x00

; The essential code from the first segment (it is loaded at all times).
%include "src/print_16.asm"
%include "src/disk.asm"

; 0 padding for the segment to end with.
times 510-($-_boot_segment_01) db 0x00

; Magic bootable signature for BIOS.
dw 0xAA55

;
;   Segment 0x02
;
; Planned for storing data and 32 bit related stuff.
_boot_segment_02:
%include "src/data.asm"
%include "src/gdt.asm"
%include "src/protected.asm"

; 0 padding for the segment to end with.
times 512-($-_boot_segment_02) db 0x11