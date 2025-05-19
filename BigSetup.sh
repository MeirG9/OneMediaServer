#!/bin/bash
set -euo pipefail
set -a
source .env
set +a

# Move to script location
cd "$(dirname "$0")"

echo "📦 Setting up directory structure for OneMediaServer..."

# Load secrets if defined and file exists
if [ -n "${SECRETS_FILE:-}" ] && [ -f "$SECRETS_FILE" ]; then
  echo "🔐 Loading secrets from $SECRETS_FILE..."
  source "$SECRETS_FILE"
fi

# Ensure base directories exist
mkdir -p "$BASE_DIR"

# Copy docker-compose and .env if not already inside BASE_DIR
cp docker-compose.yml "$BASE_DIR/" 2>/dev/null || echo "⚠️ Missing docker-compose.yml"
cp .env "$BASE_DIR/" 2>/dev/null || echo "⚠️ Missing .env"

# Import external config if provided
if [ -n "${CONFIG_SOURCE:-}" ] && [ -d "$CONFIG_SOURCE" ]; then
  echo "📁 Importing configuration from $CONFIG_SOURCE"
  cp -rn "$CONFIG_SOURCE/"* "$CONF/" || echo "⚠️ Failed to import configs"
fi

# Create necessary directory structure
mkdir -p "$CONF" \
         "$DATA/media/movies" \
         "$DATA/media/tv" \
         "$DATA/downloads/Radarr" \
         "$DATA/downloads/Sonarr" \
         "$BASE_DIR/secrets"

cd "$BASE_DIR"
docker compose up -d

