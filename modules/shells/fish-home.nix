# ============================================================================ #
# modules/shells/fish-home.nix - Shared Home Manager config for Fish           #
# ============================================================================ #
# This Home Manager module centrally defines the Fish user configuration       #
# by symlinking a real config.fish file from this repository into the          #
# user's ~/.config/fish/config.fish.                                           #
#                                                                             #
# Any Home Manager user that imports this module will get the same Fish        #
# configuration file.                                                          #
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
{
  # ========================================================================== #
  # FISH CONFIGURATION                                                         #
  # ========================================================================== #
  # Manage Fish's config file in ~/.config/fish/config.fish by symlinking      #
  # the version tracked in this repository.                                    #
  # ========================================================================== #
  home.file.".config/fish/config.fish".source = ./config.fish;

} # End of Home Manager configuration

