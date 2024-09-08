const cpu = @import("cpu_data");

pub fn init() void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/VGA.zig").init();
    }
}

pub fn puts(data: []const u8) void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/VGA.zig").puts(data);
    }
}

pub fn putch(data: []const u8) void {
    if(cpu.arch == .x86)
    {
        @import("../arch/x86/kernel/VGA.zig").putch(data);
    }
}