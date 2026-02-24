#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-8080}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENTRY_FILE="index.html"
if [ ! -f "$ROOT_DIR/$ENTRY_FILE" ]; then
  ENTRY_FILE="antseed.html"
fi

if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
  echo "Invalid port: $PORT"
  echo "Usage: ./deploy-local.sh [port]"
  exit 1
fi

if [ ! -f "$ROOT_DIR/$ENTRY_FILE" ]; then
  echo "Cannot find $ENTRY_FILE in $ROOT_DIR"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to run a local server."
  exit 1
fi

URL="http://127.0.0.1:$PORT/$ENTRY_FILE"
echo "Local deploy ready at: $URL"
echo "Press Ctrl+C to stop."

if command -v open >/dev/null 2>&1; then
  (sleep 1 && open "$URL" >/dev/null 2>&1) &
elif command -v xdg-open >/dev/null 2>&1; then
  (sleep 1 && xdg-open "$URL" >/dev/null 2>&1) &
fi

cd "$ROOT_DIR"
exec python3 -m http.server "$PORT" --bind 127.0.0.1
