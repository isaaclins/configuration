# ============================================================================ #
# hosts/PC/default.nix - Linux Desktop/Gaming Configuration                    #
# ============================================================================ #
# This is the main configuration file for the Linux desktop PC.                #
# It imports desktop modules and includes gaming-related software.             #
# Platform: x86_64-linux running NixOS.                                        #
# Purpose: Desktop workstation with gaming capabilities.                       #
# ============================================================================ #
# DEPLOYMENT:                                                                  #
# sudo nixos-rebuild switch --flake ~/.config/nix/configuration#PC                  #
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
  # Import desktop-appropriate modules for a full GUI experience.              #
  # ========================================================================== #
  imports = [
    # ------------------------------------------------------------------------ #
    # Browser - Zen                                                            #
    # ------------------------------------------------------------------------ #
    # Zen browser for Linux - Firefox-based with privacy focus.                #
    # Installed via nixpkgs with privacy-enhancing policies.                   #
    # ------------------------------------------------------------------------ #
    ../../modules/browsers/zen.nix # Import Zen browser module

    # ------------------------------------------------------------------------ #
    # Terminal - Ghostty                                                       #
    # ------------------------------------------------------------------------ #
    # Ghostty terminal emulator - fast, GPU-accelerated.                       #
    # Installed via nixpkgs on Linux.                                          #
    # ------------------------------------------------------------------------ #
    ../../modules/terminal/ghostty.nix # Import Ghostty terminal module

    # ------------------------------------------------------------------------ #
    # Editor - Neovim                                                          #
    # ------------------------------------------------------------------------ #
    # Neovim with LSP support for development.                                 #
    # Includes language servers and supporting tools.                          #
    # ------------------------------------------------------------------------ #
    ../../modules/editors/neovim.nix # Import Neovim editor module

    # ------------------------------------------------------------------------ #
    # Shell - Fish                                                             #
    # ------------------------------------------------------------------------ #
    # Fish shell with zoxide for smart directory navigation.                   #
    # Includes starship prompt, eza, bat, and fzf.                             #
    # ------------------------------------------------------------------------ #
    ../../modules/shells/fish.nix # Import Fish shell module

    # ------------------------------------------------------------------------ #
    # Development - Git                                                        #
    # ------------------------------------------------------------------------ #
    # Git with GitHub CLI, lazygit, delta, and other dev tools.                #
    # Comprehensive shell aliases for Git operations.                          #
    # ------------------------------------------------------------------------ #
    ../../modules/development/git.nix # Import Git development module

    # ------------------------------------------------------------------------ #
    # NOTE: Docker is NOT imported by default for this machine.                #
    # Uncomment the line below if you need Docker on this PC:                  #
    # ../../modules/development/docker.nix                                     #
    # ------------------------------------------------------------------------ #

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
    # Most modern PCs use UEFI.                                                #
    # ------------------------------------------------------------------------ #
    systemd-boot.enable = true; # Enable systemd-boot bootloader (UEFI)
    efi.canTouchEfiVariables = true; # Allow modifying EFI variables

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
    # EFI System Partition                                                     #
    # ------------------------------------------------------------------------ #
    # The EFI partition for UEFI boot.                                         #
    # ------------------------------------------------------------------------ #
    "/boot" = {
      device = "/dev/disk/by-label/boot"; # EFI partition (change to your device)
      fsType = "vfat"; # EFI partition is always FAT32 (vfat)
    }; # End of boot filesystem

  }; # End of fileSystems

  # ========================================================================== #
  # NETWORKING                                                                 #
  # ========================================================================== #
  # Configure networking for the desktop.                                      #
  # ========================================================================== #
  networking = {
    hostName = "PC"; # Set the hostname
    networkmanager.enable = true; # Enable NetworkManager for easy WiFi setup
  }; # End of networking

  # ========================================================================== #
  # TIME ZONE                                                                  #
  # ========================================================================== #
  # Set the system time zone.                                                  #
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
  nix.settings.experimental-features = [
    "nix-command" # Enable the new nix CLI commands
    "flakes" # Enable flakes for reproducible configurations
  ]; # End of experimental-features

  # ========================================================================== #
  # NIXPKGS CONFIGURATION                                                      #
  # ========================================================================== #
  # Configure the nixpkgs settings.                                            #
  # ========================================================================== #
  nixpkgs.config.allowUnfree = true; # Allow packages with unfree licenses (NVIDIA, Steam)

  # ========================================================================== #
  # DESKTOP ENVIRONMENT                                                        #
  # ========================================================================== #
  # Configure the graphical desktop environment.                               #
  # ========================================================================== #
  # ========================================================================== #
  # DESKTOP ENVIRONMENT                                                        #
  # ========================================================================== #
  # Configure the graphical desktop environment.                               #
  # ========================================================================== #
  services.xserver.enable = true; # Enable the X Window System

  # -------------------------------------------------------------------------- #
  # Display Manager                                                            #
  # -------------------------------------------------------------------------- #
  # The display manager handles login screens.                                 #
  # GDM is GNOME's display manager; alternatives: SDDM, LightDM.               #
  # -------------------------------------------------------------------------- #
  services.displayManager.gdm.enable = true; # Enable GDM (GNOME Display Manager)

  # -------------------------------------------------------------------------- #
  # Desktop Environment                                                        #
  # -------------------------------------------------------------------------- #
  # GNOME is a popular, polished desktop environment.                          #
  # Alternatives: KDE Plasma, XFCE, i3, Hyprland, etc.                         #
  # -------------------------------------------------------------------------- #
  services.desktopManager.gnome.enable = true; # Enable GNOME Desktop Environment

  # ========================================================================== #
  # GRAPHICS DRIVERS                                                           #
  # ========================================================================== #
  # Configure graphics drivers for gaming performance.                         #
  # Uncomment the appropriate section for your GPU.                            #
  # ========================================================================== #

  # ------------------------------------------------------------------------ #
  # AMD Graphics (Recommended for Linux gaming)                               #
  # ------------------------------------------------------------------------ #
  # AMD GPUs work great on Linux with open-source drivers.                    #
  # Uncomment this section if you have an AMD GPU.                            #
  # ------------------------------------------------------------------------ #
  # services.xserver.videoDrivers = [ "amdgpu" ]; # AMD GPU driver
  # hardware.opengl = {
  #   enable = true; # Enable OpenGL support
  #   driSupport = true; # Enable Direct Rendering
  #   driSupport32Bit = true; # Enable 32-bit support for games
  # }; # End of hardware.opengl

  # ------------------------------------------------------------------------ #
  # NVIDIA Graphics                                                           #
  # ------------------------------------------------------------------------ #
  # NVIDIA requires proprietary drivers for best performance.                 #
  # Uncomment this section if you have an NVIDIA GPU.                         #
  # ------------------------------------------------------------------------ #
  # services.xserver.videoDrivers = [ "nvidia" ]; # NVIDIA proprietary driver
  # hardware.nvidia = {
  #   modesetting.enable = true; # Required for Wayland
  #   powerManagement.enable = true; # Better power management
  #   open = false; # Use proprietary driver (not open-source)
  #   nvidiaSettings = true; # Install nvidia-settings GUI
  #   package = config.boot.kernelPackages.nvidiaPackages.stable; # Driver version
  # }; # End of hardware.nvidia
  # hardware.opengl = {
  #   enable = true; # Enable OpenGL support
  #   driSupport = true; # Enable Direct Rendering
  #   driSupport32Bit = true; # Enable 32-bit support for games
  # }; # End of hardware.opengl

  # ------------------------------------------------------------------------ #
  # Intel Graphics                                                            #
  # ------------------------------------------------------------------------ #
  # Intel integrated graphics work out of the box.                            #
  # Uncomment for better video acceleration.                                  #
  # ------------------------------------------------------------------------ #
  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [ intel-media-driver vaapiVdpau ]; # Hardware acceleration
  # }; # End of Intel graphics

  # ========================================================================== #
  # GAMING                                                                     #
  # ========================================================================== #
  # Gaming-related configuration for Steam and other games.                    #
  # ========================================================================== #

  # ------------------------------------------------------------------------ #
  # Steam                                                                     #
  # ------------------------------------------------------------------------ #
  # Steam is the most popular gaming platform on Linux.                       #
  # Requires allowUnfree = true in nixpkgs config.                            #
  # ------------------------------------------------------------------------ #
  programs.steam = {
    enable = true; # Enable Steam
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for dedicated servers
  }; # End of programs.steam

  # ------------------------------------------------------------------------ #
  # Gamemode                                                                  #
  # ------------------------------------------------------------------------ #
  # Gamemode optimizes system performance while gaming.                       #
  # Automatically sets CPU governor, nice values, etc.                        #
  # ------------------------------------------------------------------------ #
  programs.gamemode.enable = true; # Enable Feral GameMode

  # ========================================================================== #
  # AUDIO                                                                      #
  # ========================================================================== #
  # Configure audio using PipeWire (modern replacement for PulseAudio).        #
  # ========================================================================== #
  security.rtkit.enable = true; # Enable realtime scheduling for audio
  services.pipewire = {
    enable = true; # Enable PipeWire audio server
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # 32-bit ALSA for games
    pulse.enable = true; # PulseAudio compatibility
    jack.enable = true; # JACK compatibility for pro audio
  }; # End of services.pipewire

  # ========================================================================== #
  # USER ACCOUNTS                                                              #
  # ========================================================================== #
  # Define user accounts on the system.                                        #
  # ========================================================================== #
  users.users = {
    # ------------------------------------------------------------------------ #
    # Primary User                                                             #
    # ------------------------------------------------------------------------ #
    # The main user account. Change "isaac" to your username.                  #
    # ------------------------------------------------------------------------ #
    isaac = {
      isNormalUser = true; # Create as a normal (non-system) user
      description = "Isaac"; # User's full name/description
      extraGroups = [
        "wheel" # Allow sudo access
        "networkmanager" # Allow network configuration
        "audio" # Audio device access
        "video" # Video device access
      ]; # End of extraGroups
    }; # End of isaac user

  }; # End of users.users

  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Additional packages for the desktop.                                       #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Gaming Tools                                                             #
    # ------------------------------------------------------------------------ #
    # Tools for gaming on Linux.                                               #
    # ------------------------------------------------------------------------ #
    mangohud # Gaming overlay showing FPS, temps, etc.
    protonup-qt # Easy Proton-GE installation for Steam
    lutris # Game launcher for non-Steam games
    heroic # Epic Games and GOG launcher

    # ------------------------------------------------------------------------ #
    # Desktop Utilities                                                        #
    # ------------------------------------------------------------------------ #
    # Useful desktop applications.                                             #
    # ------------------------------------------------------------------------ #
    vlc # Media player
    gnome-tweaks # GNOME customization tool
    
    # ------------------------------------------------------------------------ #
    # Communication                                                            #
    # ------------------------------------------------------------------------ #
    # Chat and communication apps.                                             #
    # ------------------------------------------------------------------------ #
    discord # Discord chat (uncomment if needed - unfree)
    # signal-desktop # Signal messenger (uncomment if needed)

    # ------------------------------------------------------------------------ #
    # System Tools                                                             #
    # ------------------------------------------------------------------------ #
    # System monitoring and management.                                        #
    # ------------------------------------------------------------------------ #
    htop # Process viewer
    btop # Resource monitor with graphs
    pciutils # lspci for hardware info
    usbutils # lsusb for USB devices

  ]; # End of systemPackages

  # ========================================================================== #
  # FONTS                                                                      #
  # ========================================================================== #
  # Install fonts for good typography.                                         #
  # ========================================================================== #
  fonts.packages = with pkgs; [
    noto-fonts # Google Noto fonts (wide language support)
    noto-fonts-cjk-sans # Chinese, Japanese, Korean fonts (sans-serif variant)
    noto-fonts-color-emoji # Emoji support (renamed from noto-fonts-emoji)
    liberation_ttf # Liberation fonts (metric-compatible with MS fonts)
    fira-code # Fira Code - programming font with ligatures
    jetbrains-mono # JetBrains Mono - another great programming font
  ]; # End of fonts.packages

  # ========================================================================== #
  # FIREWALL                                                                   #
  # ========================================================================== #
  # Configure firewall for desktop use.                                        #
  # ========================================================================== #
  networking.firewall = {
    enable = true; # Enable firewall
    allowedTCPPorts = [
      # Add ports for services you need
    ]; # End of allowedTCPPorts
    allowedUDPPorts = [
      # Add UDP ports for services you need
    ]; # End of allowedUDPPorts
  }; # End of networking.firewall

  # ========================================================================== #
  # SYSTEM STATE VERSION                                                       #
  # ========================================================================== #
  # DO NOT CHANGE this after initial NixOS install.                            #
  # This is used for backwards compatibility during NixOS upgrades.            #
  # ========================================================================== #
  system.stateVersion = "24.05"; # NixOS state version (do not change)

} # End of module configuration
