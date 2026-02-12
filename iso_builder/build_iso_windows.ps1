<#
Windows-native ISO builder (minimal BusyBox initramfs + kernel fallback)
Usage: Open PowerShell as Administrator in the workspace root and run:
  .\iso_builder\build_iso_windows.ps1

What it does:
 - Searches for an existing Linux kernel (vmlinuz / bzImage) under the workspace.
 - If no kernel is found, downloads a small Tiny Core Linux vmlinuz as a bootable kernel.
 - Downloads a prebuilt Linux BusyBox binary and builds a tiny initramfs (via Python helper).
 - Creates a bootable ISO containing /boot/{vmlinuz,initrd.img} and GRUB config.
 - Uses `oscdimg.exe` (Windows ADK) when available, otherwise attempts Python + pycdlib.

Limitations:
 - You still need UEFI firmware in VMware to boot the ISO (set VM firmware to UEFI).
 - If neither oscdimg nor Python+pycdlib are available, the script will stop and explain next steps.
#>

param(
    [string]$KernelPath = ''
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $scriptDir\..\

$isoWork = Join-Path $scriptDir "iso\boot"
New-Item -ItemType Directory -Force -Path $isoWork | Out-Null

# 1) find kernel in workspace or use provided KernelPath
$kernelTarget = Join-Path $isoWork "vmlinuz"
if ($KernelPath -and (Test-Path $KernelPath)) {
    Write-Host "Using kernel provided by -KernelPath: $KernelPath"
    try {
        $srcFull = (Get-Item $KernelPath).FullName
        $destFull = (Resolve-Path -Path $kernelTarget -ErrorAction SilentlyContinue).ProviderPath
    } catch {
        $destFull = $null
    }
    if ($destFull -and ($srcFull -ieq $destFull)) {
        Write-Host "Kernel already at target path; skipping copy."
    } else {
        Copy-Item $KernelPath -Destination $kernelTarget -Force
    }
} else {
    $kernelPaths = Get-ChildItem -Path . -Recurse -Include vmlinuz*,bzImage* -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($kernelPaths) {
        $fullSrc = (Get-Item $kernelPaths.FullName).FullName
        $fullDest = (New-Item -ItemType File -Path $kernelTarget -Force -ErrorAction SilentlyContinue).FullName
        if ($fullSrc -ne $fullDest) {
            Write-Host "Using existing kernel found in workspace: $fullSrc"
            Copy-Item $fullSrc -Destination $kernelTarget -Force
        } else {
            Write-Host "Kernel is already in the target location: $fullSrc"
        }
    }
    else {
        Write-Host "No kernel found in workspace — attempting to download Tiny Core vmlinuz fallback (small)"
        $tinyUrl = 'http://tinycorelinux.net/11.x/x86_64/release/vmlinuz'
        try {
            Invoke-WebRequest -Uri $tinyUrl -OutFile $kernelTarget -UseBasicParsing -ErrorAction Stop
            Write-Host "Downloaded TinyCore vmlinuz to $kernelTarget"
        } catch {
            Write-Warning "Failed to download fallback kernel from $tinyUrl — please provide a vmlinuz in the workspace or pass -KernelPath and re-run."
            Pop-Location
            exit 1
        }
    }
}

# 2) ensure installer.sh is present in iso/boot (we included a minimal one earlier)
$installerSrc = Join-Path $scriptDir "iso\boot\installer.sh"
if (-not (Test-Path $installerSrc)) {
    Write-Warning "Installer script not found at $installerSrc — the ISO will include the installer only if present."
}

# 3) build initramfs via Python helper
$initrdTarget = Join-Path $isoWork "initrd.img"
$pyHelper = Join-Path $scriptDir "mkinitramfs.py"
if (-not (Test-Path $pyHelper)) {
    Write-Error "Required helper script mkinitramfs.py is missing."
    Pop-Location
    exit 1
}

# Ensure Python is available
$python = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $python) {
    Write-Error "Python not found on PATH. Install Python 3 and retry."
    Pop-Location
    exit 1
}

Write-Host "Building initramfs (BusyBox-based) using Python helper..."
& $python $pyHelper -o $initrdTarget -b "$scriptDir/busybox-linux" -i "$scriptDir/iso/boot/installer.sh"
if ($LASTEXITCODE -ne 0) { Write-Error "mkinitramfs failed"; Pop-Location; exit 1 }
Write-Host "Created initrd: $initrdTarget"

# 4) write grub.cfg (UEFI + BIOS friendly)
$grubCfg = Join-Path $scriptDir "iso\boot\grub\grub.cfg"
New-Item -Force -ItemType Directory -Path (Split-Path $grubCfg) | Out-Null
@'
set timeout=3
set default=0
menuentry "Mini BusyBox installer (interactive)" {
  linux /boot/vmlinuz boot_installer=1 quiet
  initrd /boot/initrd.img
}
'@ | Out-File -Encoding ascii -FilePath $grubCfg -Force

# 5) create ISO
$outIso = Join-Path $scriptDir "out\mini-installer-windows.iso"
New-Item -ItemType Directory -Force -Path (Split-Path $outIso) | Out-Null

# Prefer oscdimg (Windows ADK)
$oscdimg = (Get-Command oscdimg -ErrorAction SilentlyContinue).Source
if ($oscdimg) {
    Write-Host "Using oscdimg to create ISO..."
    # oscdimg expects a bootable folder layout; use -udf option for UEFI compatibility
    & $oscdimg -n -m -o -udf -bootdata:2#p0,e,b"iso\boot\etfsboot.com"#pEF,e,b"iso\EFI\BOOT\BOOTX64.EFI" "iso" $outIso
    if ($LASTEXITCODE -ne 0) { Write-Warning "oscdimg failed" }
    else { Write-Host "ISO created: $outIso"; Pop-Location; exit 0 }
}

# Fallback: Python + pycdlib
Write-Host "oscdimg not found — attempting Python + pycdlib fallback. This will install pycdlib if necessary."
$pyTemp = Join-Path $env:TEMP "build_iso_pycdlib.py"
$pyCode = @'
import sys,subprocess,os
try:
    import pycdlib
except Exception:
    subprocess.check_call([sys.executable,'-m','pip','install','pycdlib'])
    import pycdlib

from pycdlib import PyCdlib
iso = PyCdlib()
iso.new(interchange_level=3)
root='iso'
for dirpath,dirs,files in os.walk(root):
    for f in files:
        full=os.path.join(dirpath,f)
        arc=os.path.relpath(full,root)
        iso.add_file(full, '\\' + arc.replace('/', '\\'))
iso.write('out\\mini-installer-windows.iso')
iso.close()
print('PYCDLIB ISO written to out\\mini-installer-windows.iso')
'@
Set-Content -Path $pyTemp -Value $pyCode -Encoding ASCII
& $python $pyTemp
$pyExit = $LASTEXITCODE
Remove-Item $pyTemp -ErrorAction SilentlyContinue

if (Test-Path $outIso) { Write-Host "ISO created: $outIso" } else { Write-Warning "ISO creation failed — please install Windows ADK (oscdimg) or ensure Python/pycdlib is usable." }
Pop-Location
