#!/bin/bash
set -euo pipefail

# Enhanced ISO build script — will auto-provide a kernel + BusyBox initramfs
# and emit the final ISO to the host-mounted /out directory when available.
#
# Behavior:
# - If iso/boot/vmlinuz is missing, the script will install a kernel package
#   inside the container and copy a vmlinuz into the iso tree.
# - If iso/boot/initrd.img is missing, the script will build a tiny initramfs
#   (BusyBox + /init) that runs /boot/installer.sh from the live medium.
# - Final ISO is written to /out/mini-installer.iso if /out is mounted by Docker,
#   otherwise written to /work/mini-installer.iso inside the container.

WORKDIR=/work
ISO_DIR=${WORKDIR}/iso
OUT_DIR=${WORKDIR}/out
OUT=${OUT_DIR:-${WORKDIR}}/mini-installer.iso

mkdir -p "$ISO_DIR/boot/grub"
mkdir -p "$OUT_DIR" || true

if [ ! -f "$ISO_DIR/boot/grub/grub.cfg" ]; then
  echo "ERROR: please provide iso/boot/grub/grub.cfg (simple example included)."
  ls -R "$ISO_DIR" || true
  exit 1
fi

# Provide kernel if missing (uses distribution kernel inside container)
if [ ! -f "$ISO_DIR/boot/vmlinuz" ]; then
  echo "No vmlinuz found in iso/boot — installing kernel inside container and copying a vmlinuz..."
  apt-get update
  apt-get install -y --no-install-recommends linux-image-amd64 busybox-static cpio
  KIMG=$(ls /boot/vmlinuz-* 2>/dev/null | head -n1 || true)
  if [ -z "$KIMG" ]; then
    echo "ERROR: no kernel image found in container /boot"
    exit 1
  fi
  cp "$KIMG" "$ISO_DIR/boot/vmlinuz"
  echo "Copied kernel: $KIMG"
fi

# Build minimal BusyBox initramfs if initrd missing
if [ ! -f "$ISO_DIR/boot/initrd.img" ]; then
  echo "No initrd found — building minimal BusyBox initramfs..."
  TMPDIR=$(mktemp -d)
  mkdir -p "$TMPDIR"/bin "$TMPDIR"/sbin "$TMPDIR"/etc "$TMPDIR"/proc "$TMPDIR"/sys "$TMPDIR"/dev
  # Copy static busybox
  BUSY=$(which busybox || true)
  if [ -z "$BUSY" ]; then
    cp /bin/busybox "$TMPDIR/bin/busybox" || true
  else
    cp "$BUSY" "$TMPDIR/bin/busybox"
  fi
  chmod +x "$TMPDIR/bin/busybox"
  # Create symlinks
  for app in sh mount umount mkdir echo cat sleep; do
    ln -s /bin/busybox "$TMPDIR/bin/$app" || true
  done
  # init script: mount /dev, /proc and run installer if present
  cat > "$TMPDIR/init" <<'EOF'
#!/bin/sh
mount -t proc proc /proc || true
mount -t sysfs sys /sys || true
mount -t devtmpfs devtmpfs /dev || true
# Try to find installer and run it
if [ -x /boot/installer.sh ]; then
  echo "Running installer from live medium..."
  /bin/sh /boot/installer.sh
else
  echo "No installer found in /boot; dropping to shell"
  /bin/sh
fi
EOF
  chmod +x "$TMPDIR/init"
  (cd "$TMPDIR" && find . | cpio -o -H newc 2>/dev/null) | gzip -9 > "$ISO_DIR/boot/initrd.img"
  rm -rf "$TMPDIR"
  echo "Built initrd: $ISO_DIR/boot/initrd.img"
fi

# Ensure EFI boot files exist for UEFI boot (GRUB will generate fallback if needed)
mkdir -p "$ISO_DIR/EFI/BOOT"
if [ ! -f "$ISO_DIR/EFI/BOOT/BOOTX64.EFI" ]; then
  echo "Creating fallback EFI/BOOT/BOOTX64.EFI using grub-install shim (if available)..."
  # Try to copy grub EFI binary from system (best-effort)
  if [ -f /usr/lib/grub/x86_64-efi/core.efi ]; then
    cp /usr/lib/grub/x86_64-efi/core.efi "$ISO_DIR/EFI/BOOT/BOOTX64.EFI" || true
  fi
fi

# Build ISO image (supports BIOS + UEFI via grub-mkrescue)
OUT_FILE="/out/mini-installer.iso"
mkdir -p /out
if command -v grub-mkrescue >/dev/null 2>&1; then
  echo "Running grub-mkrescue to build $OUT_FILE"
  grub-mkrescue -o "$OUT_FILE" "$ISO_DIR" 2>/dev/null || {
    echo "grub-mkrescue failed — trying xorriso fallback"
    xorriso -as mkisofs -R -J -b boot/grub/i386-pc/core.img -no-emul-boot -boot-load-size 4 -boot-info-table -o "$OUT_FILE" "$ISO_DIR"
  }
else
  echo "grub-mkrescue not available in container — cannot create bootable ISO"
  exit 1
fi

echo "ISO created: $OUT_FILE"
ls -lh "$OUT_FILE" || true
cp "$OUT_FILE" "$WORKDIR/mini-installer.iso" 2>/dev/null || true
echo "Also copied ISO to $WORKDIR/mini-installer.iso (if /out not mounted)."
