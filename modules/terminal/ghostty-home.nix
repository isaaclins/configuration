# ============================================================================ #
# modules/terminal/ghostty-home.nix - Shared Home Manager config for Ghostty   #
# ============================================================================ #
# This Home Manager module centrally defines the Ghostty user configuration.   #
#                                                                             #
# Any Home Manager user that imports this module will get a                    #
# ~/.config/ghostty/config file with the same settings.                        #
#                                                                             #
# This keeps Ghostty config DRY across multiple machines (Mac, PC, etc.).     #
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
  # GHOSTTY CONFIGURATION                                                      #
  # ========================================================================== #
  # Manage Ghostty's config file in ~/.config/ghostty/config.                  #
  # This ensures the same settings on every rebuild for any user that          #
  # imports this module.                                                       #
  # ========================================================================== #
  home.file.".config/ghostty/config" = {
    # ------------------------------------------------------------------------ #
    # The attribute name ".config/ghostty/config" already defines the path,    #
    # so we only need to set the file content using `text`.                    #
    # ------------------------------------------------------------------------ #
    text = ''
      # Ghostty configuration managed by Home Manager (shared module)
      # Background color: bright red for easy visual confirmation
      # Color format: 6-hex-digit RGB without "#"
      background = ff0000
    ''; # End of Ghostty config file contents
  }; # End of home.file for Ghostty

} # End of Home Manager configuration

