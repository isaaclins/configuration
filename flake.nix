# ============================================================================ #
# flake.nix - Root Nix Flake Configuration                                     #
# ============================================================================ #
# This file is the entry point for all machine configurations in this repo.    #
# It defines inputs (dependencies) and outputs (system configurations).        #
# ============================================================================ #

{
  # ========================================================================== #
  # DESCRIPTION                                                                #
  # ========================================================================== #
  # A brief human-readable description of what this flake provides.            #
  # This shows up when someone runs `nix flake show` or `nix flake info`.      #
  # ========================================================================== #
  description = "Multi-machine Nix configuration for macOS and NixOS systems"; # Describes the purpose of this flake

  # ========================================================================== #
  # INPUTS                                                                     #
  # ========================================================================== #
  # Inputs are the dependencies this flake needs to build configurations.      #
  # Each input is fetched from a URL (usually a GitHub repository).            #
  # The flake.lock file pins exact versions for reproducibility.               #
  # ========================================================================== #
  inputs = {
    # ------------------------------------------------------------------------ #
    # nixpkgs - The Nix Packages Collection                                    #
    # ------------------------------------------------------------------------ #
    # This is the main package repository containing 80,000+ packages.         #
    # We use nixpkgs-unstable for the latest package versions.                 #
    # Alternative: nixos-24.05 for stable but older packages.                  #
    # ------------------------------------------------------------------------ #
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # Points to the unstable branch of nixpkgs on GitHub
    }; # End of nixpkgs input definition

    # ------------------------------------------------------------------------ #
    # nix-darwin - macOS System Configuration                                  #
    # ------------------------------------------------------------------------ #
    # nix-darwin allows managing macOS system settings declaratively.          #
    # Similar to NixOS but for macOS - manages system preferences, services.   #
    # Repository: https://github.com/LnL7/nix-darwin                           #
    # ------------------------------------------------------------------------ #
    nix-darwin = {
      url = "github:LnL7/nix-darwin"; # Points to the nix-darwin repository on GitHub
      inputs.nixpkgs.follows = "nixpkgs"; # Makes nix-darwin use our nixpkgs version instead of its own
    }; # End of nix-darwin input definition

  }; # End of inputs attribute set

  # ========================================================================== #
  # OUTPUTS                                                                    #
  # ========================================================================== #
  # Outputs define what this flake produces/exports.                           #
  # We define system configurations for each machine here.                     #
  # The function receives all inputs as arguments.                             #
  # ========================================================================== #
  outputs = { 
    self,       # Reference to this flake itself (for accessing other outputs)
    nixpkgs,    # The nixpkgs input we defined above
    nix-darwin, # The nix-darwin input we defined above
    ...         # Captures any other inputs we might add later
  }: {
    # ======================================================================== #
    # DARWIN CONFIGURATIONS (macOS)                                            #
    # ======================================================================== #
    # darwinConfigurations contains all macOS machine definitions.             #
    # Each key is the hostname used with: darwin-rebuild switch --flake .#name #
    # These use nix-darwin to manage macOS system settings.                    #
    # ======================================================================== #
    darwinConfigurations = {
      # ---------------------------------------------------------------------- #
      # Isaacs-MacBook-Pro - Primary macOS Development Workstation             #
      # ---------------------------------------------------------------------- #
      # Deploy with: darwin-rebuild switch --flake .#Isaacs-MacBook-Pro        #
      # Platform: Apple Silicon (aarch64-darwin)                               #
      # Purpose: Development workstation with full desktop software            #
      # ---------------------------------------------------------------------- #
      "Isaacs-MacBook-Pro" = nix-darwin.lib.darwinSystem { # Creates a darwin system configuration
        system = "aarch64-darwin"; # Specifies Apple Silicon architecture (M1/M2/M3 chips)
        modules = [ # List of NixOS/nix-darwin modules to include in this configuration
          ./hosts/Isaacs-MacBook-Pro/default.nix # Imports the host-specific configuration file
        ]; # End of modules list
      }; # End of Isaacs-MacBook-Pro configuration

    }; # End of darwinConfigurations attribute set

    # ======================================================================== #
    # NIXOS CONFIGURATIONS (Linux)                                             #
    # ======================================================================== #
    # nixosConfigurations contains all Linux machine definitions.              #
    # Each key is the hostname used with: nixos-rebuild switch --flake .#name  #
    # These use NixOS to manage the entire Linux system declaratively.         #
    # ======================================================================== #
    nixosConfigurations = {
      # ---------------------------------------------------------------------- #
      # homelab - Headless Linux Server                                        #
      # ---------------------------------------------------------------------- #
      # Deploy with: sudo nixos-rebuild switch --flake .#homelab               #
      # Platform: x86_64 Intel/AMD (x86_64-linux)                              #
      # Purpose: Server with NO GUI - only server essentials                   #
      # ---------------------------------------------------------------------- #
      "homelab" = nixpkgs.lib.nixosSystem { # Creates a NixOS system configuration
        system = "x86_64-linux"; # Specifies 64-bit Intel/AMD architecture
        modules = [ # List of NixOS modules to include in this configuration
          ./hosts/homelab/default.nix # Imports the host-specific configuration file
        ]; # End of modules list
      }; # End of homelab configuration

      # ---------------------------------------------------------------------- #
      # PC - Linux Desktop/Gaming Machine                                      #
      # ---------------------------------------------------------------------- #
      # Deploy with: sudo nixos-rebuild switch --flake .#PC                    #
      # Platform: x86_64 Intel/AMD (x86_64-linux)                              #
      # Purpose: Desktop with browsers, editors, gaming software               #
      # ---------------------------------------------------------------------- #
      "PC" = nixpkgs.lib.nixosSystem { # Creates a NixOS system configuration
        system = "x86_64-linux"; # Specifies 64-bit Intel/AMD architecture
        modules = [ # List of NixOS modules to include in this configuration
          ./hosts/PC/default.nix # Imports the host-specific configuration file
        ]; # End of modules list
      }; # End of PC configuration

    }; # End of nixosConfigurations attribute set

  }; # End of outputs function return value

} # End of flake attribute set
