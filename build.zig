const std = @import("std");

pub fn build(b: *std.Build) anyerror!void {
    const platform = b.option([]const u8, "projectTarget", "Build target type") orelse "none";
    if (std.mem.eql(u8, platform, "x86")) {
        return @import("src/arch/x86/build.zig").build(b);
    }
    if (std.mem.eql(u8, platform, "rpi4b")) {
        return @import("src/arch/aarch64/build.zig").build(b);
    }
    return error.UnsupportedPlatform;
}
