const Setup = @import("setup.zig");
const Console = @import("console.zig");
const MultiBoot = @import("arch/multiboot.zig");

export var multiboot align(4) linksection(".multiboot") =
    MultiBoot.Header{};

export fn _start() callconv(.Naked) noreturn  {
    Setup.init();       // This initializes platform specific stuff and calls kmain.
    while (true) {}
}

export fn kmain() void {
    Console.init();
    Console.puts("Welcome to UnOS!");
}
