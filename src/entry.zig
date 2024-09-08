const Setup = @import("kernel/setup.zig");
const Console = @import("kernel/console.zig");

export fn _start() callconv(.Naked) noreturn {
    Setup.init(); // This initializes platform specific stuff and calls kmain.
    while (true) {}
}

export fn kmain() void {
    Console.init();
    Console.puts("Welcome to UnOS!");
}
