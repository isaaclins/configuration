#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh - One-command bootstrap for multi-machine Nix configuration
# =============================================================================
# This script:
#   1. Installs Nix if not already present (macOS and Linux)
#   2. Enables flakes in user nix.conf (macOS and Linux)
#   3. (NixOS only) Enables flakes in /etc/nixos/configuration.nix if needed
#   4. Detects your operating system (macOS vs NixOS/Linux)
#   5. Ensures the configuration repo exists (clone if missing, pull if present)
#   6. Prompts you to choose which host profile to apply (on Linux)
#   7. Runs the appropriate *-rebuild command for that host
#
# Default clone location: ~/.config/nix/configuration
# You can override this by setting CONFIG_DIR before running:
#   CONFIG_DIR=~/github/configuration bash bootstrap.sh
# =============================================================================
set -euo pipefail

REPO_URL="https://github.com/isaaclins/configuration.git"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/nix/configuration}"
NIX_CONF_USER="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
NIX_CONF_FILE="$NIX_CONF_USER/nix.conf"

echo "==> Using configuration directory: $CONFIG_DIR"

# Step 1: Install Nix if needed (macOS and Linux)
OS="$(uname -s || echo unknown)"
if ! command -v nix >/dev/null 2>&1; then
  echo "==> Nix not found. Running the official Nix installer..."
  curl -L https://nixos.org/nix/install | sh
  # Load Nix into this shell so the rest of the script can use it
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    set +u
    # shellcheck source=/dev/null
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    set -u
  elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    set +u
    # shellcheck source=/dev/null
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    set -u
  fi
  echo "==> Nix installed. Continuing..."
fi

# Step 2: Enable flakes in user nix.conf (macOS and Linux)
if [ ! -f "$NIX_CONF_FILE" ] || ! grep -q 'experimental-features' "$NIX_CONF_FILE" 2>/dev/null; then
  echo "==> Enabling flakes in $NIX_CONF_FILE"
  mkdir -p "$NIX_CONF_USER"
  echo "experimental-features = nix-command flakes" >> "$NIX_CONF_FILE"
fi

# Step 3 (NixOS only): Enable flakes in system config if needed
if [ "$OS" = "Linux" ] && [ -f /etc/NIXOS ] && [ -f /etc/nixos/configuration.nix ]; then
  if ! grep -q 'experimental-features' /etc/nixos/configuration.nix 2>/dev/null; then
    echo "==> Enabling flakes in /etc/nixos/configuration.nix (requires sudo)"
    # Insert the setting before the last line (most NixOS configs end with "}")
    # Use sed to insert before the last line
    if command -v python3 >/dev/null 2>&1; then
      sudo python3 << 'PYEOF'
import sys
with open('/etc/nixos/configuration.nix', 'r') as f:
    lines = f.readlines()
# Find last line that is just "}" or "};"
last_brace = None
for i in range(len(lines)-1, -1, -1):
    if lines[i].strip() in ('}', '};'):
        last_brace = i
        break
if last_brace is not None:
    lines.insert(last_brace, '  nix.settings.experimental-features = [ "nix-command" "flakes" ];\n')
    with open('/etc/nixos/configuration.nix', 'w') as f:
        f.writelines(lines)
    sys.exit(0)
else:
    # Fallback: append at end
    with open('/etc/nixos/configuration.nix', 'a') as f:
        f.write('  nix.settings.experimental-features = [ "nix-command" "flakes" ];\n')
    sys.exit(1)
PYEOF
      PYTHON_EXIT=$?
      if [ $PYTHON_EXIT -ne 0 ]; then
        echo "!! Added flakes setting at end of file. If rebuild fails, move it inside the { config, pkgs, ... }: { ... } block."
      fi
    else
      # Fallback: append at end if Python not available
      echo "  nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];" | sudo tee -a /etc/nixos/configuration.nix >/dev/null
      echo "!! Added flakes setting at end of file. If rebuild fails, move it inside the { config, pkgs, ... }: { ... } block."
    fi
    echo "==> Rebuilding NixOS to apply flakes setting..."
    sudo nixos-rebuild switch --no-build-output 2>/dev/null || {
      echo "!! Rebuild failed. You may need to move the flakes setting inside the config block manually."
    }
  fi
fi

# Step 4: Ensure the repo exists (clone or update)
if [ ! -d "$CONFIG_DIR/.git" ]; then
  echo "==> Configuration repo not found, cloning..."
  mkdir -p "$(dirname "$CONFIG_DIR")"
  git clone "$REPO_URL" "$CONFIG_DIR"
else
  echo "==> Existing repo found, updating (git pull)..."
  git -C "$CONFIG_DIR" pull --ff-only
fi

cd "$CONFIG_DIR"

# Step 5: Detect operating system (already set above, but re-set for clarity)
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
      REBUILD_CMD=(sudo darwin-rebuild switch --flake "$CONFIG_DIR#$HOST")
    else
      echo "!! 'darwin-rebuild' not found. Using nix-darwin bootstrap via 'nix run'."
      echo "   (This assumes you have Nix installed with flakes enabled.)"
      REBUILD_CMD=(sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake "$CONFIG_DIR#$HOST")
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
      echo "ERROR: 'nixos-rebuild' not found. This repo's Linux profiles (PC, homelab)"
      echo "       are NixOS configurations and require NixOS."
      echo ""
      echo "You now have Nix installed with flakes enabled. To use this repo:"
      echo "  1. Install NixOS on this machine, or"
      echo "  2. Use the flake from a NixOS machine, or"
      echo "  3. Adapt the configurations for your Linux distribution."
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

# Step 6: Confirm and apply
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

