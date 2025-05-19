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

# Create base directories
mkdir -p \
  "$BASE_DIR" \
  "$BASE_DIR/secrets" \
  "$CONF"/{traefik,sonarr,radarr,prowlarr,rdtclient,bazarr,overseerr,tautulli,heimdall,flaresolverr,notifiarr,xteve,portainer,prometheus} \
  "$DATA"/{media/{movies,tv},downloads/{Radarr,Sonarr}}

# Secure acme.json for Traefik
touch "$CONF"/traefik/acme.json
chmod 600 "$CONF"/traefik/acme.json
chown "${PUID}:${PGID}" "$CONF"/traefik/acme.json

# Copy docker-compose and .env into BASE_DIR if missing
cp docker-compose.yml "$BASE_DIR/" 2>/dev/null || echo "⚠️ docker-compose.yml missing in working dir"
cp .env               "$BASE_DIR/" 2>/dev/null || echo "⚠️ .env missing in working dir"

# Prepare Prometheus config placeholder if needed
if [ ! -f "$CONF/prometheus/prometheus.yml" ]; then
  echo "📝 Creating Prometheus config template at $CONF/prometheus/prometheus.yml"
  cat > "$CONF/prometheus/prometheus.yml" <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  # הוסיפו כאן jobs נוספים לפי הצורך
EOF
  chmod 640 "$CONF/prometheus/prometheus.yml"
  chown "${PUID}:${PGID}" "$CONF/prometheus/prometheus.yml"
fi

# Switch to BASE_DIR and launch stack
cd "$BASE_DIR"
docker compose up -d
