data:
    .loaded_bootloader:
        char_newline
        db 'Finished loading the bootloader.', 0x00

    .loaded_kernel:
        char_newline
        db 'Finished loading the kernel.', 0x00

    .introduction:
        char_newline
        db 'Loading Retro OS...', 0x00