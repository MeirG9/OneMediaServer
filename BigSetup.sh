#!/bin/bash
set -euo pipefail
set -a
source .env
set +a


# Move to script location
cd "$(dirname "$0")"

echo "sets up the directory structure for a media server environment..."

# Ensure required base directories exist
mkdir -p  "$BASE_DIR/BigMediaSE/secrets" "$BASE_DIR/BigMediaSE/data/media"/{movies,tv} "$BASE_DIR/BigMediaSE/data/downloads"/{movies,tv}


# Copy base docker-compose and env example
cp "docker-compose.yml" "$BASE_DIR/BigMediaSE/" 2>/dev/null || echo "⚠️  Missing docker-compose.yml"
cp ".env" "$BASE_DIR/BigMediaSE/" 2>/dev/null || echo "⚠️  Missing .env.example"

# Final status message
echo "✅ Setup completed."
echo "➡️  Navigate to $BASE_DIR and run: docker compose up -d"
cd "BigMediaSE"
docker-compose up -d
