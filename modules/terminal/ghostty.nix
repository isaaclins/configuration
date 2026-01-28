# ============================================================================ #
#
# modules/terminal/ghostty.nix - Ghostty Terminal Application Module           #
# ============================================================================ #
# This module provides an \"application layer\" for Ghostty:                    #
# - On NixOS, it installs the Ghostty terminal system-wide and enables GPU.    #
# - On any system with Home Manager (macOS or NixOS), it wires in a shared     #
#   Home Manager module that writes ~/.config/ghostty/config (background red). #
#                                                                             #
# Hosts only need to:                                                          #
#   1. Import this module in their system `imports` list                       #
#   2. Set `ghostty.enable = true;`                                            #
#                                                                             #
# Project: https://ghostty.org                                                 #
# ============================================================================ #

{ 
  config, # The current system configuration (options and values)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS/nix-darwin module

# ============================================================================ #
# OPTIONS                                                                      #
# ============================================================================ #
# Define a small options namespace for this application module.                #
# ============================================================================ #
{
  options.ghostty = {
    # ------------------------------------------------------------------------ #
    # ghostty.enable                                                            #
    # ------------------------------------------------------------------------ #
    # Turn on Ghostty (install + config) for this host.                         #
    # ------------------------------------------------------------------------ #
    enable = lib.mkEnableOption "Ghostty terminal with shared user config";

    # ------------------------------------------------------------------------ #
    # ghostty.user                                                              #
    # ------------------------------------------------------------------------ #
    # Username whose Home Manager session should get the Ghostty config.       #
    # Defaults to \"isaac\" to match this repository, but can be overridden     #
    # per host if needed.                                                       #
    # ------------------------------------------------------------------------ #
    user = lib.mkOption {
      type = lib.types.str;
      default = "isaac"; # Default primary user
      description = "Username whose Home Manager config will receive Ghostty settings.";
    };
  };

  # ========================================================================== #
  # CONFIGURATION                                                              #
  # ========================================================================== #
  # Apply system-level and user-level configuration when ghostty.enable = true #
  # ========================================================================== #
  config = lib.mkIf config.ghostty.enable (lib.mkMerge [
    # ======================================================================== #
    # NixOS SYSTEM CONFIGURATION (Linux only)                                  #
    # ======================================================================== #
    # Install Ghostty and enable GPU acceleration on Linux systems.            #
    # This part is skipped on macOS; on macOS Ghostty is installed via         #
    # Homebrew in the host configuration.                                      #
    # ======================================================================== #
    (lib.optionalAttrs pkgs.stdenv.isLinux {
      # ---------------------------------------------------------------------- #
      # System packages                                                        #
      # ---------------------------------------------------------------------- #
      environment.systemPackages = with pkgs; [
        ghostty # Ghostty terminal - GPU-accelerated terminal emulator
      ];

      # ---------------------------------------------------------------------- #
      # GPU / graphics                                                         #
      # ---------------------------------------------------------------------- #
      # On newer NixOS versions, hardware.graphics.enable is the preferred     #
      # way to turn on GPU support.                                            #
      # ---------------------------------------------------------------------- #
      hardware.graphics.enable = true; # Enable GPU support for Ghostty
    })

    # ======================================================================== #
    # HOME MANAGER USER CONFIGURATION (macOS + NixOS)                          #
    # ======================================================================== #
    # Directly manage ~/.config/ghostty/config for the selected user by        #
    # symlinking the tracked ghostty-config file from this repository.         #
    #                                                                           #
    # NOTE: This assumes that Home Manager is imported in your system          #
    # configuration (as done in flake.nix for this repo), so the               #
    # `home-manager.users` option namespace exists.                            #
    # ======================================================================== #
    {
      home-manager.users.${config.ghostty.user}.home.file.".config/ghostty/config".source =
        ./ghostty-config; # Symlink ~/.config/ghostty/config to this file
    }
  ]);

} # End of module definition

