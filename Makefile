.PHONEY: all

clean:
	@cmake -E remove_directory .zig-cache
	@cmake -E remove_directory zig-out
	@cmake -E remove_directory src/arch/x86/.zig-cache
	@cmake -E remove_directory src/arch/aarch64/.zig-cache

build86:
	@zig build -DprojectTarget=x86
	@cmake -E make_directory zig-out/iso_root-x86
	@cmake -E copy_directory boot zig-out/iso_root-x86/boot
	@cmake -E copy zig-out/bin/kernel.elf zig-out/iso_root-x86/boot/kernel.elf
	@grub-mkrescue -o zig-out/UnOS-livecd-x86.iso zig-out/iso_root-x86

run86: build86
	@qemu-system-x86_64 -cdrom zig-out/UnOS-livecd-x86.iso -debugcon stdio -vga virtio -m 4G -machine q35,accel=kvm:whpx:tcg -no-reboot -no-shutdown

build4b:
	@zig build -DprojectTarget=rpi4b

run4b: build4b
	@qemu-system-aarch64 -M raspi4b -serial stdio -kernel zig-out/bin/kernel8.img