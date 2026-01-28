# ============================================================================ #
# modules/editors/neovim.nix - Neovim Editor Configuration                     #
# ============================================================================ #
# This module installs and configures Neovim text editor.                      #
# Neovim is a modern, extensible Vim-based text editor.                        #
# Works on both macOS (nix-darwin) and Linux (NixOS).                          #
# Project: https://neovim.io                                                   #
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
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Install Neovim and related tools system-wide for all users.                #
  # environment.systemPackages is available on both NixOS and nix-darwin.      #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Neovim - The Core Editor                                                 #
    # ------------------------------------------------------------------------ #
    # Neovim is a refactor of Vim, adding modern features like:                #
    # - Built-in LSP client for IDE-like features                              #
    # - Lua scripting for configuration and plugins                            #
    # - Asynchronous job control for non-blocking operations                   #
    # - Terminal emulator built-in                                             #
    # ------------------------------------------------------------------------ #
    neovim # Neovim - hyperextensible Vim-based text editor

    # ------------------------------------------------------------------------ #
    # Tree-sitter Parsers                                                      #
    # ------------------------------------------------------------------------ #
    # Tree-sitter provides fast, accurate syntax highlighting.                 #
    # These are the compiled grammar libraries for various languages.          #
    # Neovim uses these for better syntax highlighting and code navigation.    #
    # ------------------------------------------------------------------------ #
    tree-sitter # Tree-sitter CLI and runtime library

    # ------------------------------------------------------------------------ #
    # Language Servers for LSP                                                 #
    # ------------------------------------------------------------------------ #
    # Language servers provide IDE features like:                              #
    # - Code completion, Go to definition, Find references                     #
    # - Diagnostics (errors, warnings), Code actions, Hover documentation      #
    # Install servers for languages you use; these are common ones.            #
    # ------------------------------------------------------------------------ #
    lua-language-server # Lua language server (for Neovim config files)
    nil # Nix language server (for editing .nix files)
    nodePackages.typescript-language-server # TypeScript/JavaScript LSP
    nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint LSP

    # ------------------------------------------------------------------------ #
    # Supporting Tools                                                         #
    # ------------------------------------------------------------------------ #
    # Additional tools that enhance Neovim functionality.                      #
    # These are commonly used by plugins or for development workflows.         #
    # ------------------------------------------------------------------------ #
    ripgrep # Fast grep alternative - used by telescope.nvim for searching
    fd # Fast find alternative - used by telescope.nvim for file finding
    fzf # Fuzzy finder - used by fzf.vim and other fuzzy plugins
    gcc # GNU C Compiler - needed by tree-sitter to compile parsers
    gnumake # GNU Make - needed for building some plugins

    # ------------------------------------------------------------------------ #
    # Clipboard Support                                                        #
    # ------------------------------------------------------------------------ #
    # Neovim needs a clipboard provider for system clipboard integration.      #
    # These tools enable copying/pasting between Neovim and other apps.        #
    # Note: xclip is for X11 Linux, not needed on macOS (uses pbcopy/pbpaste)  #
    # ------------------------------------------------------------------------ #
    # xclip # X11 clipboard tool (uncomment on Linux with X11)
    # wl-clipboard # Wayland clipboard tool (uncomment on Linux with Wayland)

  ]; # End of systemPackages list

  # ========================================================================== #
  # ENVIRONMENT VARIABLES                                                      #
  # ========================================================================== #
  # Set environment variables system-wide.                                     #
  # These configure default editor behavior for CLI tools.                     #
  # ========================================================================== #
  environment.variables = {
    # ------------------------------------------------------------------------ #
    # EDITOR - Default Text Editor                                             #
    # ------------------------------------------------------------------------ #
    # Many CLI tools use $EDITOR for editing files (git commit, crontab, etc.) #
    # Setting this to nvim makes Neovim the default editor system-wide.        #
    # ------------------------------------------------------------------------ #
    EDITOR = "nvim"; # Set Neovim as the default editor

    # ------------------------------------------------------------------------ #
    # VISUAL - Default Visual Editor                                           #
    # ------------------------------------------------------------------------ #
    # Some programs use $VISUAL for a "visual" editor (vs line-based).         #
    # Usually set to the same value as $EDITOR for consistency.                #
    # ------------------------------------------------------------------------ #
    VISUAL = "nvim"; # Set Neovim as the default visual editor

  }; # End of environment.variables

  # ========================================================================== #
  # SHELL ALIASES                                                              #
  # ========================================================================== #
  # Define shell aliases available system-wide.                                #
  # These provide shortcuts for common commands.                               #
  # ========================================================================== #
  environment.shellAliases = {
    # ------------------------------------------------------------------------ #
    # vim -> nvim Alias                                                        #
    # ------------------------------------------------------------------------ #
    # Many users have muscle memory for typing 'vim'.                          #
    # This alias redirects 'vim' to 'nvim' for convenience.                    #
    # ------------------------------------------------------------------------ #
    vim = "nvim"; # Redirect vim command to Neovim

    # ------------------------------------------------------------------------ #
    # vi -> nvim Alias                                                         #
    # ------------------------------------------------------------------------ #
    # Similarly, redirect 'vi' to 'nvim' for quick editing.                    #
    # ------------------------------------------------------------------------ #
    vi = "nvim"; # Redirect vi command to Neovim

    # ------------------------------------------------------------------------ #
    # v -> nvim Alias                                                          #
    # ------------------------------------------------------------------------ #
    # Even shorter alias for quick file editing.                               #
    # Usage: v filename.txt                                                    #
    # ------------------------------------------------------------------------ #
    v = "nvim"; # Short alias for Neovim

  }; # End of shellAliases

} # End of module configuration
