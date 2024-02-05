#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include <kernel/tty.h>

#include "vga.h"
#include "port.h"

static uint16_t* const VGA_MEMORY = (uint16_t*) 0xB8000;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void terminal_clear(void)
{
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_initialize(void)
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = VGA_MEMORY;
	terminal_clear();
}

void terminal_setcolor(uint8_t color)
{
	terminal_color = color;
}

void terminal_putentryat(unsigned char c, uint8_t color, size_t x, size_t y)
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

// Gets the offset depending on the row and column.
inline uint32_t get_offset(int32_t col, int32_t row)
{
    return (row * VGA_WIDTH + col);
}

void terminal_putchar(char c)
{
	if(c == '\n')
	{
		terminal_column = 0;
		terminal_row++;
	}
	else
	{
		unsigned char uc = c;
		terminal_putentryat(uc, terminal_color, terminal_column, terminal_row);

		if(++terminal_column == VGA_WIDTH)
		{
			terminal_column = 0;
			if(++terminal_row == VGA_HEIGHT)
					terminal_row = 0;
		}
	}

	// Update the ports.
	uint32_t offset = get_offset(terminal_column, terminal_row);
 	port_write_byte(PORT_SCREEN_CTRL, 14);
    port_write_byte(PORT_SCREEN_DATA, (uint8_t)(offset >> 8));
    port_write_byte(PORT_SCREEN_CTRL, 15);
    port_write_byte(PORT_SCREEN_DATA, (uint8_t)(offset & 0xFF));
}

void terminal_write(const char* data, size_t size)
{
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

void terminal_writestring(const char* data)
{
	terminal_write(data, strlen(data));
}