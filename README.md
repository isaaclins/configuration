# Multi-Machine Nix Configuration

<!-- ======================================================================= -->
<!-- This README provides setup instructions and usage documentation for     -->
<!-- managing multiple machines with Nix flakes.                             -->
<!-- ======================================================================= -->

## Overview

<!-- This section describes what this repository contains and its purpose -->

This repository contains declarative system configurations for multiple machines:

| Machine              | Platform       | Type       | Description                    |
| -------------------- | -------------- | ---------- | ------------------------------ |
| `Isaacs-MacBook-Pro` | aarch64-darwin | nix-darwin | macOS development workstation  |
| `homelab`            | x86_64-linux   | NixOS      | Headless Linux server (no GUI) |
| `PC`                 | x86_64-linux   | Ubuntu     | Linux desktop with gaming      |

## Quick start (one-command bootstrap)

If you just want to install one of the provided machine profiles and keep it up to date, use the bootstrap script.

1. **Install Nix and enable flakes**
   - On **macOS**:

     ```bash
     curl -L https://nixos.org/nix/install | sh
     mkdir -p ~/.config/nix
     echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
     ```

     If you haven’t installed `nix-darwin` yet, do so once:

     ```bash
     nix run nix-darwin -- switch --flake github:LnL7/nix-darwin
     ```

   - On **NixOS**:
     Ensure flakes are enabled in `/etc/nixos/configuration.nix`:
     ```nix
     nix.settings.experimental-features = [ "nix-command" "flakes" ];
     ```
     Then apply the change:
     ```bash
     sudo nixos-rebuild switch
     ```

2. **Run the bootstrap script**

   ```bash
   bash <(curl -fsSL https://github.com/isaaclins/configuration/raw/main/scripts/bootstrap.sh)
   ```

   The script will:
   - Detect whether you’re on **macOS** or **NixOS**
   - Ensure the config repo exists at `~/.config/nix/configuration` (clone if needed, or `git pull` if it’s already there)
   - On **Linux**, prompt you to choose between the `PC` (desktop) and `homelab` (server) profiles
   - Run the correct `darwin-rebuild` or `nixos-rebuild` command for the selected host

3. **Log out / reboot if needed**

   Some settings (especially display managers and macOS system prefs) may require a logout or reboot to fully take effect.

## Repository Structure

<!-- This section explains the directory layout and what each folder contains -->

```
configurations/
├── flake.nix                    # Root flake - entry point for all configurations
├── flake.lock                   # Locked dependency versions for reproducibility
├── README.md                    # This documentation file
│
├── modules/                     # Shared modules (hosts import only what they need)
│   ├── browsers/
│   │   ├── arc.nix              # Arc browser (macOS only)
│   │   └── zen.nix              # Zen browser (Linux only)
│   ├── terminal/
│   │   └── ghostty.nix          # Ghostty terminal emulator
│   ├── editors/
│   │   └── neovim.nix           # Neovim text editor
│   ├── shells/
│   │   └── fish.nix             # Fish shell with zoxide
│   ├── development/
│   │   ├── git.nix              # Git version control + GitHub CLI
│   │   └── docker.nix           # Docker containerization
│   └── server/
│       └── essentials.nix       # Server monitoring and tools
│
└── hosts/                       # Per-machine configurations
    ├── Isaacs-MacBook-Pro/      # macOS workstation
    │   └── default.nix
    ├── homelab/                 # Linux server (headless)
    │   └── default.nix
    └── PC/                      # Linux desktop
        └── default.nix
```

## Prerequisites

<!-- This section lists what you need before using this configuration -->

### For macOS (nix-darwin)

1. **Install Nix** (if not already installed):

   ##### This command installs the Nix package manager on macOS

   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

