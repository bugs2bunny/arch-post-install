#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="${1:?Usage: configs.sh /path/to/arch-setup}"
BACKUP_DIR="${HOME}/.config/arch-setup-backups/$(date +%Y%m%d-%H%M%S)"

WALLPAPER="wallpaper.jpg"

backup_and_copy() {
  local source="$1"
  local destination="$2"
  if [[ -e "$destination" ]]; then
    mkdir -p "${BACKUP_DIR}/$(dirname "${destination#"$HOME"/}")"
    cp -a "$destination" "${BACKUP_DIR}/$(dirname "${destination#"$HOME"/}")/"
    echo "Backed up: $destination"
  fi
  mkdir -p "$(dirname "$destination")"
  cp -a "$source" "$destination"
  echo "Installed: $destination"
}

mkdir -p "$HOME/.config"
backup_and_copy "$PROJECT_DIR/configs/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
backup_and_copy "$PROJECT_DIR/configs/waybar/config" "$HOME/.config/waybar/config"
backup_and_copy "$PROJECT_DIR/configs/waybar/style.css" "$HOME/.config/waybar/style.css"
backup_and_copy "$PROJECT_DIR/configs/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
backup_and_copy "$PROJECT_DIR/configs/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
backup_and_copy "$PROJECT_DIR/configs/zsh/.zshrc" "$HOME/.zshrc"

if [[ -f "$HOME/.config/hypr/hyprpaper.conf" ]]; then
    cp -n "$HOME/.config/hypr/hyprpaper.conf" \
          "$HOME/.config/hypr/hyprpaper.conf.bak"
fi

cat > "$HOME/.config/hypr/hyprpaper.conf" <<EOF
wallpaper {
    monitor =
    path = $HOME/Pictures/$WALLPAPER
    fit_mode = cover
}
EOF

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  echo
  echo "To make Zsh your login shell, run:"
  echo "  chsh -s \"$(command -v zsh)\""
fi

if [[ -d "$BACKUP_DIR" ]]; then
  echo
  echo "Previous configurations backed up to: $BACKUP_DIR"
fi
