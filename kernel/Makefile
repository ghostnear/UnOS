.PHONY: build clean

C_SOURCES := $(wildcard src/*.c src/drivers/*.c libc/src/*.c)
C_HEADERS := $(wildcard include/*.h include/drivers/*.h libc/include/*.h)
C_OBJ := $(patsubst libc/src/%.c,build/libc/src/%.o,$(patsubst src/%.c,build/src/%.o,$(C_SOURCES)))
C_FLAGS = -g -ffreestanding -Wall -Wextra -fno-exceptions -m32 -O2

ASM_SOURCES := $(wildcard src/*.asm)
ASM_OBJ := $(patsubst src/%.asm,build/src/%.o,$(ASM_SOURCES))

build: $(C_OBJ) build/kernel_entry.o
	@echo "Building kernel..."
	@i386-elf-ld -o build/kernel.bin -Ttext 0x1000 $(C_OBJ) build/kernel_entry.o --oformat binary
	@i386-elf-ld -o build/kernel.elf -Ttext 0x1000 $(C_OBJ) build/kernel_entry.o

build/libc/src/%.o: src/%.c $(C_HEADERS)
	@mkdir -p $(dir $@)
	@i386-elf-gcc -ffreestanding ${C_FLAGS} -c $< -o $@ -I include/ -Wall

build/src/%.o: src/%.c $(C_HEADERS)
	@mkdir -p $(dir $@)
	@i386-elf-gcc -ffreestanding ${C_FLAGS} -c $< -o $@ -I include/ -I libc/include/ -Wall

build/src/%.o: src/%.asm
	@mkdir -p $(dir $@)
	@nasm $< -f elf -o $@

build/kernel_entry.o: src/kernel_entry.asm
	@nasm $< -f elf -o $@

clean:
	@rm -r build/