# ============================================================================ #
# modules/browsers/arc.nix - Arc Browser Configuration                         #
# ============================================================================ #
# This module installs and configures the Arc browser for macOS.               #
# Arc is a Chromium-based browser with a unique sidebar-based interface.       #
# NOTE: Arc is macOS-only - do not import this on Linux hosts.                 #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS/nix-darwin module

# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# This attribute set defines what this module adds to the system.              #
# ============================================================================ #
{
  # ========================================================================== #
  # HOMEBREW CASKS (macOS Application Installation)                            #
  # ========================================================================== #
  # On macOS, Arc is distributed as a .dmg application, not in nixpkgs.        #
  # We use Homebrew casks to install it, managed declaratively by nix-darwin.  #
  # This requires Homebrew to be installed on the system.                       #
  # ========================================================================== #
  homebrew = {
    # ------------------------------------------------------------------------ #
    # Enable Homebrew Integration                                              #
    # ------------------------------------------------------------------------ #
    # This tells nix-darwin to manage Homebrew packages declaratively.         #
    # Homebrew must be installed separately first (brew.sh).                   #
    # ------------------------------------------------------------------------ #
    enable = true; # Enables nix-darwin's Homebrew integration

    # ------------------------------------------------------------------------ #
    # Casks - macOS GUI Applications                                           #
    # ------------------------------------------------------------------------ #
    # Casks are Homebrew's way of installing macOS applications (.app bundles) #
    # Arc is distributed as a cask because it's a GUI application.             #
    # ------------------------------------------------------------------------ #
    casks = [
      "arc" # Arc browser - a modern Chromium-based browser with sidebar tabs
    ]; # End of casks list

    # ------------------------------------------------------------------------ #
    # Cleanup Configuration                                                    #
    # ------------------------------------------------------------------------ #
    # onActivation controls what happens when the configuration is applied.    #
    # ------------------------------------------------------------------------ #
    onActivation = {
      cleanup = "zap"; # Removes casks not listed in configuration (keeps system clean)
      autoUpdate = true; # Automatically update Homebrew when rebuilding
      upgrade = true; # Upgrade installed casks to latest versions on rebuild
    }; # End of onActivation configuration

  }; # End of homebrew configuration

} # End of module configuration
