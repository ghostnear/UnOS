const cpu = @import("cpu_data");

pub inline fn init() void {
    if (cpu.arch == .x86) {
        @import("../arch/x86/kernel/setup.zig").init();
    }

    if (cpu.arch == .aarch64) {
        @import("../arch/aarch64/kernel/setup.zig").init();
    }
}
