#pragma once

#include <stdint.h>

uint8_t port_read_byte(uint16_t);
void port_write_byte(uint16_t, uint8_t);

uint16_t port_read_word(uint16_t);
void port_write_word(uint16_t, uint16_t);