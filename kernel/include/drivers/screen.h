#pragma once

#include <stdint.h>

#define MAX_ROWS 25
#define MAX_COLS 80

#define COLOR_BLACK 0x0
#define COLOR_BLUE 0x1
#define COLOR_GREEN 0x2
#define COLOR_CYAN 0x3
#define COLOR_RED 0x4
#define COLOR_MAGENTA 0x5
#define COLOR_BROWN 0x6
#define COLOR_LIGHT_GREY 0x7
#define COLOR_DARK_GREY 0x8
#define COLOR_LIGHT_BLUE 0x9
#define COLOR_LIGHT_GREEN 0xA
#define COLOR_LIGHT_CYAN 0xB
#define COLOR_LIGHT_RED 0xC
#define COLOR_LIGHT_MAGENTA 0xD
#define COLOR_LIGHT_BROWN 0xE
#define COLOR_WHITE 0xF

#define RED_ON_WHITE 0xF4

#define PORT_SCREEN_CTRL 0x3D4
#define PORT_SCREEN_DATA 0x3D5

// Clears the screen.
void kclear_screen();

/*
 * Prints a string at the specified coordonates.
 * if -1 is used as an argument, it will use the current values of the cursor.
 */
void kprint_at(char* message, int32_t col, int32_t row);

// Control the display color.
void kset_color_background(uint8_t color);
void kset_color_foreground(uint8_t color);
uint16_t kget_color();

// Prints a message at the cursor's position.
#define kprint(message) kprint_at(message, -1, -1);