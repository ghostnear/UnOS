const cpu = @import("cpu_data");

pub fn init() void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/console.zig").init();
    }
    if(cpu.arch == .aarch64)
    {
        @import("../arch/aarch64/kernel/console.zig").init();
    }
}

pub fn puts(data: []const u8) void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/console.zig").puts(data);
    }
    if(cpu.arch == .aarch64)
    {
        @import("../arch/aarch64/kernel/console.zig").puts(data);
    }
}

pub fn putch(data: []const u8) void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/console.zig").putch(data);
    }
    if(cpu.arch == .aarch64)
    {
        @import("../arch/aarch64/kernel/console.zig").putch(data);
    }
}