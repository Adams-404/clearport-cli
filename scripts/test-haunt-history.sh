#!/usr/bin/env bash
# Checks the shell-history parsing behind 'clearport haunt' without a model.
set -Eeuo pipefail

cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/history" <<'HISTORY'
: 1700000000:0;ls -la
pkg install jq

git status
clearport chat
git status
: 1700000100:0;nmap -p 8080 127.0.0.1
curl http://127.0.0.1:8080/v1/models
history | tail
HISTORY

actual="$(HISTFILE="$tmp/history" bash scripts/clearport haunt --dry-run 4)"
expected="pkg install jq
git status
nmap -p 8080 127.0.0.1
curl http://127.0.0.1:8080/v1/models"

if [ "$actual" != "$expected" ]; then
  printf 'FAIL: unexpected commands selected\nexpected:\n%s\nactual:\n%s\n' "$expected" "$actual" >&2
  exit 1
fi

if HISTFILE="$tmp/history" bash scripts/clearport haunt --dry-run 0 >/dev/null 2>&1; then
  printf 'FAIL: a count of 0 should be rejected\n' >&2
  exit 1
fi

if HISTFILE="$tmp/history" bash scripts/clearport haunt --dry-run 21 >/dev/null 2>&1; then
  printf 'FAIL: a count of 21 should be rejected\n' >&2
  exit 1
fi

printf 'haunt history checks passed\n'
