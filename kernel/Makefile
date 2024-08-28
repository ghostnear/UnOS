.PHONY: build clean

C_SOURCES := $(wildcard src/*.c src/drivers/*.c libc/src/*.c)
C_HEADERS := $(wildcard inc/*.h inc/drivers/*.h libc/inc/*.h)
C_OBJ := $(patsubst libc/src/%.c,build/libc/src/%.o,$(patsubst src/%.c,build/src/%.o,$(C_SOURCES)))
C_FLAGS = -g -ffreestanding -nostdlib -fno-builtin -fno-stack-protector -nostartfiles -Wall -Wextra -Werror -fno-exceptions -m32 -O2

NASM = ..\nasm-2.16.03\nasm.exe
GCC = ..\i686-elf-tools-windows\bin\i686-elf-gcc.exe
LD  = ..\i686-elf-tools-windows\bin\i686-elf-ld.exe

ASM_SOURCES := $(wildcard src/*.asm)
ASM_OBJ := $(patsubst src/%.asm,build/src/%.o,$(ASM_SOURCES))

build: $(C_OBJ) build/kernel_entry.o
	@${LD} -o build/kernel.bin -Ttext 0x1000 $(C_OBJ) build/kernel_entry.o --oformat binary
	@${LD} -o build/kernel.elf -Ttext 0x1000 $(C_OBJ) build/kernel_entry.o
	@echo [BUILD]: Built kernel!

build/libc/src/%.o: libc/src/%.c $(C_HEADERS)
	@cmake -E make_directory $(dir $@)
	@${GCC} -ffreestanding ${C_FLAGS} -c $< -o $@ -I libc/inc/ -Wall

build/src/%.o: src/%.c $(C_HEADERS)
	@cmake -E make_directory $(dir $@)
	@${GCC} -ffreestanding ${C_FLAGS} -c $< -o $@ -I inc/ -I libc/inc/ -Wall

build/src/%.o: src/%.asm
	@cmake -E make_directory $(dir $@)
	@${NASM} $< -f elf -o $@

build/kernel_entry.o: src/kernel_entry.asm
	@${NASM} $< -f elf -o $@

clean:
	@cmake -E remove_directory build/