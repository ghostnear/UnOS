.PHONEY: all

clean:
	@cmake -E remove_directory zig-cache
	@cmake -E remove_directory src/arch/x86/zig-cache
	@cmake -E remove_directory zig-out

build:
	@zig build
	@cmake -E make_directory zig-out/iso_root
	@cmake -E copy_directory boot zig-out/iso_root/boot
	@cmake -E copy zig-out/bin/kernel.elf zig-out/iso_root/boot/kernel.elf
	@grub-mkrescue -o zig-out/UnOS-livecd.iso zig-out/iso_root

run: build
	@qemu-system-x86_64 -cdrom zig-out/UnOS-livecd.iso -debugcon stdio -vga virtio -m 4G -machine q35,accel=kvm:whpx:tcg -no-reboot -no-shutdown