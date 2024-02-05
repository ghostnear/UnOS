#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/unos.kernel isodir/boot/unos.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "UnOS" {
	multiboot /boot/unos.kernel
}
EOF
grub-mkrescue -o unos.iso isodir
