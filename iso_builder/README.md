Minimal ISO builder (Docker)

Files created:
- Dockerfile — Debian-based builder using grub-mkrescue/xorriso
- build_iso.sh — builds a bootable ISO from ./iso/ tree
- iso/boot/... — placeholder kernel/initrd, grub.cfg and `installer.sh`

How it works (recommended flow)

Windows-native builder (new):
- Run `.\iso_builder\build_iso_windows.ps1` from an elevated PowerShell session.
- You may pass a kernel path explicitly: `.\build_iso_windows.ps1 -KernelPath "C:\path\to\vmlinuz"`.
- If no kernel is found and no `-KernelPath` is provided, the script attempts to download a TinyCore vmlinuz fallback (network required).
- The script builds a BusyBox-based initramfs (via `mkinitramfs.py`) and assembles a bootable ISO.

Docker builder (unchanged):
1. Place your kernel + initrd into `iso_builder/iso/boot/` as `vmlinuz` and `initrd.img` (or let the Docker builder fetch a kernel).
2. Edit `iso/boot/grub/grub.cfg` if you want custom kernel cmdline.
3. Build the Docker image and run it to produce `mini-installer.iso`:
   - docker build -t mini-iso-builder iso_builder
   - docker run --rm -v "%CD%/iso_builder/out:/out" mini-iso-builder
   - Result: `iso_builder/out/mini-installer.iso` on the host (UEFI + BIOS bootable)

Notes / limitations
- The Windows builder will attempt to use `oscdimg.exe` (Windows ADK) to create the ISO. If oscdimg is not present the script will attempt a Python/pycdlib fallback.
- The installer is intentionally minimal (file copy + partitioning). For fully unattended, enable `grub-install` during the install step or run it manually in the VM once files are copied.
- If you want me to include `grub-install` into the installer step and perform full bootloader installation automatically, say so and I'll add it.
