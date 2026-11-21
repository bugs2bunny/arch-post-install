# Arch Setup

A local, modular post-installation setup for an Arch Linux workstation.

## What it installs

- Hyprland, Waybar, Rofi (Wayland), Kitty, Thunar and SDDM
- Hyprshot, Hyprpaper, Hyprlock and Hypridle
- Google Chrome, Vim and Zsh
- Mononoki Nerd Font
- OpenSSH, CUPS and Bluetooth
- PipeWire audio stack and common Wayland utilities
- Development tools listed in `packages/development.txt`

## Requirements

- A working Arch Linux installation with network access
- A normal user account with `sudo` privileges
- Network Manager installed and running online.
- An existing graphical boot/display setup is not required

## Run

From the project directory:

```bash
chmod +x install.sh scripts/*.sh
./install.sh
```

Do not run the installer as root.

## Before first Hyprland login

1. Review the WALLPAPER variable in scripts/configs.sh.
2. Review the keyboard layout in `configs/hypr/hyprland.lua` (`pt` by default).
3. Review the service choices in `scripts/services.sh`.
4. Reboot, select Hyprland in SDDM, and log in.

## Configuration backups

Existing files replaced by the installer are copied to:

```text
~/.config/arch-setup-backups/
```

The installer does not delete existing files.

## Add packages

Add one package name per line to the appropriate file in `packages/`.
Official repository packages belong in `base.txt` or `development.txt`.
AUR packages belong in `aur.txt`.

## Notes

- This is a starter configuration, not a universal hardware profile.
- `hyprpaper.conf` intentionally contains no wallpaper path until you choose an image.
- The SDDM service is enabled, but no custom SDDM theme is selected.
- The installer enables SSH, CUPS, Bluetooth and NetworkManager. Review firewall and SSH access settings before exposing services to untrusted networks.
