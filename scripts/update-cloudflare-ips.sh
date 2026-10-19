#!/usr/bin/env sh
# Regenerates nginx/snippets/cloudflare-realip.conf from Cloudflare's published ranges,
# so $remote_addr (logs, rate limiting) is the visitor's IP, not Cloudflare's.
set -eu
OUT="$(dirname "$0")/../nginx/snippets/cloudflare-realip.conf"
{
  echo "# Generated $(date -u +%F) from cloudflare.com/ips"
  for ip in $(curl -fsS https://www.cloudflare.com/ips-v4) $(curl -fsS https://www.cloudflare.com/ips-v6); do
    echo "set_real_ip_from $ip;"
  done
  echo "real_ip_header CF-Connecting-IP;"
} > "$OUT"
echo "Wrote $OUT - reload with: docker compose exec gateway nginx -s reload"
