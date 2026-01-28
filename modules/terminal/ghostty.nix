# ============================================================================ #
# modules/terminal/ghostty.nix - Ghostty Terminal Configuration                #
# ============================================================================ #
# This module installs and configures the Ghostty terminal emulator.           #
# Ghostty is a fast, feature-rich, GPU-accelerated terminal.                   #
# Works on both macOS (via Homebrew) and Linux (via nixpkgs).                  #
# Project: https://ghostty.org                                                 #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS/nix-darwin module

# ============================================================================ #
# PLATFORM DETECTION                                                           #
# ============================================================================ #
# We need to detect if we're on macOS or Linux to use the right install method #
# pkgs.stdenv.isDarwin is true on macOS, false on Linux                        #
# ============================================================================ #
let
  # -------------------------------------------------------------------------- #
  # isDarwin - Platform Detection Variable                                     #
  # -------------------------------------------------------------------------- #
  # This boolean is true on macOS (Darwin) and false on Linux.                 #
  # We use this to conditionally apply macOS or Linux specific settings.       #
  # -------------------------------------------------------------------------- #
  isDarwin = pkgs.stdenv.isDarwin; # true on macOS, false on Linux

in # 'in' begins the expression that uses the 'let' bindings above
# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# This attribute set defines what this module adds to the system.              #
# We use lib.mkMerge to combine platform-specific configurations.              #
# ============================================================================ #
lib.mkMerge [
  # ========================================================================== #
  # COMMON CONFIGURATION (Both Platforms)                                      #
  # ========================================================================== #
  # Settings that apply to both macOS and Linux.                               #
  # Currently empty but ready for cross-platform configs like keybindings.     #
  # ========================================================================== #
  {
    # Placeholder for shared configuration
    # You can add environment variables or shell aliases here
  } # End of common configuration

  # ========================================================================== #
  # MACOS CONFIGURATION (nix-darwin)                                           #
  # ========================================================================== #
  # On macOS, Ghostty is installed via Homebrew cask.                          #
  # lib.optionalAttrs returns {} on Linux, so homebrew won't be referenced.    #
  # ========================================================================== #
  (lib.optionalAttrs isDarwin {
    # ------------------------------------------------------------------------ #
    # Homebrew Cask Installation                                               #
    # ------------------------------------------------------------------------ #
    # Ghostty is distributed as a macOS app bundle (.app).                     #
    # Homebrew casks are the standard way to install GUI apps on macOS.        #
    # ------------------------------------------------------------------------ #
    homebrew = {
      enable = true; # Enable nix-darwin's Homebrew integration
      casks = [
        "ghostty" # Ghostty terminal - GPU-accelerated terminal emulator
      ]; # End of casks list
    }; # End of homebrew configuration
  }) # End of macOS configuration

  # ========================================================================== #
  # LINUX CONFIGURATION (NixOS)                                                #
  # ========================================================================== #
  # On Linux, Ghostty can be installed from nixpkgs or built from source.      #
  # lib.optionalAttrs returns {} on macOS, so hardware.opengl won't be used.   #
  # ========================================================================== #
  (lib.optionalAttrs (!isDarwin) {
    # ------------------------------------------------------------------------ #
    # System Packages Installation                                             #
    # ------------------------------------------------------------------------ #
    # Install Ghostty system-wide for all users.                               #
    # Note: ghostty may need to be installed from a flake if not in nixpkgs.   #
    # ------------------------------------------------------------------------ #
    environment.systemPackages = with pkgs; [
      # ---------------------------------------------------------------------- #
      # Ghostty Terminal                                                       #
      # ---------------------------------------------------------------------- #
      # A fast, feature-rich, GPU-accelerated terminal emulator.               #
      # If ghostty is not yet in nixpkgs, you may need to:                     #
      # 1. Add the ghostty flake as an input in flake.nix                      #
      # 2. Use an overlay to make it available in pkgs                         #
      # ---------------------------------------------------------------------- #
      ghostty # Ghostty terminal - GPU-accelerated terminal emulator
    ]; # End of systemPackages list

    # ------------------------------------------------------------------------ #
    # Enable OpenGL for GPU Acceleration                                       #
    # ------------------------------------------------------------------------ #
    # Ghostty uses GPU rendering for smooth performance.                       #
    # This ensures OpenGL/graphics drivers are available.                      #
    # ------------------------------------------------------------------------ #
    hardware.opengl = {
      enable = true; # Enable OpenGL support for GPU-accelerated rendering
      driSupport = true; # Enable Direct Rendering Infrastructure
      driSupport32Bit = true; # Enable 32-bit DRI support (for compatibility)
    }; # End of hardware.opengl configuration

  }) # End of Linux configuration

] # End of lib.mkMerge list
