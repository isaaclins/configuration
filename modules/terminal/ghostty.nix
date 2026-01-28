# ============================================================================ #
# modules/terminal/ghostty.nix - Ghostty Terminal Configuration (NixOS)        #
# ============================================================================ #
# This module installs and configures the Ghostty terminal emulator on Linux.  #
# Ghostty is a fast, feature-rich, GPU-accelerated terminal.                   #
# NOTE: This module is for NixOS (Linux) only.                                 #
# For macOS, Ghostty is installed via Homebrew in the host config.             #
# Project: https://ghostty.org                                                 #
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
# This attribute set defines what this module adds to the system.              #
# ============================================================================ #
{
  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Install Ghostty system-wide for all users.                                 #
  # Note: ghostty may need to be installed from a flake if not in nixpkgs.     #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Ghostty Terminal                                                         #
    # ------------------------------------------------------------------------ #
    # A fast, feature-rich, GPU-accelerated terminal emulator.                 #
    # If ghostty is not yet in nixpkgs, you may need to:                       #
    # 1. Add the ghostty flake as an input in flake.nix                        #
    # 2. Use an overlay to make it available in pkgs                           #
    # ------------------------------------------------------------------------ #
    ghostty # Ghostty terminal - GPU-accelerated terminal emulator
  ]; # End of systemPackages list

  # ========================================================================== #
  # OPENGL FOR GPU ACCELERATION                                                #
  # ========================================================================== #
  # Ghostty uses GPU rendering for smooth performance.                         #
  # This ensures OpenGL/graphics drivers are available.                        #
  # ========================================================================== #
  hardware.opengl = {
    enable = true; # Enable OpenGL support for GPU-accelerated rendering
    driSupport = true; # Enable Direct Rendering Infrastructure
    driSupport32Bit = true; # Enable 32-bit DRI support (for compatibility)
  }; # End of hardware.opengl configuration

} # End of module configuration
