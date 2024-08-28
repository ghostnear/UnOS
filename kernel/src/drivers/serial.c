#include "drivers/serial.h"
#include "drivers/port.h"

/*
 * All the I/O ports are calculated relative to the data port. This is because
 * all serial ports (COM1, COM2, COM3, COM4) have their ports in the same
 * order, but they start at different values.
 */
#define SERIAL_COM1_BASE                0x3F8

#define SERIAL_DATA_PORT(base)          (base)
#define SERIAL_FIFO_COMMAND_PORT(base)  (base + 2)
#define SERIAL_LINE_COMMAND_PORT(base)  (base + 3)
#define SERIAL_MODEM_COMMAND_PORT(base) (base + 4)
#define SERIAL_LINE_STATUS_PORT(base)   (base + 5)

/*
 * Tells the serial port to expect first the highest 8 bits on the data port,
 * then the lowest 8 bits will follow
 */
#define SERIAL_LINE_ENABLE_DLAB         0x80

/*
 *  Sets the speed of the data being sent. The default speed of a serial
 *  port is 115200 bits/s. The argument is a divisor of that number, hence
 *  the resulting speed becomes (115200 / divisor) bits/s.
 */
void serial_configure_baud_rate(uint16_t com, uint16_t divisor)
{
    port_write_byte(SERIAL_LINE_COMMAND_PORT(com),
                SERIAL_LINE_ENABLE_DLAB);
    port_write_byte(SERIAL_DATA_PORT(com),
                (divisor >> 8) & 0x00FF);
    port_write_byte(SERIAL_DATA_PORT(com),
                divisor & 0x00FF);
}

/*
 * Configures the line of the given serial port. The port is set to have a
 * data length of 8 bits, no parity bits, one stop bit and break control disabled.
 */
void serial_configure_line(uint16_t com)
{
    /* Bit:     | 7 | 6 | 5 4 3 | 2 | 1 0 |
     * Content: | d | b | prty  | s | dl  |
     * Value:   | 0 | 0 | 0 0 0 | 0 | 1 1 | = 0x03
     */
    port_write_byte(SERIAL_LINE_COMMAND_PORT(com), 0x03);
}

/* 
 *  Checks whether the transmit FIFO queue is empty or not for the given COM
 *  port.
 */
int serial_is_transmit_fifo_empty(uint32_t com)
{
    uint8_t result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (SERIAL_LINE_STATUS_PORT(com)));
    return (result & 0x20) != 0;
}

void kprint_serial(char * message)
{
    serial_configure_baud_rate(SERIAL_COM1_BASE, 1);
    serial_configure_line(SERIAL_COM1_BASE);
    while(*message)
    {
        while(!serial_is_transmit_fifo_empty(SERIAL_COM1_BASE));
        port_write_byte(SERIAL_DATA_PORT(SERIAL_COM1_BASE),
                *message);
        message++;
    }
}