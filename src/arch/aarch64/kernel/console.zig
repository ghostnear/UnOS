const MMIO_BASE: u32 = 0xFE000000;

const MMIO_REGISTERS = enum(u32)
{
    // The offsets for reach register.
    GPIO_BASE = 0xFE000000,

    // Controls actuation of pull up/down to ALL GPIO pins.
    GPPUD = (0xFE000000 + 0x94),

    // Controls actuation of pull up/down for specific GPIO pin.
    GPPUDCLK0 = (0xFE000000 + 0x98),

    // The base address for UART.
    UART0_BASE = (0xFE000000 + 0x1000), // for raspi4 0xFE201000, raspi2 & 3 0x3F201000, and 0x20201000 for raspi1

    // The offsets for reach register for the UART.
    UART0_DR     = (0xFE201000 + 0x00),
    UART0_RSRECR = (0xFE201000 + 0x04),
    UART0_FR     = (0xFE201000 + 0x18),
    UART0_ILPR   = (0xFE201000 + 0x20),
    UART0_IBRD   = (0xFE201000 + 0x24),
    UART0_FBRD   = (0xFE201000 + 0x28),
    UART0_LCRH   = (0xFE201000 + 0x2C),
    UART0_CR     = (0xFE201000 + 0x30),
    UART0_IFLS   = (0xFE201000 + 0x34),
    UART0_IMSC   = (0xFE201000 + 0x38),
    UART0_RIS    = (0xFE201000 + 0x3C),
    UART0_MIS    = (0xFE201000 + 0x40),
    UART0_ICR    = (0xFE201000 + 0x44),
    UART0_DMACR  = (0xFE201000 + 0x48),
    UART0_ITCR   = (0xFE201000 + 0x80),
    UART0_ITIP   = (0xFE201000 + 0x84),
    UART0_ITOP   = (0xFE201000 + 0x88),
    UART0_TDR    = (0xFE201000 + 0x8C),

    // The offsets for Mailbox registers
    MBOX_BASE    = 0xB880,              // Also called MBOX_READ
    MBOX_STATUS  = (0xB880 + 0x18),
    MBOX_WRITE   = (0xB880 + 0x20)
};

const mbox align(16) = [9]u32{
    9*4, 0, 0x38002, 12, 8, 2, 3000000, 0 , 0
};

var buffer = @as([*]volatile u32, @ptrFromInt(MMIO_BASE));

fn uart_init() void {
	// Disable UART0.
	mmio_write(MMIO_REGISTERS.UART0_CR, 0x00000000);
	// Setup the GPIO pin 14 && 15.

	// Disable pull up/down for all GPIO pins & delay for 150 cycles.
	mmio_write(MMIO_REGISTERS.GPPUD, 0x00000000);
	delay(150);

	// Disable pull up/down for pin 14,15 & delay for 150 cycles.
	mmio_write(MMIO_REGISTERS.GPPUDCLK0, (1 << 14) | (1 << 15));
	delay(150);

	// Write 0 to GPPUDCLK0 to make it take effect.
	mmio_write(MMIO_REGISTERS.GPPUDCLK0, 0x00000000);

	// Clear pending interrupts.
	mmio_write(MMIO_REGISTERS.UART0_ICR, 0x7FF);

	// Set integer & fractional part of baud rate.
	// Divider = UART_CLOCK/(16 * Baud)
	// Fraction part register = (Fractional part * 64) + 0.5
	// Baud = 115200.

    // UART_CLOCK = 30000000;
    const r: u32 = (mbox[0] & 0xFFFFFFF0) | 8;
    // wait until we can talk to the VC
    while ((mmio_read(MMIO_REGISTERS.MBOX_STATUS) & 0x80000000) != 0) { }
    // send our message to property channel and wait for the response
    mmio_write(MMIO_REGISTERS.MBOX_WRITE, r);
    while ( ((mmio_read(MMIO_REGISTERS.MBOX_STATUS) & 0x40000000) != 0) or (mmio_read(MMIO_REGISTERS.MBOX_BASE) != r )) { }

	// Divider = 3000000 / (16 * 115200) = 1.627 = ~1.
	mmio_write(MMIO_REGISTERS.UART0_IBRD, 1);
	// Fractional part register = (.627 * 64) + 0.5 = 40.6 = ~40.
	mmio_write(MMIO_REGISTERS.UART0_FBRD, 40);

	// Enable FIFO & 8 bit data transmission (1 stop bit, no parity).
	mmio_write(MMIO_REGISTERS.UART0_LCRH, (1 << 4) | (1 << 5) | (1 << 6));

	// Mask all interrupts.
	mmio_write(MMIO_REGISTERS.UART0_IMSC, (1 << 1) | (1 << 4) | (1 << 5) | (1 << 6) |
	                       (1 << 7) | (1 << 8) | (1 << 9) | (1 << 10));

	// Enable UART0, receive & transfer part of UART.
	mmio_write(MMIO_REGISTERS.UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}

fn mmio_write(reg: MMIO_REGISTERS, data: u32) void {
    buffer[@intFromEnum(reg)] = data;
}

fn mmio_read(reg: MMIO_REGISTERS) u32 {
    return buffer[@intFromEnum(reg)];
}

fn delay(count: u32) void {
    asm volatile(
        \\ __delay__:
        \\      subs %[count], %[count], #1;
        \\      bne __delay__
        :
        : [count] "{x15}" (count)
    );
}

fn uart_putc(c: u8) void {
    while ( (mmio_read(MMIO_REGISTERS.UART0_FR) & (1 << 5)) != 0 ) { }
	mmio_write(MMIO_REGISTERS.UART0_DR, c);
}

pub fn init() void {
    uart_init();
}

pub fn putch(c: u8) void {
    uart_putc(c);
}

pub fn puts(data: []const u8) void {
    for (data) |c|
        putch(c);
}