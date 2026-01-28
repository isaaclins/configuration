#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh - One-command bootstrap for multi-machine Nix configuration
# =============================================================================
# This script:
#   1. Detects your operating system (macOS vs NixOS/Linux)
#   2. Ensures the configuration repo exists (clone if missing, pull if present)
#   3. Prompts you to choose which host profile to apply (on Linux)
#   4. Runs the appropriate *-rebuild command for that host
#
# Default clone location: ~/.config/nix/configuration
# You can override this by setting CONFIG_DIR before running:
#   CONFIG_DIR=~/github/configuration bash bootstrap.sh
# =============================================================================
set -euo pipefail

REPO_URL="https://github.com/isaaclins/configuration.git"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/nix/configuration}"

echo "==> Using configuration directory: $CONFIG_DIR"

# Step 1: Ensure the repo exists (clone or update)
if [ ! -d "$CONFIG_DIR/.git" ]; then
  echo "==> Configuration repo not found, cloning..."
  mkdir -p "$(dirname "$CONFIG_DIR")"
  git clone "$REPO_URL" "$CONFIG_DIR"
else
  echo "==> Existing repo found, updating (git pull)..."
  git -C "$CONFIG_DIR" pull --ff-only
fi

cd "$CONFIG_DIR"

# Step 2: Detect operating system
OS="$(uname -s || echo unknown)"
echo "==> Detected OS: $OS"

HOST=""
REBUILD_CMD=()

case "$OS" in
  Darwin)
    HOST="Isaacs-MacBook-Pro"
    echo "==> Selected host profile: $HOST (macOS / nix-darwin)"

    if command -v darwin-rebuild >/dev/null 2>&1; then
      echo "==> Found 'darwin-rebuild', will use it to apply the configuration."
      REBUILD_CMD=(darwin-rebuild switch --flake "$CONFIG_DIR#$HOST")
    else
      echo "!! 'darwin-rebuild' not found. Using nix-darwin bootstrap via 'nix run'."
      echo "   (This assumes you have Nix installed with flakes enabled.)"
      REBUILD_CMD=(nix run nix-darwin -- switch --flake "$CONFIG_DIR#$HOST")
    fi
    ;;

  Linux)
    echo "==> Linux detected. Choose which host profile to apply:"
    echo "  [1] PC      - Desktop/gaming NixOS system"
    echo "  [2] homelab - Headless NixOS server"
    echo
    read -r -p "Enter 1 or 2: " choice
    case "$choice" in
      1)
        HOST="PC"
        ;;
      2)
        HOST="homelab"
        ;;
      *)
        echo "Invalid choice. Aborting."
        exit 1
        ;;
    esac

    echo "==> Selected host profile: $HOST (NixOS)"

    if ! command -v nixos-rebuild >/dev/null 2>&1; then
      echo "ERROR: 'nixos-rebuild' not found. This bootstrap script assumes NixOS."
      echo "       If you're on another Linux distribution, you can still use the"
      echo "       flake manually, but you need to handle installation yourself."
      exit 1
    fi

    REBUILD_CMD=(sudo nixos-rebuild switch --flake "$CONFIG_DIR#$HOST")
    ;;

  *)
    echo "ERROR: Unsupported OS: $OS"
    echo "This script currently supports macOS (nix-darwin) and NixOS (Linux)."
    exit 1
    ;;
esac

# Step 3: Confirm and apply
echo
echo "==> Ready to apply configuration"
echo "    Host:   $HOST"
echo "    Command: ${REBUILD_CMD[*]}"
read -r -p "Proceed with this command? [y/N] " confirm

case "$confirm" in
  y|Y|yes|YES)
    echo "==> Applying configuration..."
    "${REBUILD_CMD[@]}"
    echo "==> Done."
    ;;
  *)
    echo "Aborted by user."
    exit 1
    ;;
esac

