#!/usr/bin/env python3
"""Create a minimal initramfs cpio.gz containing BusyBox and a simple /init.

Usage:
  python mkinitramfs.py -o iso/boot/initrd.img -b busybox-linux -i iso/boot/installer.sh

- Expects a Linux x86_64 static busybox binary file path or will attempt to download one.
- Creates /bin/busybox plus symlinks and a simple /init that runs /boot/installer.sh if present.
"""
import argparse
import os
import stat
import gzip
import io
import shutil
import sys
import urllib.request

BUSY_DOWNLOAD = 'https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64'

CPIO_HEADER = b''


def build_initramfs(out_path, busybox_path=None, installer_path=None):
    work = os.path.abspath('tmp_initram')
    if os.path.exists(work):
        shutil.rmtree(work)
    os.makedirs(work)
    bin_dir = os.path.join(work, 'bin')
    os.makedirs(bin_dir)

    # busybox
    if busybox_path and os.path.exists(busybox_path):
        bb_dst = os.path.join(bin_dir, 'busybox')
        shutil.copyfile(busybox_path, bb_dst)
    else:
        # download a small static busybox binary (best-effort)
        bb_dst = os.path.join(bin_dir, 'busybox')
        print('Downloading BusyBox (x86_64) ...')
        urllib.request.urlretrieve(BUSY_DOWNLOAD, bb_dst)
    os.chmod(bb_dst, 0o755)

    # create symlinks (sh, mount, sleep, echo)
    for name in ('sh','mount','umount','mkdir','echo','cat','sleep'):
        link = os.path.join(bin_dir, name)
        try:
            os.symlink('busybox', link)
        except Exception:
            # on Windows host creating symlinks in the work tree may fail; create tiny wrapper instead
            with open(link, 'w') as f:
                f.write('#!/bin/sh\nexec /bin/busybox ' + name + ' "$@"\n')
            os.chmod(link, 0o755)

    # /init
    init_path = os.path.join(work, 'init')
    with open(init_path, 'w') as f:
        f.write('#!/bin/sh\n')
        f.write('mount -t proc proc /proc || true\n')
        f.write('mount -t sysfs sys /sys || true\n')
        f.write('mount -t devtmpfs devtmpfs /dev || true\n')
        f.write('echo "initramfs: looking for /boot/installer.sh"\n')
        f.write('if [ -x /boot/installer.sh ]; then\n')
        f.write('  /bin/sh /boot/installer.sh\n')
        f.write('else\n')
        f.write('  echo "No installer found; dropping to shell"\n')
        f.write('  /bin/sh\n')
        f.write('fi\n')
    os.chmod(init_path, 0o755)

    # include installer script into /boot if provided
    if installer_path and os.path.exists(installer_path):
        boot_dir = os.path.join(work, 'boot')
        os.makedirs(boot_dir, exist_ok=True)
        shutil.copyfile(installer_path, os.path.join(boot_dir, 'installer.sh'))
        os.chmod(os.path.join(boot_dir, 'installer.sh'), 0o755)

    # create cpio newc archive
    def add_file(fp, name, mode=0o100644):
        st = os.lstat(fp)
        with open(fp, 'rb') as f:
            data = f.read()
        header = '070701'.encode('ascii')
        def tohex(x, width):
            return ('%0*x' % (width, x)).encode('ascii')
        fields = [
            tohex(0,8), # ino
            tohex(mode | (0o100000 if stat.S_ISREG(st.st_mode) else 0),8),
            tohex(0,8), # uid
            tohex(0,8), # gid
            tohex(int(st.st_size),8),
            tohex(int(st.st_mtime),8),
            tohex(0,8), # devmajor
            tohex(0,8), # devminor
            tohex(0,8), # rdevmajor
            tohex(0,8), # rdevminor
            tohex(len(name)+1,8),
            tohex(0,8),
        ]
        header = b'070701' + b''.join(fields)
        return header + name.encode('utf-8') + b'\x00' + data

    entries = b''
    for root, dirs, files in os.walk(work):
        for fname in files:
            full = os.path.join(root, fname)
            arc = os.path.relpath(full, work).replace('\\', '/')
            entries += add_file(full, arc, os.stat(full).st_mode)
            # pad to 4
            while len(entries) % 4:
                entries += b'\x00'
    # TRAILER
    entries += b'070701' + b'0'*110 + b'trailer\x00'
    while len(entries) % 4:
        entries += b'\x00'

    # write gzipped cpio
    with gzip.open(out_path, 'wb') as gz:
        gz.write(entries)
    print('Wrote initramfs to', out_path)

    shutil.rmtree(work)


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('-o','--out', required=True, help='output initrd path (.img)')
    p.add_argument('-b','--busybox', help='path to Linux busybox executable (optional)')
    p.add_argument('-i','--installer', help='path to installer.sh to include into /boot')
    args = p.parse_args()
    build_initramfs(args.out, args.busybox, args.installer)
