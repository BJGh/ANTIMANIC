#!/bin/sh
# Minimal interactive installer (runs from live-initramfs)
# - Asks target disk (default /dev/sda)
# - Partitions (single EFI + root) and copies files from /live to installed FS
# - Installs a simple GRUB config

set -eu

echo "*** Mini interactive installer ***"
read -p "Target disk (e.g. /dev/sda) [default: /dev/sda]: " target
target=${target:-/dev/sda}

echo "Wiping partition table on $target (will erase data). Press Ctrl-C to abort."
sleep 2
parted -s "$target" mklabel gpt || parted -s "$target" mklabel msdos

# Create partitions: EFI + root
parted -s "$target" mkpart ESP fat32 1MiB 513MiB
parted -s "$target" set 1 boot on
parted -s "$target" mkpart primary ext4 513MiB 100%

sleep 1

echo "Formatting partitions..."
mkfs.vfat -F32 "${target}1"
mkfs.ext4 -F "${target}2"

echo "Mounting target and copying files..."
mkdir -p /mnt/target
mount "${target}2" /mnt/target
mkdir -p /mnt/target/boot/grub
mount "${target}1" /mnt/target/boot/efi || true

# Copy live files — assume /live contains /boot
if [ -d /live/boot ]; then
  rsync -a /live/boot/ /mnt/target/boot/
else
  echo "No /live/boot found — please ensure the ISO provides kernel/initrd and /boot contents."
fi

# Create minimal grub.cfg on installed system
cat > /mnt/target/boot/grub/grub.cfg <<'EOF'
set timeout=5
menuentry "Installed system" {
  linux /boot/vmlinuz root=/dev/sda2 rw quiet
  initrd /boot/initrd.img
}
EOF

echo "Installation files copied. You must install a bootloader in the VM (grub-install) or rely on firmware to boot the EFI stub."

umount /mnt/target/boot/efi || true
umount /mnt/target || true

echo "Install complete (files copied). Reboot the VM and select the target disk." 
