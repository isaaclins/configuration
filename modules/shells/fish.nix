# ============================================================================ #
# modules/shells/fish.nix - Fish Shell Configuration                           #
# ============================================================================ #
# This module installs and configures the Fish shell with zoxide.              #
# Fish is a user-friendly shell with autosuggestions and syntax highlighting.  #
# Zoxide is a smarter cd command that learns your habits.                      #
# Works on both macOS (nix-darwin) and Linux (NixOS).                          #
# Project: https://fishshell.com, https://github.com/ajeetdsouza/zoxide        #
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
  # FISH SHELL PROGRAM                                                         #
  # ========================================================================== #
  # programs.fish enables and configures the Fish shell system-wide.           #
  # This is available on both NixOS and nix-darwin.                            #
  # ========================================================================== #
  programs.fish = {
    # ------------------------------------------------------------------------ #
    # Enable Fish Shell                                                        #
    # ------------------------------------------------------------------------ #
    # This adds fish to the system and registers it as a valid login shell.    #
    # On NixOS, it adds fish to /etc/shells automatically.                     #
    # ------------------------------------------------------------------------ #
    enable = true; # Enable the Fish shell system-wide

    # ------------------------------------------------------------------------ #
    # Shell Initialization                                                     #
    # ------------------------------------------------------------------------ #
    # interactiveShellInit runs when an interactive shell starts.              #
    # This is where we initialize zoxide and set up other shell configs.       #
    # ------------------------------------------------------------------------ #
    interactiveShellInit = ''
      # ====================================================================== #
      # Fish Shell Interactive Initialization                                  #
      # ====================================================================== #
      # This code runs every time a new interactive Fish shell starts.         #
      # ====================================================================== #

      # ---------------------------------------------------------------------- #
      # Zoxide Initialization                                                  #
      # ---------------------------------------------------------------------- #
      # Initialize zoxide with Fish shell integration.                         #
      # This creates the 'z' command for smart directory jumping.              #
      # Usage: z <partial-path> to jump to frequently used directories.        #
      # ---------------------------------------------------------------------- #
      zoxide init fish | source # Initialize zoxide and source its config

      # ---------------------------------------------------------------------- #
      # Greeting Suppression                                                   #
      # ---------------------------------------------------------------------- #
      # Disable the default Fish greeting message.                             #
      # This gives a cleaner shell startup experience.                         #
      # ---------------------------------------------------------------------- #
      set -g fish_greeting "" # Set greeting to empty string (no greeting)

      # ---------------------------------------------------------------------- #
      # Color Configuration                                                    #
      # ---------------------------------------------------------------------- #
      # Enable 24-bit true color support in Fish.                              #
      # This allows themes and syntax highlighting to use full color range.    #
      # ---------------------------------------------------------------------- #
      set -gx COLORTERM truecolor # Enable true color support
    ''; # End of interactiveShellInit

    # ------------------------------------------------------------------------ #
    # Shell Aliases                                                            #
    # ------------------------------------------------------------------------ #
    # Define shell aliases specific to Fish.                                   #
    # These are available in all Fish shell sessions.                          #
    # ------------------------------------------------------------------------ #
    shellAliases = {
      # ---------------------------------------------------------------------- #
      # Directory Navigation Aliases                                           #
      # ---------------------------------------------------------------------- #
      # Common shortcuts for navigating the filesystem quickly.                #
      # ---------------------------------------------------------------------- #
      ".." = "cd .."; # Go up one directory
      "..." = "cd ../.."; # Go up two directories
      "...." = "cd ../../.."; # Go up three directories

      # ---------------------------------------------------------------------- #
      # List Directory Aliases                                                 #
      # ---------------------------------------------------------------------- #
      # Enhanced ls commands for better file listing.                          #
      # Uses eza if available (modern ls replacement), falls back to ls.       #
      # ---------------------------------------------------------------------- #
      ll = "ls -la"; # Long listing with hidden files
      la = "ls -a"; # List all files including hidden
      l = "ls -l"; # Long listing format

      # ---------------------------------------------------------------------- #
      # Safety Aliases                                                         #
      # ---------------------------------------------------------------------- #
      # Add confirmation prompts to dangerous commands.                        #
      # Prevents accidental deletion or overwriting of files.                  #
      # ---------------------------------------------------------------------- #
      rm = "rm -i"; # Prompt before removing files
      mv = "mv -i"; # Prompt before overwriting files
      cp = "cp -i"; # Prompt before overwriting files

      # ---------------------------------------------------------------------- #
      # Zoxide Aliases                                                         #
      # ---------------------------------------------------------------------- #
      # Convenient aliases for zoxide commands.                                #
      # ---------------------------------------------------------------------- #
      cd = "z"; # Replace cd with zoxide's z command
      cdi = "zi"; # Interactive zoxide selection with fzf

    }; # End of shellAliases

  }; # End of programs.fish

  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Install Fish-related packages system-wide.                                 #
  # These enhance the Fish shell experience.                                   #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Zoxide - Smarter cd Command                                              #
    # ------------------------------------------------------------------------ #
    # Zoxide tracks your most used directories and lets you jump to them.      #
    # Instead of typing full paths, use: z <partial-name>                      #
    # It learns from your cd habits and ranks directories by frequency.        #
    # ------------------------------------------------------------------------ #
    zoxide # A smarter cd command that learns your habits

    # ------------------------------------------------------------------------ #
    # Starship - Cross-Shell Prompt                                            #
    # ------------------------------------------------------------------------ #
    # Starship is a fast, customizable prompt for any shell.                   #
    # It shows git status, programming language versions, and more.            #
    # Note: You'll need to add 'starship init fish | source' to fish config.   #
    # ------------------------------------------------------------------------ #
    starship # Minimal, blazing-fast, customizable prompt

    # ------------------------------------------------------------------------ #
    # Eza - Modern ls Replacement                                              #
    # ------------------------------------------------------------------------ #
    # Eza (formerly exa) is a modern replacement for ls.                       #
    # It has colors, icons, git integration, and better defaults.              #
    # ------------------------------------------------------------------------ #
    eza # Modern replacement for ls with colors and icons

    # ------------------------------------------------------------------------ #
    # Bat - Cat with Syntax Highlighting                                       #
    # ------------------------------------------------------------------------ #
    # Bat is a cat clone with syntax highlighting and git integration.         #
    # Makes viewing files in the terminal much more pleasant.                  #
    # ------------------------------------------------------------------------ #
    bat # Cat clone with syntax highlighting and git integration

    # ------------------------------------------------------------------------ #
    # FZF - Fuzzy Finder                                                       #
    # ------------------------------------------------------------------------ #
    # FZF is a command-line fuzzy finder used by many tools.                   #
    # Enables Ctrl+R for fuzzy history search in Fish.                         #
    # Also used by zoxide for interactive directory selection (zi).            #
    # ------------------------------------------------------------------------ #
    fzf # Command-line fuzzy finder

  ]; # End of systemPackages list

} # End of module configuration
