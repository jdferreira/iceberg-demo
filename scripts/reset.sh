#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

echo "Stopping stack and removing volumes..."
docker compose down -v --remove-orphans

echo "Removing known local artifacts..."
if ! rm -rf ./warehouse 2>/dev/null; then
	echo "Local rm failed (likely root-owned files). Cleaning warehouse with a temporary container..."
	mkdir -p ./warehouse
	docker run --rm -v "$ROOT_DIR/warehouse:/data" alpine:3.20 sh -lc 'rm -rf /data/* /data/.[!.]* /data/..?* || true'
	rm -rf ./warehouse || true
fi

echo "Reset complete. Next start will initialize a fresh warehouse bucket."
