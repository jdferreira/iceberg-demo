#!/usr/bin/env bash
set -uo pipefail

curl -s http://localhost:8181/v1/namespaces/app/tables/journeys | \
  jq -C '{"current-snapshot-id": .metadata["current-snapshot-id"], snapshots: .metadata.snapshots}' | \
  LESS=-R less
