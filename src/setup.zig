const cpu = @import("cpu_data");

pub fn init() callconv(.Inline) void
{
    if(cpu.arch == .x86)
    {
        @import("arch/x86/kernel/setup.zig").init();
    }
}