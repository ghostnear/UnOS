#include "drivers/screen.h"
#include "drivers/serial.h"

// The entry point for the kernel.
void kernel_main()
{
    kprint_serial("in kernel_main()\n");
    kset_color_background(COLOR_BLACK);
    kset_color_foreground(COLOR_LIGHT_GREY);
    kclear_screen();
    kprint("\nWelcome to UnOS!\n\n");
    kprint("  _    _        ____      \n");
    kprint(" | |  | |      / __ \\     \n");
    kprint(" | |  | |_ __ | |  | |___ \n");
    kprint(" | |  | | '_ \\| |  | / __|\n");
    kprint(" | |__| | | | | |__| \\__ \\\n");
    kprint("  \\____/|_| |_|\\____/|___/\n");
    kprint("\nroot> ");
}