2. **Enable Flakes** (add to `~/.config/nix/nix.conf`):

   ##### Flakes are an experimental feature that must be enabled

   ##### This command creates the config directory if it doesn't exist

   ```bash
   mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Install nix-darwin** (first time only):
   ```bash
   nix run nix-darwin -- switch --flake github:LnL7/nix-darwin
   ```

### For NixOS

<!-- NixOS comes with Nix pre-installed, but flakes need enabling -->

1. **Enable Flakes** (add to `/etc/nixos/configuration.nix`):

   ##### This enables the experimental flakes feature system-wide

   ```nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```

2. **Rebuild** to apply the flakes setting:
   ##### This applies the configuration change
   ```bash
   sudo nixos-rebuild switch
   ```

## Deployment (manual, without bootstrap script)

If you prefer not to use the bootstrap script, you can apply the configs manually:

1. **Ensure prerequisites** (Nix, flakes, nix-darwin / NixOS) as described above.

2. **Choose a directory for the repo** (default: `~/.config/nix/configuration`):

   ```bash
   export CONFIG_DIR="$HOME/.config/nix/configuration"
   ```

3. **Clone or update the repo**:
   - First time:
     ```bash
     mkdir -p "$(dirname "$CONFIG_DIR")"
     git clone https://github.com/isaaclins/configuration.git "$CONFIG_DIR"
     cd "$CONFIG_DIR"
     ```
   - Already cloned:
     ```bash
     cd "$CONFIG_DIR"
     git pull --ff-only
     ```

4. **Apply the desired host profile**:
   - **macOS (Isaacs-MacBook-Pro)**:
     ```bash
     darwin-rebuild switch --flake .#Isaacs-MacBook-Pro
     ```
   - **Linux server (homelab)**:
     ```bash
     sudo nixos-rebuild switch --flake .#homelab
     ```
   - **Linux desktop (PC)**:
     ```bash
     sudo nixos-rebuild switch --flake .#PC
     ```

## Adding a New Machine

<!-- This section provides a guide for adding additional machines -->

1. **Create a host directory**:

   ```bash
   # Create the directory for your new machine
   mkdir -p hosts/<hostname>
   ```

2. **Create the configuration file** (`hosts/<hostname>/default.nix`):

   ```nix
   # Example structure for a new host configuration
   { config, pkgs, lib, ... }:
   {
     imports = [
       # Import only the modules this machine needs
       ../../modules/shells/fish.nix
       ../../modules/editors/neovim.nix
     ];

     # Host-specific settings go here
   }
   ```

3. **Add to flake.nix**:

   ```nix
   # For macOS, add to darwinConfigurations:
   "<hostname>" = nix-darwin.lib.darwinSystem {
     system = "aarch64-darwin";  # or "x86_64-darwin" for Intel Macs
     modules = [ ./hosts/<hostname>/default.nix ];
   };

   # For Linux, add to nixosConfigurations:
   "<hostname>" = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [ ./hosts/<hostname>/default.nix ];
   };
   ```

4. **Deploy**:

   ```bash
   # For macOS
   darwin-rebuild switch --flake .#<hostname>

   # For Linux
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Module System

<!-- This section explains how the modular design works -->

### Design Philosophy

- **Modules are optional**: Each host imports only what it needs
- **No bloat**: Server doesn't get desktop software
- **Clear dependencies**: Each host's `default.nix` shows exactly what it uses
- **Easy customization**: Add/remove features by adding/removing imports

### Available Modules

| Module                   | Description         | Used By                |
| ------------------------ | ------------------- | ---------------------- |
| `browsers/arc.nix`       | Arc browser         | Isaacs-MacBook-Pro     |
| `browsers/zen.nix`       | Zen browser         | PC                     |
| `terminal/ghostty.nix`   | Ghostty terminal    | Isaacs-MacBook-Pro, PC |
| `editors/neovim.nix`     | Neovim editor       | Isaacs-MacBook-Pro, PC |
| `shells/fish.nix`        | Fish shell + zoxide | Isaacs-MacBook-Pro, PC |
| `development/git.nix`    | Git + GitHub CLI    | All machines           |
| `development/docker.nix` | Docker containers   | homelab                |
| `server/essentials.nix`  | Server tools        | homelab                |

### Configuration Architecture

