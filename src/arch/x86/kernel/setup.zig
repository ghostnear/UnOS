export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack = stack_bytes[0..];

pub fn init() callconv(.Inline) void
{
    asm volatile (
        \\ movl %[stk], %esp
        \\ movl %esp, %ebp
        \\ call kmain
        :
        : [stk] "{ecx}" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack)))
    );
}