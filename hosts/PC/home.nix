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
# on the NixOS desktop machine.                                                #
# ============================================================================ #
{
  # ========================================================================== #
  # BASIC USER SETTINGS                                                        #
  # ========================================================================== #
  # Set from primaryUser. Use mkForce so we override home-manager's lookup     #
  # (which can be null when the user does not exist on the system yet).        #
  # ========================================================================== #
  home.username = primaryUser;
  home.homeDirectory = lib.mkForce "/home/${primaryUser}";

  # ========================================================================== #
  # STATE VERSION                                                              #
  # ========================================================================== #
  # Home Manager requires a state version for compatibility.                   #
  # Set this once when first creating the config; update only after reading    #
  # the Home Manager release notes.                                            #
  # ========================================================================== #
  home.stateVersion = "24.05"; # Home Manager state version (do not change lightly)

} # End of Home Manager configuration

