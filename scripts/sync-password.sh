#!/bin/bash
# Syncs index.html's FALLBACK_PASSWORD_HASH to match the plaintext password
# currently in config.js. config.js is gitignored (local-only); this script
# is what keeps the committed index.html's fallback hash in step with it.
# Run manually, or automatically via the pre-commit hook (see install-hooks.sh).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$DIR/config.js"
INDEX="$DIR/index.html"

if [ ! -f "$CONFIG" ]; then
  # No local config.js (e.g. fresh checkout) -- nothing to sync, leave index.html alone.
  exit 0
fi

PASSWORD=$(grep -o 'password:[[:space:]]*"[^"]*"' "$CONFIG" | sed -E 's/password:[[:space:]]*"(.*)"/\1/')

if [ -z "$PASSWORD" ]; then
  echo "sync-password: couldn't find a password in config.js, skipping." >&2
  exit 0
fi

NEW_HASH=$(printf '%s' "$PASSWORD" | shasum -a 256 | awk '{print $1}')
CURRENT_HASH=$(grep -o "FALLBACK_PASSWORD_HASH = '[a-f0-9]\{64\}'" "$INDEX" | sed -E "s/.*'([a-f0-9]+)'/\1/")

if [ "$NEW_HASH" == "$CURRENT_HASH" ]; then
  exit 0
fi

sed -i '' -E "s/(FALLBACK_PASSWORD_HASH = ')[a-f0-9]{64}(')/\1${NEW_HASH}\2/" "$INDEX"
echo "sync-password: index.html's fallback password hash updated to match config.js."
