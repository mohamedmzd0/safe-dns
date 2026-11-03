# 🛡️ Safe DNS

A self-hosted DNS filter that blocks **ads, trackers, malware, phishing, gambling and adult websites** for every device on your network. It runs [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) in Docker, with curated blocklists and one-command setup.

## Features
- 🚫 Blocks ads and trackers (apps, browsers, smart TVs)
- 🦠 Malware, phishing and scam protection
- 🔞 Adult content and gambling blocking, plus enforced Safe Search (Google, YouTube, Bing)
- 🔒 Stops DNS-over-HTTPS bypass
- 📊 Web dashboard with query logs and per-device rules

## Requirements
- An always-on machine: PC, Raspberry Pi, home server or VPS
- [Docker](https://docs.docker.com/get-docker/) with Docker Compose

## Quick start
```bash
git clone https://github.com/mohamedmzd0/safe-dns.git
cd safe-dns
chmod +x scripts/*.sh
./scripts/install.sh
```
1. Open `http://<server-ip>:3000` and complete the wizard. Keep the web interface on port **80**; it maps to `8080` on the host.
2. Apply the blocklists and protection settings:
   ```bash
   ./scripts/configure.sh            # or ./scripts/configure.sh <server-ip>:8080
   ```
3. Point your devices at the server:
   - **Whole network:** set the router's DHCP DNS to `<server-ip>`
   - **Single device:** set its DNS manually to `<server-ip>`

Dashboard: `http://<server-ip>:8080`

## Customize
| File | Purpose |
|---|---|
| `filters/blocklists.txt` | Blocklist subscriptions (`name\|url`) |
| `filters/custom-rules.txt` | Your own block/allow rules |

Re-run `./scripts/configure.sh` after editing these files.

Rule syntax:
```
||example.com^        block domain + subdomains
@@||example.com^      allow (whitelist)
```

## No server? Use a public filtering DNS
| Provider | Blocks | Android Private DNS | IPv4 |
|---|---|---|---|
| AdGuard Family | ads + adult + safe search | `family.adguard-dns.com` | `94.140.14.15`, `94.140.15.16` |
| AdGuard Default | ads + trackers | `dns.adguard-dns.com` | `94.140.14.14`, `94.140.15.15` |
| Cloudflare Families | malware + adult | `family.cloudflare-dns.com` | `1.1.1.3`, `1.0.0.3` |

## Troubleshooting
- **Port 53 already in use (Linux):** `install.sh` disables the systemd-resolved stub listener automatically.
- **Port 53 in use on Windows:** stop "Internet Connection Sharing" or run the stack on Linux or WSL2.
- **A site you need is blocked:** check *Query Log* in the dashboard, click **Unblock**, or add `@@||site.com^` to custom rules.
- **Android Private DNS / DNS-over-TLS:** requires a domain and a TLS certificate (*Settings → Encryption* in AdGuard Home).

## Credits
- [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) (GPL-3.0)
- Blocklists: [OISD](https://oisd.nl), [HaGeZi](https://github.com/hagezi/dns-blocklists)

## License
MIT. See [LICENSE](LICENSE).
