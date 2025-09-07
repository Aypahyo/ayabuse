#!/usr/bin/env bash
set -euo pipefail

# run.sh - start the built abuse executable from the repo root
# behavior:
#  - prefer abuse/abuse.x11R6 then abuse/abuse
#  - ensure DISPLAY is set (defaults to :0 if unset)
#  - forwards all args to the binary

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANDIDATES=("$ROOT/build/bin/abuse.x11R6" "$ROOT/build/bin/abuse" "$ROOT/abuse/abuse.x11R6" "$ROOT/abuse/abuse")
BIN=""
for p in "${CANDIDATES[@]}"; do
  if [ -x "$p" ]; then
    BIN="$p"
    break
  fi
done

if [ -z "$BIN" ]; then
  echo "No built executable found. Try building first (run: make -j$(nproc) at repo root)." >&2
  exit 2
fi

# Ensure we have an X display
: "${DISPLAY:=:0}"
export DISPLAY

printf "Starting %s\n" "$BIN"
exec "$BIN" "$@"
