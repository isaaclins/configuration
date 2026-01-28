# ============================================================================ #
# hosts/PC/home.nix - Home Manager Config (NixOS Desktop)                      #
# ============================================================================ #
# This file defines per-user (home directory) configuration for Isaac          #
# on the NixOS desktop/gaming machine, managed by Home Manager.                #
#                                                                             #
# It is imported from flake.nix via:                                          #
#   home-manager.users.isaac = import ./hosts/PC/home.nix;                    #
#                                                                             #
# Here we configure user-level settings for Isaac on this PC.                 #
# Ghostty's config is imported from a shared module in                        #
# modules/terminal/ghostty-home.nix so it can be reused across hosts.         #
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
# on the NixOS desktop machine.                                                #
# ============================================================================ #
{
  # ========================================================================== #
  # BASIC USER SETTINGS                                                        #
  # ========================================================================== #
  # These describe which user this Home Manager config applies to.             #
  # They must match the Linux username and home directory.                     #
  # ========================================================================== #
  home.username = "isaac"; # NixOS account name for this user
  home.homeDirectory = "/home/isaac"; # Home directory path on NixOS

  # ========================================================================== #
  # STATE VERSION                                                              #
  # ========================================================================== #
  # Home Manager requires a state version for compatibility.                   #
  # Set this once when first creating the config; update only after reading    #
  # the Home Manager release notes.                                            #
  # ========================================================================== #
  home.stateVersion = "24.05"; # Home Manager state version (do not change lightly)

} # End of Home Manager configuration

