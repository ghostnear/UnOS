#include "drivers/screen.h"

// The entry point for the kernel.
void kernel_main()
{
    kset_color_background(COLOR_BLACK);
    kset_color_foreground(COLOR_LIGHT_GREY);
    kclear_screen();
    kprint("\nWelcome to UnOS!\n\n");
    kprint("root> ");
}