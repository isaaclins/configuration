# ============================================================================ #
# hosts/homelab/default.nix - Headless Linux Server Configuration              #
# ============================================================================ #
# This is the main configuration file for the homelab server.                  #
# It imports ONLY server-related modules - NO browsers, NO GUI software.       #
# Platform: x86_64-linux running NixOS.                                        #
# Purpose: Headless server for hosting services, containers, etc.              #
# ============================================================================ #
# DEPLOYMENT:                                                                  #
# sudo nixos-rebuild switch --flake ~/.config/nix/configuration#homelab             #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS module

# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# This attribute set defines the complete system configuration.                #
# ============================================================================ #
{
  # ========================================================================== #
  # IMPORTS - Shared Modules                                                   #
  # ========================================================================== #
  # Import ONLY server-appropriate modules.                                    #
  # NO browsers, NO GUI, NO desktop software.                                  #
  # ========================================================================== #
  imports = [
    # ------------------------------------------------------------------------ #
    # Server Essentials                                                        #
    # ------------------------------------------------------------------------ #
    # Core server tools: monitoring, networking, system administration.        #
    # Includes: htop, btop, tmux, curl, rsync, jq, and more.                   #
    # Also enables SSH server with secure defaults.                            #
    # ------------------------------------------------------------------------ #
    ../../modules/server/essentials.nix # Import server essentials module

    # ------------------------------------------------------------------------ #
    # Development - Git                                                        #
    # ------------------------------------------------------------------------ #
    # Git for managing configuration and pulling repos.                        #
    # Useful for deploying applications from Git repositories.                 #
    # ------------------------------------------------------------------------ #
    ../../modules/development/git.nix # Import Git development module

    # ------------------------------------------------------------------------ #
    # Development - Docker                                                     #
    # ------------------------------------------------------------------------ #
    # Docker for running containerized services.                               #
    # Essential for homelab with services like Jellyfin, Nextcloud, etc.       #
    # ------------------------------------------------------------------------ #
    ../../modules/development/docker.nix # Import Docker module

    # ======================================================================== #
    # MODULES NOT IMPORTED (Server doesn't need these):                        #
    # ======================================================================== #
    # - browsers/arc.nix (No GUI - no browser needed)                          #
    # - browsers/zen.nix (No GUI - no browser needed)                          #
    # - terminal/ghostty.nix (No GUI - use SSH for terminal access)            #
    # - editors/neovim.nix (Optional - uncomment if you edit on server)        #
    # - shells/fish.nix (Optional - uncomment if you want Fish on server)      #
    # ======================================================================== #

  ]; # End of imports list

  # ========================================================================== #
  # BOOT CONFIGURATION                                                         #
  # ========================================================================== #
  # Configure the bootloader. Adjust based on your system's boot mode.         #
  # ========================================================================== #
  boot.loader = {
    # ------------------------------------------------------------------------ #
    # Systemd-boot (UEFI Systems)                                              #
    # ------------------------------------------------------------------------ #
    # Use systemd-boot for UEFI systems. Simple and reliable.                  #
    # If your system uses BIOS/Legacy boot, use GRUB instead.                  #
    # ------------------------------------------------------------------------ #
    systemd-boot.enable = true; # Enable systemd-boot bootloader (UEFI)
    efi.canTouchEfiVariables = true; # Allow modifying EFI variables

    # ------------------------------------------------------------------------ #
    # GRUB Alternative (BIOS/Legacy Boot)                                      #
    # ------------------------------------------------------------------------ #
    # Uncomment these and comment systemd-boot for BIOS systems:               #
    # ------------------------------------------------------------------------ #
    # grub = {
    #   enable = true; # Enable GRUB bootloader
    #   device = "/dev/sda"; # Install GRUB to this disk (change as needed)
    # }; # End of grub

  }; # End of boot.loader

  # ========================================================================== #
  # FILESYSTEM CONFIGURATION                                                   #
  # ========================================================================== #
  # Define the filesystem mounts. CUSTOMIZE FOR YOUR SYSTEM.                   #
  # Run 'nixos-generate-config' to auto-generate this for your hardware.       #
  # ========================================================================== #
  fileSystems = {
    # ------------------------------------------------------------------------ #
    # Root Filesystem                                                          #
    # ------------------------------------------------------------------------ #
    # The main root partition. Change the device to match your system.         #
    # Use 'lsblk' or 'blkid' to find your partition UUIDs.                     #
    # ------------------------------------------------------------------------ #
    "/" = {
      device = "/dev/disk/by-label/nixos"; # Root partition (change to your device)
      fsType = "ext4"; # Filesystem type: "ext4", "btrfs", "xfs", etc.
    }; # End of root filesystem

    # ------------------------------------------------------------------------ #
    # EFI System Partition (UEFI only)                                         #
    # ------------------------------------------------------------------------ #
    # The EFI partition for UEFI boot. Usually /boot or /boot/efi.             #
    # Comment out if using BIOS/Legacy boot.                                   #
    # ------------------------------------------------------------------------ #
    "/boot" = {
      device = "/dev/disk/by-label/boot"; # EFI partition (change to your device)
      fsType = "vfat"; # EFI partition is always FAT32 (vfat)
    }; # End of boot filesystem

  }; # End of fileSystems

  # ========================================================================== #
  # NETWORKING                                                                 #
  # ========================================================================== #
  # Configure networking for the server.                                       #
  # ========================================================================== #
  networking = {
    # ------------------------------------------------------------------------ #
    # Hostname                                                                 #
    # ------------------------------------------------------------------------ #
    # The server's hostname. This should match the flake configuration name.   #
    # ------------------------------------------------------------------------ #
    hostName = "homelab"; # Set the hostname

    # ------------------------------------------------------------------------ #
    # Network Manager                                                          #
    # ------------------------------------------------------------------------ #
    # NetworkManager is useful for dynamic network configuration.              #
    # For servers with static IPs, you might prefer systemd-networkd.          #
    # ------------------------------------------------------------------------ #
    networkmanager.enable = true; # Enable NetworkManager for networking

    # ------------------------------------------------------------------------ #
    # Static IP Configuration (Optional)                                       #
    # ------------------------------------------------------------------------ #
    # For servers, a static IP is often preferred.                             #
    # Uncomment and configure for static IP:                                   #
    # ------------------------------------------------------------------------ #
    # interfaces.eth0 = {
    #   useDHCP = false; # Disable DHCP on this interface
    #   ipv4.addresses = [{
    #     address = "192.168.1.100"; # Your static IP
    #     prefixLength = 24; # Subnet mask (/24 = 255.255.255.0)
    #   }]; # End of addresses
    # }; # End of eth0 interface
    # defaultGateway = "192.168.1.1"; # Your router's IP
    # nameservers = [ "1.1.1.1" "8.8.8.8" ]; # DNS servers

  }; # End of networking

  # ========================================================================== #
  # TIME ZONE                                                                  #
  # ========================================================================== #
  # Set the server's time zone.                                                #
  # ========================================================================== #
  time.timeZone = "Europe/Zurich"; # Set to your time zone

  # ========================================================================== #
  # LOCALE                                                                     #
  # ========================================================================== #
  # Configure system locale settings.                                          #
  # ========================================================================== #
  i18n.defaultLocale = "en_US.UTF-8"; # Default system locale

  # ========================================================================== #
  # NIX CONFIGURATION                                                          #
  # ========================================================================== #
  # Configure the Nix package manager settings.                                #
  # ========================================================================== #
  nix = {
    # ------------------------------------------------------------------------ #
    # Experimental Features                                                    #
    # ------------------------------------------------------------------------ #
    # Enable flakes and the new nix command.                                   #
    # Required for using this flake-based configuration.                       #
    # ------------------------------------------------------------------------ #
    settings.experimental-features = [
      "nix-command" # Enable the new nix CLI commands
      "flakes" # Enable flakes for reproducible configurations
    ]; # End of experimental-features

  }; # End of nix configuration

  # ========================================================================== #
  # NIXPKGS CONFIGURATION                                                      #
  # ========================================================================== #
  # Configure the nixpkgs settings.                                            #
  # ========================================================================== #
  nixpkgs.config.allowUnfree = true; # Allow packages with unfree licenses

  # ========================================================================== #
  # USER ACCOUNTS                                                              #
  # ========================================================================== #
  # Define user accounts on the server.                                        #
  # ========================================================================== #
  users.users = {
    # ------------------------------------------------------------------------ #
    # Primary Admin User                                                       #
    # ------------------------------------------------------------------------ #
    # The main user account for server administration.                         #
    # Change "isaaclins" to your username.                                     #
    # ------------------------------------------------------------------------ #
    isaaclins = {
      isNormalUser = true; # Create as a normal (non-system) user
      description = "Isaac Lins"; # User's full name/description
      extraGroups = [
        "wheel" # Allow sudo access
        "docker" # Allow Docker without sudo
        "networkmanager" # Allow network configuration
      ]; # End of extraGroups

      # ---------------------------------------------------------------------- #
      # SSH Authorized Keys                                                    #
      # ---------------------------------------------------------------------- #
      # Add your SSH public key here for passwordless login.                   #
      # Get your public key with: cat ~/.ssh/id_ed25519.pub                    #
      # ---------------------------------------------------------------------- #
      openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3..." # Paste your public key here
      ]; # End of authorizedKeys

    }; # End of isaaclins user

  }; # End of users.users

  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Additional packages specific to this server.                               #
  # Server essentials module provides most tools; add extras here.             #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Text Editors                                                             #
    # ------------------------------------------------------------------------ #
    # Basic editors for quick file edits on the server.                        #
    # These are lightweight alternatives to the full neovim module.            #
    # ------------------------------------------------------------------------ #
    vim # Vim editor (lightweight, always available)
    nano # Nano editor (simple, beginner-friendly)

  ]; # End of systemPackages

  # ========================================================================== #
  # ENVIRONMENT VARIABLES                                                      #
  # ========================================================================== #
  # Set system-wide environment variables.                                     #
  # ========================================================================== #
  environment.variables = {
    EDITOR = "vim"; # Default editor for CLI tools
  }; # End of environment.variables

  # ========================================================================== #
  # SERVICES                                                                   #
  # ========================================================================== #
  # Enable and configure additional services.                                  #
  # The server/essentials module already enables SSH and firewall.             #
  # ========================================================================== #
  services = {
    # ------------------------------------------------------------------------ #
    # Tailscale (Optional - VPN)                                               #
    # ------------------------------------------------------------------------ #
    # Tailscale provides easy VPN access to your homelab.                      #
    # Uncomment to enable secure remote access without port forwarding.        #
    # ------------------------------------------------------------------------ #
    # tailscale.enable = true; # Enable Tailscale VPN

    # ------------------------------------------------------------------------ #
    # Fail2ban (Optional - Security)                                           #
    # ------------------------------------------------------------------------ #
    # Fail2ban bans IPs with too many failed login attempts.                   #
    # Adds extra security for SSH.                                             #
    # ------------------------------------------------------------------------ #
    # fail2ban = {
    #   enable = true; # Enable fail2ban
    #   maxretry = 5; # Ban after 5 failed attempts
    # }; # End of fail2ban

  }; # End of services

  # ========================================================================== #
  # FIREWALL ADDITIONAL PORTS                                                  #
  # ========================================================================== #
  # Add ports for services you run on this server.                             #
  # The server/essentials module already opens SSH (22).                       #
  # ========================================================================== #
  networking.firewall.allowedTCPPorts = [
    22 # SSH (already in essentials, but explicit here)
    # 80 # HTTP (uncomment for web server)
    # 443 # HTTPS (uncomment for web server)
    # 8080 # Alternative HTTP port
    # 3000 # Common dev server port
    # 8096 # Jellyfin media server
    # 9000 # Portainer
  ]; # End of allowedTCPPorts

  # ========================================================================== #
  # SYSTEM STATE VERSION                                                       #
  # ========================================================================== #
  # DO NOT CHANGE this after initial NixOS install.                            #
  # This is used for backwards compatibility during NixOS upgrades.            #
  # Check release notes before changing: https://nixos.org/manual/nixos/stable #
  # ========================================================================== #
  system.stateVersion = "24.05"; # NixOS state version (do not change)

} # End of module configuration
