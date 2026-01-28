# ============================================================================ #
# modules/browsers/zen.nix - Zen Browser Configuration                         #
# ============================================================================ #
# This module installs and configures the Zen browser for Linux.               #
# Zen is a Firefox-based privacy-focused browser with a clean interface.       #
# NOTE: This module is for Linux (NixOS) - not for macOS.                      #
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
  # environment.systemPackages installs packages system-wide for all users.    #
  # These packages are available in the system PATH.                           #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Zen Browser                                                              #
    # ------------------------------------------------------------------------ #
    # Zen is a privacy-focused browser based on Firefox.                       #
    # It features a clean, minimal interface and enhanced privacy settings.    #
    # Package: https://github.com/nicgirault/zen-browser                       #
    # Note: If zen-browser is not in nixpkgs, you may need to add a flake     #
    # input for the Zen browser overlay or use an alternative package.         #
    # ------------------------------------------------------------------------ #
    # TODO: zen-browser may need to be installed via a custom flake input     #
    # For now, we'll use firefox as a fallback and document the zen setup     #
    # ------------------------------------------------------------------------ #
    firefox # Firefox browser - fallback until zen-browser is in nixpkgs
    # Uncomment the line below when zen-browser is available in nixpkgs:
    # zen-browser # Zen browser - Firefox-based privacy browser
  ]; # End of systemPackages list

  # ========================================================================== #
  # FIREFOX/ZEN CONFIGURATION                                                  #
  # ========================================================================== #
  # NixOS provides a programs.firefox module for additional configuration.     #
  # This sets up Firefox/Zen with sensible defaults for privacy.               #
  # ========================================================================== #
  programs.firefox = {
    enable = true; # Enable the Firefox program module for additional config

    # ------------------------------------------------------------------------ #
    # Policies Configuration                                                   #
    # ------------------------------------------------------------------------ #
    # Firefox policies allow enterprise-style configuration.                   #
    # These settings are applied to Firefox on startup.                        #
    # ------------------------------------------------------------------------ #
    policies = {
      # ---------------------------------------------------------------------- #
      # Privacy Settings                                                       #
      # ---------------------------------------------------------------------- #
      DisableTelemetry = true; # Disable sending usage data to Mozilla
      DisableFirefoxStudies = true; # Disable Mozilla's A/B testing studies
      DisablePocket = true; # Disable the Pocket integration (read-it-later)

      # ---------------------------------------------------------------------- #
      # Security Settings                                                      #
      # ---------------------------------------------------------------------- #
      EnableTrackingProtection = {
        Value = true; # Enable Enhanced Tracking Protection
        Locked = true; # Prevent users from disabling it
        Cryptomining = true; # Block cryptomining scripts
        Fingerprinting = true; # Block fingerprinting attempts
      }; # End of EnableTrackingProtection

      # ---------------------------------------------------------------------- #
      # Search Settings                                                        #
      # ---------------------------------------------------------------------- #
      # Remove sponsored suggestions and use a privacy-respecting search       #
      # ---------------------------------------------------------------------- #
      FirefoxSuggest = {
        WebSuggestions = false; # Disable web suggestions (privacy concern)
        SponsoredSuggestions = false; # Disable sponsored suggestions
        ImproveSuggest = false; # Don't send data to improve suggestions
      }; # End of FirefoxSuggest

    }; # End of policies

  }; # End of programs.firefox

} # End of module configuration
