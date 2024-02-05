.PHONY: build clean

build:
	@echo "Building bootloader..."
	@mkdir -p build/
	@nasm src/boot.asm -f bin -o build/boot.bin

clean:
	@rm -rf build/