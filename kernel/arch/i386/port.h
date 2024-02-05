#pragma once

#include <stdint.h>

#define PORT_SCREEN_CTRL 0x3D4
#define PORT_SCREEN_DATA 0x3D5

// Read a byte from a specified port.
uint8_t port_read_byte(uint16_t port);

// Write a byte to a specified port.
void port_write_byte(uint16_t port, uint8_t data);

// Read a word from a specified port.
uint16_t port_read_word(uint16_t port);

// Write a word to a specified port.
void port_write_word(uint16_t port, uint16_t data);