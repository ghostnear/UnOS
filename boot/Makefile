.PHONY: build clean

NASM = ..\nasm-2.16.03\nasm.exe

build:
	@cmake -E make_directory build
	@$(NASM) src/boot.asm -f bin -o build/boot.bin
	@echo [BUILD]: Built bootloader!

clean:
	@cmake -E remove_directory build