export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack = stack_bytes[0..];

pub inline fn init() void {
    asm volatile (
        \\ mov %[stk], sp
        \\ B kmain
        :
        : [stk] "{x5}" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack))),
    );
}
