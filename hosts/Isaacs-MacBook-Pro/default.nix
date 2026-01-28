# ============================================================================ #
# hosts/Isaacs-MacBook-Pro/default.nix - macOS Workstation Configuration       #
# ============================================================================ #
# This is the main configuration file for Isaac's MacBook Pro.                 #
# It imports shared modules and defines machine-specific settings.             #
# Platform: Apple Silicon (aarch64-darwin) running nix-darwin.                 #
# Purpose: Primary development workstation with full desktop software.         #
# ============================================================================ #
# DEPLOYMENT:                                                                  #
# darwin-rebuild switch --flake ~/.config/nix/configuration#Isaacs-MacBook-Pro      #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a nix-darwin module

# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# This attribute set defines the complete system configuration.                #
# ============================================================================ #
{
  # ========================================================================== #
  # IMPORTS - Shared Modules                                                   #
  # ========================================================================== #
  # Import only the modules this machine needs.                                #
  # This is the key to the modular design - pick and choose features.          #
  # ========================================================================== #
  imports = [
    # ------------------------------------------------------------------------ #
    # Browser - Arc                                                            #
    # ------------------------------------------------------------------------ #
    # Arc browser for macOS - a modern Chromium-based browser.                 #
    # Installed via Homebrew cask.                                             #
    # ------------------------------------------------------------------------ #
    ../../modules/browsers/arc.nix # Import Arc browser module

    # ------------------------------------------------------------------------ #
    # NOTE: Ghostty is installed via Homebrew casks below (macOS-specific).    #
    # The ghostty.nix module is for NixOS (Linux) only.                        #
    # ------------------------------------------------------------------------ #

    # ------------------------------------------------------------------------ #
    # Editor - Neovim                                                          #
    # ------------------------------------------------------------------------ #
    # Neovim with LSP support for development.                                 #
    # Includes language servers and supporting tools.                          #
    # ------------------------------------------------------------------------ #
    ../../modules/editors/neovim.nix # Import Neovim editor module

    # ------------------------------------------------------------------------ #
    # Shell - Fish                                                             #
    # ------------------------------------------------------------------------ #
    # Fish shell with zoxide for smart directory navigation.                   #
    # Includes starship prompt, eza, bat, and fzf.                             #
    # ------------------------------------------------------------------------ #
    ../../modules/shells/fish.nix # Import Fish shell module

    # ------------------------------------------------------------------------ #
    # Development - Git                                                        #
    # ------------------------------------------------------------------------ #
    # Git with GitHub CLI, lazygit, delta, and other dev tools.                #
    # Comprehensive shell aliases for Git operations.                          #
    # ------------------------------------------------------------------------ #
    ../../modules/development/git.nix # Import Git development module

    # ------------------------------------------------------------------------ #
    # NOTE: Docker module is for NixOS (Linux) only.                           #
    # For macOS, install Docker Desktop via Homebrew casks above.              #
    # Add "docker" to the casks list if you need Docker on this Mac.           #
    # ------------------------------------------------------------------------ #

  ]; # End of imports list

  # ========================================================================== #
  # NIX CONFIGURATION                                                          #
  # ========================================================================== #
  # Configure the Nix package manager settings.                                #
  # ========================================================================== #
  nix = {
    # ------------------------------------------------------------------------ #
    # Experimental Features                                                    #
    # ------------------------------------------------------------------------ #
    # Enable flakes and the new nix command.                                   #
    # Required for using this flake-based configuration.                       #
    # ------------------------------------------------------------------------ #
    settings.experimental-features = [
      "nix-command" # Enable the new nix CLI commands (nix build, nix develop)
      "flakes" # Enable flakes for reproducible Nix configurations
    ]; # End of experimental-features

  }; # End of nix configuration

  # ========================================================================== #
  # NIXPKGS CONFIGURATION                                                      #
  # ========================================================================== #
  # Configure the nixpkgs settings.                                            #
  # ========================================================================== #
  nixpkgs = {
    # ------------------------------------------------------------------------ #
    # Host Platform                                                            #
    # ------------------------------------------------------------------------ #
    # Specify the system architecture for this machine.                        #
    # aarch64-darwin = Apple Silicon (M1/M2/M3) macOS                          #
    # ------------------------------------------------------------------------ #
    hostPlatform = "aarch64-darwin"; # Apple Silicon architecture

    # ------------------------------------------------------------------------ #
    # Allow Unfree Packages                                                    #
    # ------------------------------------------------------------------------ #
    # Some packages have non-free licenses (VSCode, Chrome, etc.).             #
    # Enable this to allow installing unfree packages.                         #
    # ------------------------------------------------------------------------ #
    config.allowUnfree = true; # Allow packages with unfree licenses

  }; # End of nixpkgs configuration

  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Additional packages specific to this machine (not in shared modules).      #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Development Tools                                                        #
    # ------------------------------------------------------------------------ #
    # Programming languages and development utilities.                         #
    # Add languages and tools you use for development here.                    #
    # ------------------------------------------------------------------------ #
    # nodejs # Node.js JavaScript runtime (uncomment if needed)
    # python3 # Python 3 interpreter (uncomment if needed)
    # rustup # Rust toolchain installer (uncomment if needed)
    # go # Go programming language (uncomment if needed)

    # ------------------------------------------------------------------------ #
    # Utilities                                                                #
    # ------------------------------------------------------------------------ #
    # General utilities not included in the shared modules.                    #
    # ------------------------------------------------------------------------ #
    coreutils # GNU core utilities (ls, cat, etc. - GNU versions)
    findutils # GNU find utilities (find, xargs, locate)

  ]; # End of systemPackages list

  # ========================================================================== #
  # HOMEBREW CONFIGURATION                                                     #
  # ========================================================================== #
  # Additional Homebrew packages specific to this machine.                     #
  # Modules may already add some casks; this extends that list.                #
  # ========================================================================== #
  homebrew = {
    enable = true; # Enable Homebrew integration

    # ------------------------------------------------------------------------ #
    # Homebrew Taps                                                            #
    # ------------------------------------------------------------------------ #
    # Third-party repositories for additional formulas and casks.              #
    # ------------------------------------------------------------------------ #
    taps = [
      # "homebrew/cask-fonts" # Font casks (uncomment for Nerd Fonts, etc.)
    ]; # End of taps

    # ------------------------------------------------------------------------ #
    # Homebrew Formulas (CLI tools)                                            #
    # ------------------------------------------------------------------------ #
    # Command-line tools installed via Homebrew.                               #
    # Prefer nixpkgs when available; use Homebrew for macOS-specific tools.    #
    # ------------------------------------------------------------------------ #
    brews = [
      # "mas" # Mac App Store CLI (uncomment to manage App Store apps)
    ]; # End of brews

    # ------------------------------------------------------------------------ #
    # Homebrew Casks (GUI applications)                                        #
    # ------------------------------------------------------------------------ #
    # macOS applications installed via Homebrew casks.                         #
    # Note: Arc is added by the arc.nix module.                                #
    # ------------------------------------------------------------------------ #
    casks = [
      "ghostty" # Ghostty terminal - fast, GPU-accelerated terminal emulator
      # "visual-studio-code" # VSCode (uncomment if you use VSCode)
      # "discord" # Discord chat (uncomment if needed)
      # "slack" # Slack chat (uncomment if needed)
      # "spotify" # Spotify music (uncomment if needed)
      # "rectangle" # Window manager (uncomment if needed)
      # "raycast" # Spotlight replacement (uncomment if needed)
    ]; # End of casks

    # ------------------------------------------------------------------------ #
    # Cleanup Policy                                                           #
    # ------------------------------------------------------------------------ #
    # Control what happens to packages not in this configuration.              #
    # "zap" removes everything not listed; "uninstall" just removes formulas.  #
    # ------------------------------------------------------------------------ #
    onActivation = {
      cleanup = "zap"; # Remove casks/formulas not in configuration
      autoUpdate = true; # Update Homebrew on darwin-rebuild
      upgrade = true; # Upgrade packages on darwin-rebuild
    }; # End of onActivation

  }; # End of homebrew configuration

  # ========================================================================== #
  # MACOS SYSTEM PREFERENCES                                                   #
  # ========================================================================== #
  # Configure macOS system settings declaratively.                             #
  # These replace clicking through System Preferences.                         #
  # ========================================================================== #
  system.defaults = {
    # ------------------------------------------------------------------------ #
    # Dock Settings                                                            #
    # ------------------------------------------------------------------------ #
    # Configure the macOS Dock behavior and appearance.                        #
    # ------------------------------------------------------------------------ #
    dock = {
      autohide = true; # Automatically hide the Dock
      autohide-delay = 0.0; # No delay before Dock hides
      autohide-time-modifier = 0.5; # Animation speed for hiding (0.5 = faster)
      orientation = "bottom"; # Dock position: "bottom", "left", or "right"
      show-recents = false; # Don't show recent apps in Dock
      tilesize = 48; # Icon size in pixels
      mineffect = "scale"; # Minimize animation: "genie" or "scale"
      mru-spaces = false; # Don't reorder Spaces based on recent use
    }; # End of dock settings

    # ------------------------------------------------------------------------ #
    # Finder Settings                                                          #
    # ------------------------------------------------------------------------ #
    # Configure Finder behavior and display options.                           #
    # ------------------------------------------------------------------------ #
    finder = {
      AppleShowAllExtensions = true; # Show all file extensions
      AppleShowAllFiles = true; # Show hidden files
      FXDefaultSearchScope = "SCcf"; # Search current folder by default
      FXEnableExtensionChangeWarning = false; # No warning when changing extensions
      FXPreferredViewStyle = "Nlsv"; # Default view: "icnv", "clmv", "Flwv", "Nlsv" (list)
      ShowPathbar = true; # Show path bar at bottom
      ShowStatusBar = true; # Show status bar at bottom
      _FXShowPosixPathInTitle = true; # Show full path in Finder title
    }; # End of finder settings

    # ------------------------------------------------------------------------ #
    # Trackpad Settings                                                        #
    # ------------------------------------------------------------------------ #
    # Configure trackpad gestures and behavior.                                #
    # ------------------------------------------------------------------------ #
    trackpad = {
      Clicking = true; # Enable tap to click
      TrackpadRightClick = true; # Enable two-finger right click
      TrackpadThreeFingerDrag = true; # Enable three-finger drag
    }; # End of trackpad settings

    # ------------------------------------------------------------------------ #
    # NSGlobalDomain - Global System Preferences                               #
    # ------------------------------------------------------------------------ #
    # System-wide preferences that affect multiple applications.               #
    # ------------------------------------------------------------------------ #
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # Use dark mode
      ApplePressAndHoldEnabled = false; # Disable press-and-hold for key repeat
      InitialKeyRepeat = 15; # Delay before key repeat starts (lower = faster)
      KeyRepeat = 2; # Key repeat rate (lower = faster)
      NSAutomaticCapitalizationEnabled = false; # Disable auto-capitalization
      NSAutomaticDashSubstitutionEnabled = false; # Disable smart dashes
      NSAutomaticQuoteSubstitutionEnabled = false; # Disable smart quotes
      NSAutomaticSpellingCorrectionEnabled = false; # Disable auto-correct
    }; # End of NSGlobalDomain settings

    # ------------------------------------------------------------------------ #
    # Screencapture Settings                                                   #
    # ------------------------------------------------------------------------ #
    # Configure screenshot behavior.                                           #
    # ------------------------------------------------------------------------ #
    screencapture = {
      location = "~/Desktop"; # Save screenshots to Desktop
      type = "png"; # Screenshot format: "png", "jpg", "pdf", "tiff"
      disable-shadow = true; # Don't include window shadow in screenshots
    }; # End of screencapture settings

  }; # End of system.defaults

  # ========================================================================== #
  # KEYBOARD SHORTCUTS                                                         #
  # ========================================================================== #
  # Configure custom keyboard shortcuts.                                       #
  # ========================================================================== #
  system.keyboard = {
    enableKeyMapping = true; # Enable custom key mappings
    remapCapsLockToEscape = true; # Map Caps Lock to Escape (Vim users)
  }; # End of system.keyboard

  # ========================================================================== #
  # SECURITY SETTINGS                                                          #
  # ========================================================================== #
  # Configure macOS security settings.                                         #
  # ========================================================================== #
  security.pam.services.sudo_local.touchIdAuth = true; # Allow Touch ID for sudo (renamed option)

  # ========================================================================== #
  # PRIMARY USER                                                               #
  # ========================================================================== #
  # nix-darwin now applies certain options (Homebrew, system.defaults, etc.)   #
  # to a primary user instead of the user running darwin-rebuild.              #
  # Set this to your macOS username.                                           #
  # ========================================================================== #
  system.primaryUser = "isaac"; # Primary user for nix-darwin-managed settings

  # ========================================================================== #
  # SYSTEM STATE VERSION                                                       #
  # ========================================================================== #
  # DO NOT CHANGE this after initial setup.                                    #
  # This is used for backwards compatibility during nix-darwin upgrades.       #
  # ========================================================================== #
  system.stateVersion = 4; # nix-darwin state version (do not change)

} # End of module configuration
