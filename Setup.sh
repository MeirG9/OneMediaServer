#!/bin/bash
set -euo pipefail
set -a
source .env
set +a

cd "$(dirname "$0")"
echo "📦 Setting up OneMediaServer directories..."

# Load secrets if defined
if [ -n "${SECRETS_FILE:-}" ] && [ -f "$SECRETS_FILE" ]; then
  echo "🔐 Loading secrets from $SECRETS_FILE..."
  source "$SECRETS_FILE"
fi

# Create base dirs
mkdir -p "$BASE_DIR" "$BASE_DIR/secrets"
mkdir -p "$CONF"/{traefik,sonarr,radarr,prowlarr,rdtclient,bazarr,overseerr,tautulli,heimdall}
mkdir -p "$DATA"/{media/{movies,tv},downloads/{Radarr,Sonarr}}

# Ensure acme.json is secure
touch "$CONF"/traefik/acme.json
chmod 600 "$CONF"/traefik/acme.json
chown ${PUID}:${PGID} "$CONF"/traefik/acme.json

# Copy compose & env if missing
cp docker-compose.yml "$BASE_DIR/" 2>/dev/null || echo "⚠️ docker-compose.yml missing"
cp .env "$BASE_DIR/" 2>/dev/null           || echo "⚠️ .env missing"

cd "$BASE_DIR"
docker compose up -d