```mermaid
flowchart TD
  %% Top-level flake and inputs
  flake["flake.nix"]
  nixpkgs["nixpkgs input"]
  darwin["nix-darwin input"]
  hm["home-manager input"]

  flake --> nixpkgs
  flake --> darwin
  flake --> hm

  %% Hosts
  subgraph hosts [Host system configs]
    macHost["hosts/Isaacs-MacBook-Pro/default.nix"]
    homelabHost["hosts/homelab/default.nix"]
    pcHost["hosts/PC/default.nix"]
  end

  flake --> macHost
  flake --> homelabHost
  flake --> pcHost

  %% Shared system modules
  subgraph sysModules [Shared system modules]
    arcMod["modules/browsers/arc.nix"]
    zenMod["modules/browsers/zen.nix"]
    ghosttyApp["modules/terminal/ghostty.nix"]
    neovimMod["modules/editors/neovim.nix"]
    fishMod["modules/shells/fish.nix"]
    gitMod["modules/development/git.nix"]
    dockerMod["modules/development/docker.nix"]
    serverEssMod["modules/server/essentials.nix"]
  end

  macHost --> arcMod
  macHost --> ghosttyApp
  macHost --> neovimMod
  macHost --> fishMod
  macHost --> gitMod

  homelabHost --> gitMod
  homelabHost --> dockerMod
  homelabHost --> serverEssMod

  pcHost --> zenMod
  pcHost --> ghosttyApp
  pcHost --> neovimMod
  pcHost --> fishMod
  pcHost --> gitMod

  %% Home Manager user configs
  subgraph hmUsers [Home Manager user configs]
    macHome["hosts/Isaacs-MacBook-Pro/home.nix"]
    pcHome["hosts/PC/home.nix"]
  end

  hm --> macHome
  hm --> pcHome

  %% Shared Ghostty HM module
  ghosttyHome["modules/terminal/ghostty-home.nix"]

  macHome --> ghosttyHome
  pcHome --> ghosttyHome

  %% Ghostty application module details
  ghosttyApp -->|"NixOS system"| pcHost
  ghosttyApp -->|"Home Manager user (isaac)"| ghosttyHome
```

## Updating

<!-- This section explains how to keep configurations up to date -->

### Update Flake Inputs

```bash
# Update all inputs to their latest versions
# This modifies flake.lock with new commit hashes
nix flake update

# Update only a specific input (e.g., nixpkgs)
nix flake lock --update-input nixpkgs
```

### Apply Updates

```bash
# After updating, rebuild your system
# macOS:
darwin-rebuild switch --flake .#Isaacs-MacBook-Pro

# Linux:
sudo nixos-rebuild switch --flake .#<hostname>
```

## Versioned Snapshots with GitHub Releases

<!-- This section explains how to use tags/Releases as frozen snapshots -->

### Why use releases?

- **Reproducible snapshots**: Each tag + `flake.lock` is a frozen view of all hosts.
- **Safe rollbacks**: You can roll machines back to a known-good tag.
- **Clear history**: Release notes summarize what changed on each machine.

### 1. Create a tagged snapshot

From your local clone:

```bash
# Make sure main is up to date and CI is green
git checkout main
git pull

# Create an annotated tag for this snapshot
git tag -a v0.1.0 -m "First shared configuration snapshot"

# Push the tag to GitHub
git push origin v0.1.0
```

### 2. Create a GitHub Release for the tag

1. Go to the **Releases** tab in the GitHub UI.
2. Click **“Draft a new release”**.
3. Choose the tag you just pushed (for example `v0.1.0`).
4. Add a short summary, for example:
   - **Isaacs-MacBook-Pro**: Arc, Ghostty, Neovim, Fish, Git tools
   - **homelab**: Server essentials, Git, Docker
   - **PC**: Zen, Ghostty, Neovim, Fish, Steam + gaming tools
5. Publish the release.

### 3. Deploy a specific release to a machine

Instead of using the local checkout, you can point `--flake` at the GitHub repo + tag:

#### macOS (Isaacs-MacBook-Pro)

```bash
darwin-rebuild switch \
  --flake github:isaaclins/configuration?ref=v0.1.0#Isaacs-MacBook-Pro
```

#### Linux Server (homelab)

```bash
sudo nixos-rebuild switch \
  --flake github:isaaclins/configuration?ref=v0.1.0#homelab
```

#### Linux Desktop (PC)

```bash
sudo nixos-rebuild switch \
  --flake github:isaaclins/configuration?ref=v0.1.0#PC
```

### 4. Roll back to an older snapshot

If a newer change breaks something, just target an older tag:

```bash
# Example: roll back PC to v0.2.1
sudo nixos-rebuild switch \
  --flake github:isaaclins/configuration?ref=v0.2.1#PC
```

You can keep using `main` for day-to-day work and only cut tags/Releases when you reach a “known good” state you want to pin and roll back to later.

## Troubleshooting

<!-- This section provides solutions to common problems -->

### "experimental-features" error

If you see an error about flakes being experimental:

```bash
# Ensure flakes are enabled in your Nix configuration
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Permission denied on NixOS

NixOS requires root to modify system configuration:

```bash
# Always use sudo for NixOS rebuilds
sudo nixos-rebuild switch --flake .#<hostname>
```

### Changes not taking effect

Some changes require a restart:

```bash
# For macOS, some system settings need a logout/login
# For NixOS, some services need a reboot
sudo reboot
```

## License

<!-- License information for this configuration -->

This configuration is provided as-is for personal use.
