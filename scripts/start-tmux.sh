#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="${1:-iceberg-demo}"
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is not installed."
  echo "Install it, then run this script again."
  exit 1
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  exec tmux attach -t "$SESSION_NAME"
fi

# Create session and two-pane layout:
# - Left: Spark SQL terminal
# - Right: check table state
tmux new-session -d -s "$SESSION_NAME" -c "$ROOT_DIR"
tmux rename-window -t "$SESSION_NAME:0" demo
tmux set-option -t "$SESSION_NAME" -g mouse on

tmux split-window -h -t "$SESSION_NAME:0" -c "$ROOT_DIR"
tmux select-layout -t "$SESSION_NAME:0" even-horizontal

# Focus SQL pane first
tmux select-pane -t "$SESSION_NAME:0.0"
exec tmux attach -t "$SESSION_NAME"
