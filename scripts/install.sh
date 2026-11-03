#!/usr/bin/env bash
# Safe DNS installer - starts AdGuard Home in Docker.
# Usage: ./scripts/install.sh
set -euo pipefail
cd "$(dirname "$0")/.."

command -v docker >/dev/null || { echo "Docker is required: https://docs.docker.com/get-docker/"; exit 1; }

# Free port 53 on Linux systems running systemd-resolved
if [[ "$(uname)" == "Linux" ]] && systemctl is-active --quiet systemd-resolved 2>/dev/null; then
  if ss -lunp 2>/dev/null | grep -q '127.0.0.53:53'; then
    echo "Disabling systemd-resolved stub listener to free port 53..."
    sudo sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf
    sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
    sudo systemctl restart systemd-resolved
  fi
fi

docker compose up -d

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
IP=${IP:-<server-ip>}
echo
echo "AdGuard Home is running."
echo "1) Open http://$IP:3000 and finish the setup wizard"
echo "   (set the admin web interface to port 80 - it maps to $IP:8080)"
echo "2) Then run: ./scripts/configure.sh"
