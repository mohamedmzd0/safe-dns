#!/usr/bin/env bash
# Applies blocklists, custom rules and protection settings via the AdGuard Home API.
# Usage: ./scripts/configure.sh [host:port]   (default: localhost:8080)
set -euo pipefail
cd "$(dirname "$0")/.."

HOST="${1:-localhost:8080}"
read -rp "AdGuard admin username: " USER
read -rsp "AdGuard admin password: " PASS; echo
API="http://$HOST/control"
call() { curl -fsS -u "$USER:$PASS" -H 'Content-Type: application/json' -X "$1" "$API$2" ${3:+-d "$3"}; }

echo "Adding blocklists..."
grep -v '^#' filters/blocklists.txt | grep -v '^\s*$' | while IFS='|' read -r name url; do
  call POST /filtering/add_url "{\"name\":\"$name\",\"url\":\"$url\",\"whitelist\":false}" \
    && echo "  + $name" || echo "  ~ $name (already added or failed)"
done

echo "Applying custom rules..."
RULES=$(grep -v '^\s*$' filters/custom-rules.txt | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\"%s\"", (NR>1?",":""), $0}')
call POST /filtering/set_rules "{\"rules\":[${RULES}]}"

echo "Enabling malware/phishing protection, parental control, safe search..."
call POST /safebrowsing/enable
call POST /parental/enable
call PUT /safesearch/settings '{"enabled":true,"bing":true,"duckduckgo":true,"google":true,"pixabay":true,"yandex":true,"youtube":true}'

echo "Refreshing filters..."
call POST /filtering/refresh '{"whitelist":false}' >/dev/null || true

echo "Done. Point your router's DNS (or device DNS) to this server's IP."
