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
| `PC`                 | x86_64-linux   | NixOS      | Linux desktop with gaming      |

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

   ```bash
   # This command installs the Nix package manager on macOS
   curl -L https://nixos.org/nix/install | sh
   ```

2. **Enable Flakes** (add to `~/.config/nix/nix.conf`):

   ```bash
   # Flakes are an experimental feature that must be enabled
   # Create the config directory if it doesn't exist
   mkdir -p ~/.config/nix

   # Add the experimental features line to enable flakes
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Install nix-darwin** (first time only):
   ```bash
   # Bootstrap nix-darwin using this flake
   # Replace <hostname> with your machine name (e.g., Isaacs-MacBook-Pro)
   nix run nix-darwin -- switch --flake .#<hostname>
   ```

### For NixOS

<!-- NixOS comes with Nix pre-installed, but flakes need enabling -->

1. **Enable Flakes** (add to `/etc/nixos/configuration.nix`):

   ```nix
   # This enables the experimental flakes feature system-wide
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```

2. **Rebuild** to apply the flakes setting:
   ```bash
   # Apply the configuration change
   sudo nixos-rebuild switch
   ```

## Deployment

<!-- This section explains how to apply configurations to each machine -->

### macOS (Isaacs-MacBook-Pro)

```bash
# Clone the configuration repository (first time only)
git clone https://github.com/isaaclins/configuration.git ~/.config/nix/configuration

# Navigate to the configuration directory
cd ~/.config/nix/configuration

# Apply the configuration for this Mac
# darwin-rebuild reads the flake and applies the darwinConfiguration
darwin-rebuild switch --flake .#Isaacs-MacBook-Pro
```

### Linux Server (homelab)

```bash
# Clone the configuration repository (first time only)
git clone https://github.com/isaaclins/configuration.git ~/.config/nix/configuration

# Navigate to the configuration directory
cd ~/.config/nix/configuration

# Apply the configuration for the server
# sudo is required because NixOS modifies system files
sudo nixos-rebuild switch --flake .#homelab
```

### Linux Desktop (PC)

```bash
# Clone the configuration repository (first time only)
git clone https://github.com/isaaclins/configuration.git ~/.config/nix/configuration

# Navigate to the configuration directory
cd ~/.config/nix/configuration

# Apply the configuration for the desktop
# sudo is required because NixOS modifies system files
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
