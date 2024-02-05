#include "drivers/screen.h"
#include "drivers/port.h"

#define VIDEO_ADDRESS (uint8_t*) 0xB8000

// Data handling for the screen.
typedef struct
{
    uint8_t ascii;
    uint8_t color;
} vga_char_t;

// Offset coords getters.

inline int32_t get_offset_row(uint32_t offset)
{
    return offset / MAX_COLS;
}

inline int32_t get_offset_col(uint32_t offset)
{
    return (offset - (get_offset_row(offset) * MAX_COLS));
}

uint32_t get_cursor_offset()
{
    /* Use the VGA ports to get the current cursor position
     * 1. Ask for high byte of the cursor offset (data 14)
     * 2. Ask for low byte (data 15)
     */
    
    // Read high byte.
    port_write_byte(PORT_SCREEN_CTRL, 14);
    uint32_t offset = port_read_byte(PORT_SCREEN_DATA) << 8;

    // Read low byte.
    port_write_byte(PORT_SCREEN_CTRL, 15);
    offset += port_read_byte(PORT_SCREEN_DATA);

    return offset;
}

// Gets the offset depending on the row and column.
inline uint32_t get_offset(int32_t col, int32_t row)
{
    return (row * MAX_COLS + col);
}

// Sets the offset of the cursor to the specified value.
void set_cursor_offset(uint32_t offset)
{
    port_write_byte(PORT_SCREEN_CTRL, 14);
    port_write_byte(PORT_SCREEN_DATA, (uint8_t)(offset >> 8));
    port_write_byte(PORT_SCREEN_CTRL, 15);
    port_write_byte(PORT_SCREEN_DATA, (uint8_t)(offset & 0xFF));
}

// Default color is dark gray on black.
static uint16_t display_color = 0x07;

/**
 * Innermost print function for our kernel, directly accesses the video memory 
 *
 * If 'col' and 'row' are negative, we will print at current cursor location
 * If 'attr' is zero it will use 'white on black' as default
 * Returns the offset of the next character
 * Sets the video cursor to the returned offset
 */
uint32_t print_char(char c, int32_t col, int32_t row)
{
    vga_char_t* vidmem = (vga_char_t*) VIDEO_ADDRESS;

    // TODO: implement scrolling on overflow.
    if(col >= MAX_COLS || row >= MAX_ROWS)
    {
        vidmem[(MAX_COLS) * (MAX_ROWS) - 1].ascii = 'E';
        vidmem[(MAX_COLS) * (MAX_ROWS) - 1].color = RED_ON_WHITE;
        return get_offset(col, row);
    }

    // Get current offset.
    int32_t offset;
    if(col >= 0 && row >= 0) offset = get_offset(col, row);
    else offset = get_cursor_offset();

    // Newline.
    if(c == '\n')
    {
        row = get_offset_row(offset);
        offset = get_offset(0, row+1);
    }
    // Anything else.
    else
    {
        vidmem[offset].ascii = c;
        vidmem[offset].color = display_color;
        offset++;
    }

    set_cursor_offset(offset);
    
    return offset;
}

/*
 *  Public functions.
 */

void kclear_screen()
{
    vga_char_t* screen = (vga_char_t*) VIDEO_ADDRESS;

    for(int32_t index = 0; index < MAX_COLS * MAX_ROWS; index++)
    {
        screen[index].ascii = ' ';
        screen[index].color = display_color;
    }
    
    set_cursor_offset(get_offset(0, 0));
}

/**
 * Print a message on the specified location
 * If col, row, are negative, we will use the current offset
 */
void kprint_at(char *message, int32_t col, int32_t row)
{
    /* Set cursor if col/row are negative */
    int32_t offset;
    if (col >= 0 && row >= 0)
        offset = get_offset(col, row);
    else {
        offset = get_cursor_offset();
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }

    /* Loop through message and print it */
    for(int32_t index = 0; message[index] != 0; index++)
    {
        offset = print_char(message[index], col, row);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

void kset_color_background(uint8_t color)
{
    display_color = (display_color & 0x0F) | (color << 4);
}

void kset_color_foreground(uint8_t color)
{
    display_color = (display_color & 0xF0) | color;
}

uint16_t kget_color()
{
    return display_color;
}