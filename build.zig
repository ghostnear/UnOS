const std = @import("std");
const build_x86 = @import("src/arch/x86/build.zig").build;

pub fn build(b: *std.Build) anyerror!void {
    return build_x86(b);
}
