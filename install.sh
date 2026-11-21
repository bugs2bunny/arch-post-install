#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/state/arch-setup"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

trap 'echo; echo "[ERROR] Installation failed at line ${LINENO}. Log: ${LOG_FILE}" >&2' ERR

if [[ "${EUID}" -eq 0 ]]; then
  echo "Do not run this script as root. Run it as your normal user."
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  echo "This installer is intended for Arch Linux."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required. Install and configure sudo first."
  exit 1
fi

# Verify NetworkManager is installed and running
if ! command -v nmcli &>/dev/null; then
    echo "ERROR: NetworkManager is not installed."
    exit 1
fi

if ! systemctl is-active --quiet NetworkManager; then
    echo "ERROR: NetworkManager is not running."
    exit 1
fi

if ! nmcli -t -f STATE general | grep -q '^connected$'; then
    echo "ERROR: No active network connection."
    exit 1
fi

echo "=== Arch Linux workstation setup ==="
echo "Log: ${LOG_FILE}"
echo
read -r -p "Continue with package installation and configuration? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || exit 0

sudo -v
sudo pacman -Syu --needed --noconfirm

echo
echo "=== Installing official repository packages ==="
mapfile -t packages < <(
  grep -hEv '^[[:space:]]*(#|$)' \
    "$SCRIPT_DIR"/packages/base.txt \
    "$SCRIPT_DIR"/packages/development.txt | sort -u
)

if ((${#packages[@]})); then
  sudo pacman -S --needed --noconfirm "${packages[@]}"
fi

echo
echo "=== Installing / updating yay ==="
if ! command -v yay >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"; echo; echo "[ERROR] Installation failed at line ${LINENO}. Log: ${LOG_FILE}" >&2' ERR
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
  )
  rm -rf "$tmpdir"
else
  yay -Syu --devel --needed --noconfirm
fi

echo
echo "=== Installing AUR packages ==="
mapfile -t aur_packages < <(
  grep -hEv '^[[:space:]]*(#|$)' \
    "$SCRIPT_DIR"/packages/aur.txt | sort -u
)
if ((${#aur_packages[@]})); then
  yay -S --needed --noconfirm "${aur_packages[@]}"
fi

echo
echo "=== Applying user configuration ==="
"$SCRIPT_DIR/scripts/configs.sh" "$SCRIPT_DIR"

echo
echo "=== Enabling system services ==="
"$SCRIPT_DIR/scripts/services.sh"

echo
echo "Installation finished."
echo "A log was saved to: ${LOG_FILE}"
echo "Log out and select Hyprland in SDDM before starting the new session."
echo "Review the WALLPAPER variable in scripts/configs.sh."
