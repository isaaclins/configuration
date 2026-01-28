# ============================================================================ #
# modules/development/git.nix - Git Version Control Configuration              #
# ============================================================================ #
# This module installs and configures Git and GitHub CLI tools.                #
# Git is the de facto standard for version control.                            #
# GitHub CLI (gh) provides GitHub integration from the command line.           #
# Works on both macOS (nix-darwin) and Linux (NixOS).                          #
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
  # Install Git and related tools system-wide for all users.                   #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Git - Version Control System                                             #
    # ------------------------------------------------------------------------ #
    # Git is a distributed version control system.                             #
    # Essential for tracking changes, collaborating, and managing code.        #
    # Project: https://git-scm.com                                             #
    # ------------------------------------------------------------------------ #
    git # Distributed version control system

    # ------------------------------------------------------------------------ #
    # GitHub CLI - Command Line Interface for GitHub                           #
    # ------------------------------------------------------------------------ #
    # gh provides GitHub functionality from the terminal:                      #
    # - Create/view pull requests and issues                                   #
    # - Clone repositories, manage releases                                    #
    # - Authenticate with GitHub (gh auth login)                               #
    # Project: https://cli.github.com                                          #
    # ------------------------------------------------------------------------ #
    gh # GitHub CLI for interacting with GitHub from terminal

    # ------------------------------------------------------------------------ #
    # Git-LFS - Large File Storage                                             #
    # ------------------------------------------------------------------------ #
    # Git LFS handles large files in Git repositories.                         #
    # Stores large files (images, videos, datasets) outside the repo.          #
    # Essential for repos with binary assets.                                  #
    # ------------------------------------------------------------------------ #
    git-lfs # Git extension for versioning large files

    # ------------------------------------------------------------------------ #
    # Delta - Better Git Diff                                                  #
    # ------------------------------------------------------------------------ #
    # Delta is a syntax-highlighting pager for git, diff, and grep output.     #
    # Makes diffs much easier to read with colors and line numbers.            #
    # Configure git to use delta as the pager for beautiful diffs.             #
    # Project: https://github.com/dandavison/delta                             #
    # ------------------------------------------------------------------------ #
    delta # Syntax-highlighting pager for git and diff output

    # ------------------------------------------------------------------------ #
    # Lazygit - Terminal UI for Git                                            #
    # ------------------------------------------------------------------------ #
    # Lazygit provides a terminal user interface for Git.                      #
    # Makes staging, committing, and branching more visual and intuitive.      #
    # Great for those who prefer TUI over CLI commands.                        #
    # Project: https://github.com/jesseduffield/lazygit                        #
    # ------------------------------------------------------------------------ #
    lazygit # Simple terminal UI for git commands

    # ------------------------------------------------------------------------ #
    # Pre-commit - Git Hook Framework                                          #
    # ------------------------------------------------------------------------ #
    # Pre-commit manages and maintains multi-language pre-commit hooks.        #
    # Automates code quality checks before each commit.                        #
    # Project: https://pre-commit.com                                          #
    # ------------------------------------------------------------------------ #
    pre-commit # Framework for managing git pre-commit hooks

  ]; # End of systemPackages list

  # ========================================================================== #
  # GIT CONFIGURATION                                                          #
  # ========================================================================== #
  # programs.git enables the git program module (available on some systems).   #
  # Note: Personal git config (user.name, user.email) should be set per-user.  #
  # ========================================================================== #

  # ========================================================================== #
  # SHELL ALIASES                                                              #
  # ========================================================================== #
  # Define Git-related shell aliases available system-wide.                    #
  # These provide shortcuts for common Git operations.                         #
  # ========================================================================== #
  environment.shellAliases = {
    # ------------------------------------------------------------------------ #
    # Status Aliases                                                           #
    # ------------------------------------------------------------------------ #
    # Quick commands for checking repository state.                            #
    # ------------------------------------------------------------------------ #
    gs = "git status"; # Short alias for git status
    gst = "git status --short --branch"; # Compact status with branch info

    # ------------------------------------------------------------------------ #
    # Staging Aliases                                                          #
    # ------------------------------------------------------------------------ #
    # Commands for adding files to staging area.                               #
    # ------------------------------------------------------------------------ #
    ga = "git add"; # Add files to staging
    gaa = "git add --all"; # Add all changes (new, modified, deleted)
    gap = "git add --patch"; # Interactively stage hunks

    # ------------------------------------------------------------------------ #
    # Commit Aliases                                                           #
    # ------------------------------------------------------------------------ #
    # Commands for creating commits.                                           #
    # ------------------------------------------------------------------------ #
    gc = "git commit"; # Create a commit
    gcm = "git commit -m"; # Commit with inline message
    gca = "git commit --amend"; # Amend the last commit
    gcam = "git commit -am"; # Stage all tracked files and commit

    # ------------------------------------------------------------------------ #
    # Branch Aliases                                                           #
    # ------------------------------------------------------------------------ #
    # Commands for working with branches.                                      #
    # ------------------------------------------------------------------------ #
    gb = "git branch"; # List branches
    gba = "git branch -a"; # List all branches (local and remote)
    gbd = "git branch -d"; # Delete a branch (safe)
    gbD = "git branch -D"; # Force delete a branch
    gco = "git checkout"; # Switch branches or restore files
    gcb = "git checkout -b"; # Create and switch to new branch
    gsw = "git switch"; # Modern command to switch branches
    gswc = "git switch -c"; # Create and switch to new branch (modern)

    # ------------------------------------------------------------------------ #
    # Push/Pull Aliases                                                        #
    # ------------------------------------------------------------------------ #
    # Commands for syncing with remote repositories.                           #
    # ------------------------------------------------------------------------ #
    gp = "git push"; # Push to remote
    gpf = "git push --force-with-lease"; # Safer force push
    gpl = "git pull"; # Pull from remote
    gplr = "git pull --rebase"; # Pull with rebase instead of merge

    # ------------------------------------------------------------------------ #
    # Log Aliases                                                              #
    # ------------------------------------------------------------------------ #
    # Commands for viewing commit history.                                     #
    # ------------------------------------------------------------------------ #
    gl = "git log --oneline"; # Compact log view
    glog = "git log --oneline --decorate --graph"; # Pretty graph log
    gloga = "git log --oneline --decorate --graph --all"; # Graph all branches

    # ------------------------------------------------------------------------ #
    # Diff Aliases                                                             #
    # ------------------------------------------------------------------------ #
    # Commands for viewing changes.                                            #
    # ------------------------------------------------------------------------ #
    gd = "git diff"; # Show unstaged changes
    gds = "git diff --staged"; # Show staged changes
    gdc = "git diff --cached"; # Alias for staged (same as --staged)

    # ------------------------------------------------------------------------ #
    # Stash Aliases                                                            #
    # ------------------------------------------------------------------------ #
    # Commands for temporarily storing changes.                                #
    # ------------------------------------------------------------------------ #
    gsta = "git stash push"; # Stash changes
    gstp = "git stash pop"; # Apply and remove latest stash
    gstl = "git stash list"; # List all stashes

    # ------------------------------------------------------------------------ #
    # Lazygit Alias                                                            #
    # ------------------------------------------------------------------------ #
    # Quick access to the Lazygit TUI.                                         #
    # ------------------------------------------------------------------------ #
    lg = "lazygit"; # Launch Lazygit terminal UI

  }; # End of shellAliases

} # End of module configuration
