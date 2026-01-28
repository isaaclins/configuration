# ============================================================================ #
#
# modules/shells/fish.nix - Fish Shell Application Module                      #
# ============================================================================ #
# This module provides an \"application layer\" for Fish:                       #
# - On NixOS and macOS, it enables the Fish shell and installs related tools.  #
# - For a given Home Manager user, it wires in a shared Fish config file      #
#   (modules/shells/config.fish) by symlinking it to                          #
#   ~/.config/fish/config.fish.                                               #
#                                                                             #
# Hosts only need to:                                                          #
#   1. Import this module in their system `imports` list                       #
#   2. Set `fish.enable = true;`                                              #
#                                                                             #
# Projects:                                                                   #
# - Fish: https://fishshell.com                                               #
# - Zoxide: https://github.com/ajeetdsouza/zoxide                             #
# - Starship: https://starship.rs                                             #
# ============================================================================ #

{ 
  config, # The current system configuration (options and values)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS/nix-darwin module

let
  inherit (lib) mkEnableOption mkIf;
in

# ============================================================================ #
# OPTIONS                                                                      #
# ============================================================================ #
{
  options.fish = {
    # ------------------------------------------------------------------------ #
    # fish.enable                                                              #
    # ------------------------------------------------------------------------ #
    # Turn on the Fish shell application module for this host.                 #
    # ------------------------------------------------------------------------ #
    enable = mkEnableOption "Fish shell with shared user config";

    # ------------------------------------------------------------------------ #
    # fish.user                                                                #
    # ------------------------------------------------------------------------ #
    # Username whose Home Manager session should get the Fish config.          #
    # Defaults to \"isaac\" to match this repository, but can be overridden     #
    # per host if needed.                                                       #
    # ------------------------------------------------------------------------ #
    user = lib.mkOption {
      type = lib.types.str;
      default = "isaac"; # Default primary user
      description = "Username whose Home Manager config will receive Fish settings.";
    };
  };

  # ========================================================================== #
  # CONFIGURATION                                                              #
  # ========================================================================== #
  # Apply system-level and user-level configuration when fish.enable = true    #
  # ========================================================================== #
  config = mkIf config.fish.enable {
    # ======================================================================== #
    # SYSTEM-LEVEL FISH CONFIGURATION (NixOS + macOS)                          #
    # ======================================================================== #
    programs.fish = {
      enable = true; # Enable the Fish shell system-wide

      # Shell initialization (runs on every interactive Fish shell)
      interactiveShellInit = ''
        # Zoxide initialization (smart cd)
        if type -q zoxide
          zoxide init fish | source
        end

        # Enable truecolor for better themes
        set -gx COLORTERM truecolor
      '';

      # Shell aliases available in all Fish sessions
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        ll = "ls -la";
        la = "ls -a";
        l = "ls -l";

        rm = "rm -i";
        mv = "mv -i";
        cp = "cp -i";

        cd = "z";  # Use zoxide for cd
        cdi = "zi"; # Interactive zoxide selection
      };
    };

    # System packages that enhance the Fish experience
    environment.systemPackages = with pkgs; [
      zoxide   # Smarter cd
      starship # Prompt
      eza      # Modern ls
      bat      # cat with syntax highlighting
      fzf      # Fuzzy finder
    ];

    # ======================================================================== #
    # HOME MANAGER USER CONFIGURATION (macOS + NixOS)                          #
    # ======================================================================== #
    # Directly manage ~/.config/fish/config.fish for the selected user by      #
    # symlinking the tracked config.fish file from this repository.           #
    # ======================================================================== #
    home-manager.users.${config.fish.user}.home.file.".config/fish/config.fish".source =
      ../../modules/shells/config.fish;
  };

} # End of module definition
