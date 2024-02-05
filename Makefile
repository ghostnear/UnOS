.PHONY: build clean

run:
	@qemu-system-i386 -drive file=bin/os-image.bin,format=raw,index=0,media=disk -boot c

debug:
	@qemu-system-i386 -s -drive file=bin/os-image.bin,format=raw,index=0,media=disk &
		@i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file kernel/build/kernel.elf"  -ex "symbol-file libc/build/libc.elf"

build_internal:
	@make -C boot/ build --no-print-directory
	@make -C kernel/ build --no-print-directory
	@mkdir -p bin/
	@mkdir -p build/
	@cp boot/build/boot.bin build/boot.bin
	@cat boot/build/boot.bin kernel/build/kernel.bin > bin/os-image.bin

build:
	@bear -- make build_internal --no-print-directory

clean:
	@rm -r bin/
	@rm -r build/
	@rm compile_commands.json
	@make -C boot/ clean --no-print-directory
	@make -C kernel/ clean --no-print-directory
	@echo "Finished cleaning."
