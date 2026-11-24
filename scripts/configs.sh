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
backup_and_copy "$PROJECT_DIR/configs/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
backup_and_copy "$PROJECT_DIR/wallpaper.jpg" "$HOME/Pictures/wallpaper.jpg"

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

configure_zsh() {
    local zsh_path

    zsh_path="$(command -v zsh)"

    if [[ -z "$zsh_path" ]]; then
        echo "ERROR: Zsh is not installed."
        return 1
    fi

    mkdir -p "$HOME/.config/zsh"
    backup_and_copy "$PROJECT_DIR/configs/zsh/.zshrc" "$HOME/.zshrc"

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
    fi
}

configure_rofi() {
    local theme_source="$PROJECT_DIR/configs/rofi/themes"
    local theme_destination="$HOME/.local/share/rofi/themes"
    local config_source="$PROJECT_DIR/configs/rofi/"
    local config_destination="$HOME/.config/rofi/"

    mkdir -p "$theme_destination"
    mkdir -p "$config_destination"
    cp -a "$theme_source/." "$theme_destination/"
    cp -a "$config_source/config.rasi" "$config_destination/config.rasi"
}

configure_zsh
configure_rofi

if [[ -d "$BACKUP_DIR" ]]; then
  echo
  echo "Previous configurations backed up to: $BACKUP_DIR"
fi

