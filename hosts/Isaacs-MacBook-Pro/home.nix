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
  config,      # The current Home Manager configuration (options and values)
  pkgs,        # The nixpkgs package set available to Home Manager
  lib,         # Nix library functions (for conditionals, types, etc.)
  primaryUser, # Primary username (passed from flake via extraSpecialArgs)
  ...          # Allows other arguments to pass through (future compatibility)
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
  # Set from primaryUser (current user; default "isaaclins" if unset).         #
  # ========================================================================== #
  home.username = primaryUser;
  home.homeDirectory = "/Users/${primaryUser}";

  # ========================================================================== #
  # STATE VERSION                                                              #
  # ========================================================================== #
  # Home Manager requires a state version for compatibility.                   #
  # Set this once when first creating the config; update only after reading    #
  # the Home Manager release notes.                                            #
  # ========================================================================== #
  home.stateVersion = "24.05"; # Home Manager state version (do not change lightly)

} # End of Home Manager configuration

