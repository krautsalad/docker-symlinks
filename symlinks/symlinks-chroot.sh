#!/bin/sh
mkdir -p /host/tmp
rm -rf /host/tmp/symlinks
cp /usr/local/bin/symlinks /host/tmp/symlinks
chroot /host /tmp/symlinks -cdors /
rm -rf /host/tmp/symlinks
