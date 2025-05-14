#!/bin/bash
set -euo pipefail
set -a
source .env
set +a


# Move to script location
cd "$(dirname "$0")"

echo "sets up the directory structure for a media server environment..."

# Ensure required base directories exist
mkdir -p  "BigMediaSE"
# Copy base docker-compose and env example
cp "docker-compose.yml" "$BASE_DIR/BigMediaSE/" 2>/dev/null || echo "⚠️  Missing docker-compose.yml"
cp ".env" "$BASE_DIR/BigMediaSE/" 2>/dev/null || echo "⚠️  Missing .env.example"

cd "BigMediaSE"
mkdir -p  "secrets" "$DATA/media"/{movies,tv} "$DATA/downloads"/{movies,tv}

docker-compose up -d
