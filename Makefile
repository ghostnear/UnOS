.PHONY: build clean
.DEFAULT_GOAL := build

GDB = .\i686-elf-tools-windows\bin\i686-elf-gdb.exe

run:
	@qemu-system-i386 -drive file=bin/UnOS.bin,format=raw,index=0,media=disk -boot c

debug:
	@qemu-system-i386 -s -drive file=bin/UnOS.bin,format=raw,index=0,media=disk &
		@${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel/build/kernel.elf"

# CompileDB from https://github.com/fcying/compiledb-go works best
build:
	@make -C boot/ build --no-print-directory
	@make -C boot/ build --no-print-directory -Bnw > boot/build/command-log
	@make -C kernel/ build --no-print-directory
	@make -C kernel/ build --no-print-directory -Bnw > kernel/build/command-log
	@cmake -E make_directory bin
	@cmake -E cat boot/build/command-log kernel/build/command-log > bin/command-log
	@cmake -E cat boot/build/boot.bin kernel/build/kernel.bin > bin/UnOS.bin
	@echo [BUILD]: Built OS image under bin/UnOS.bin
	@cd kernel & (cmake -E cat ../bin/command-log | compiledb -o ../compile_commands.json)
	@echo [BUILD]: Created compile_commands.json

clean:
	@cmake -E remove_directory bin
	@cmake -E remove_directory build
	@cmake -E remove compile_commands.json
	@make -C boot/ clean --no-print-directory
	@make -C kernel/ clean --no-print-directory
	@echo [CLEAN]: Finished cleaning.