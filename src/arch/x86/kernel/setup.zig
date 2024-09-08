const MultiBoot = @import("../../multiboot.zig");

export var multiboot align(4) linksection(".multiboot") =
    MultiBoot.Header{};

export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack = stack_bytes[0..];

pub inline fn init() void {
    asm volatile (
        \\ movl %[stk], %esp
        \\ movl %esp, %ebp
        \\ jmp kmain
        :
        : [stk] "{ecx}" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack))),
    );
}
