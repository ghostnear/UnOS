#!/bin/sh
set -e
. ./config.sh

for PROJECT in $PROJECTS; do
  (cd $PROJECT && $MAKE clean -j $(nproc))
done

rm -rf sysroot
rm -rf isodir
rm -rf unos.iso
