#!/usr/bin/env bash
set -euo pipefail

# build.sh - build the project and collect build artifacts under ./build/
# Usage: ./build.sh [clean]

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT/build"
BIN_DIR="$BUILD_DIR/bin"
LIB_DIR="$BUILD_DIR/lib"
DATA_DIR="$BUILD_DIR/data"

if [ "${1-}" = "clean" ]; then
  echo "Cleaning build artifacts and running make clean"
  make -j"$(nproc)" clean || true
  rm -rf "$BUILD_DIR"
  exit 0
fi

mkdir -p "$BIN_DIR" "$LIB_DIR" "$DATA_DIR"

echo "Building project (make -j$(nproc))..."
make -j"$(nproc)"

echo "Collecting binaries into $BIN_DIR"
CANDIDATES=("$ROOT/abuse/abuse.x11R6" "$ROOT/abuse/abuse")
FOUND=0
for p in "${CANDIDATES[@]}"; do
  if [ -x "$p" ]; then
    cp -a "$p" "$BIN_DIR/"
    FOUND=1
  fi
done
if [ $FOUND -eq 0 ]; then
  echo "Warning: no expected binaries found in 'abuse/' — check build output." >&2
fi

echo "Collecting imlib static libraries into $LIB_DIR"
if [ -d "$ROOT/imlib" ]; then
  shopt -s nullglob
  for lib in "$ROOT"/imlib/lib*.a "$ROOT"/imlib/*.a; do
    cp -a "$lib" "$LIB_DIR/" || true
  done
  shopt -u nullglob
fi

echo "Copying useful data files (netlevel, configs) into $DATA_DIR"
if [ -d "$ROOT/abuse/netlevel" ]; then
  mkdir -p "$DATA_DIR/netlevel"
  cp -a "$ROOT/abuse/netlevel"/* "$DATA_DIR/netlevel/" 2>/dev/null || true
fi

echo "Build artifacts collected:" 
ls -l "$BIN_DIR" || true
ls -l "$LIB_DIR" || true
ls -l "$DATA_DIR" || true

echo "Done. Run ./run.sh or ./run.sh --help to start the game (the script prefers build/bin)."
