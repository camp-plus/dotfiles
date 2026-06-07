#!/usr/bin/env bash
# deploy-etc.sh — install system config files from dotfiles into /etc
# Usage:  ./deploy-etc.sh [--dry-run]
# Layout: expects files in $DOTFILES/etc/ (e.g. ~/dotfiles/etc/hosts)

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
SRC="$DOTFILES/etc"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# file => mode (all owned root:wheel)
FILES=(
  "hosts:644"
  "auto_master:644"
  "auto_nas:600"
  "autofs.conf:644"
)

changed=false

for entry in "${FILES[@]}"; do
  name="${entry%%:*}"
  mode="${entry##*:}"
  src="$SRC/$name"
  dst="/etc/$name"

  if [[ ! -f "$src" ]]; then
    echo "skip:   $name (not in $SRC)"
    continue
  fi

  if sudo cmp -s "$src" "$dst" 2>/dev/null; then
    echo "ok:     $dst (unchanged)"
    continue
  fi

  echo "deploy: $src -> $dst (mode $mode)"
  if [[ -f "$dst" ]]; then
    echo "--- diff (current vs new) ---"
    sudo diff -u "$dst" "$src" || true
    echo "-----------------------------"
  fi

  if ! $DRY_RUN; then
    sudo install -m "$mode" -o root -g wheel "$src" "$dst"
    changed=true
  fi
done

# Restart automountd and reload maps if anything changed.
# (automount -vc alone re-reads the maps, but automountd must be
#  restarted to pick up /etc/autofs.conf changes — it respawns on demand.)
if $changed; then
  echo "restarting automountd and reloading maps..."
  sudo killall automountd 2>/dev/null || true
  sleep 1
  sudo automount -vc
else
  echo "nothing changed; automount reload skipped"
fi

$DRY_RUN && echo "(dry run — no files written)"
exit 0