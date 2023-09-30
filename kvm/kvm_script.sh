#! /usr/bin/bash

img="archlinux"
iso="archlinux-2023.08.01-x86_64.iso"

if [ "$1" = "image" ]; then 
  qemu-img create -f qcow2 $img.img 20G
elif [ "$1" = "iso" ]; then
   qemu-system-x86_64 -enable-kvm -cdrom $iso -boot menu=on -drive file=archlinux.img -m 4G -cpu host -vga virtio -display sdl,gl=on
elif [ "$1" = "boot" ]; then
   qemu-system-x86_64 -enable-kvm -boot menu=on -drive file=archlinux.img -m 4G -cpu host -vga virtio -display sdl,gl=on
else
  echo "Wrong argument. Try 'iso', 'boot', 'image'"
fi
