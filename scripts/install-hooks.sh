#!/bin/bash
# Run this once (after cloning, or if the hook ever goes missing) to wire up
# the pre-commit hook that keeps index.html's password hash in sync with
# config.js. git doesn't track .git/hooks, hence this install step.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$DIR/scripts/pre-commit" "$DIR/.git/hooks/pre-commit"
chmod +x "$DIR/.git/hooks/pre-commit" "$DIR/scripts/sync-password.sh"
echo "Installed pre-commit hook."
