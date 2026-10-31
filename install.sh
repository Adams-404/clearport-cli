#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO="Adams-404/clearport-cli"
BRANCH="main"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"
BIN_DIR="${PREFIX:-/data/data/com.termux/files/usr}/bin"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX/bin" ] || ! command -v pkg >/dev/null 2>&1; then
  echo "This installer must be run inside Termux on Android." >&2
  exit 1
fi

echo "Updating Termux packages..."
pkg update -y
pkg install -y bash curl jq procps coreutils termux-tools llama-cpp nano

echo "Downloading Clearport CLI..."
curl -fsSL "$RAW/scripts/clearport" -o "$TMP/clearport"
curl -fsSL "$RAW/scripts/clearport-server" -o "$TMP/clearport-server"
chmod 755 "$TMP/clearport" "$TMP/clearport-server"
mkdir -p "$BIN_DIR" "$HOME/models" "$HOME/.config/clearport"
install -m 755 "$TMP/clearport" "$BIN_DIR/clearport"
install -m 755 "$TMP/clearport-server" "$BIN_DIR/clearport-server"

echo
echo "Clearport CLI installed."
echo "No model yet? Fetch a verified Gemma build (292 MB or 806 MB):"
echo "  clearport pull gemma-tiny"
echo
echo "Or put your own .gguf in ~/models, then run:"
echo "  clearport local-models"
echo "  clearport use ~/models/your-model.gguf"
echo "  clearport start"
echo "  clearport chat"
echo "  clearport haunt"
echo
echo "No model weights were downloaded."
