# ============================================================================ #
# hosts/Isaacs-MacBook-Pro/home.nix - Home Manager Config (macOS)              #
# ============================================================================ #
# This file defines per-user (home directory) configuration for Isaac          #
# on the macOS workstation, managed by Home Manager.                           #
#                                                                             #
# It is imported from flake.nix via:                                          #
#   home-manager.users.isaac = import ./hosts/Isaacs-MacBook-Pro/home.nix;    #
#                                                                             #
# Here we configure user-level settings for Isaac on this Mac.                #
# ============================================================================ #

{ 
  config, # The current Home Manager configuration (options and values)
  pkgs,   # The nixpkgs package set available to Home Manager
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a Home Manager module

# ============================================================================ #
# HOME MANAGER CONFIGURATION                                                   #
# ============================================================================ #
# This attribute set defines the user-level configuration for Isaac            #
# on the macOS machine.                                                        #
# ============================================================================ #
{
  # ========================================================================== #
  # BASIC USER SETTINGS                                                        #
  # ========================================================================== #
  # These describe which user this Home Manager config applies to.             #
  # They must match the macOS username and home directory.                     #
  # ========================================================================== #
  home.username = "isaac"; # macOS account name for this user
  home.homeDirectory = "/Users/isaac"; # Home directory path on macOS

  # ========================================================================== #
  # STATE VERSION                                                              #
  # ========================================================================== #
  # Home Manager requires a state version for compatibility.                   #
  # Set this once when first creating the config; update only after reading    #
  # the Home Manager release notes.                                            #
  # ========================================================================== #
  home.stateVersion = "24.05"; # Home Manager state version (do not change lightly)

} # End of Home Manager configuration

