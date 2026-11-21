#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

services=(
  bluetooth.service
  cups.service
  sshd.service
  sddm.service
)

for service in "${services[@]}"; do
  echo "Enabling ${service}"
  $SUDO systemctl enable "$service"
done

echo
echo "Services enabled. They will start on the next boot (or can be started now)."
read -r -p "Start these services now? [Y/n] " answer
if [[ ! "$answer" =~ ^[Nn]$ ]]; then
  for service in "${services[@]}"; do
    $SUDO systemctl start "$service"
  done
fi

# PipeWire is normally started automatically through the user's systemd session.
