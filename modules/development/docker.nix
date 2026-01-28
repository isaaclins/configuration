# ============================================================================ #
# modules/development/docker.nix - Docker Container Configuration              #
# ============================================================================ #
# This module installs and configures Docker for containerization.             #
# Docker allows running applications in isolated containers.                   #
# Note: Docker setup differs significantly between macOS and Linux.            #
# macOS: Docker Desktop (via Homebrew) | Linux: Native Docker daemon           #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS/nix-darwin module

# ============================================================================ #
# PLATFORM DETECTION                                                           #
# ============================================================================ #
# Docker configuration is very different on macOS vs Linux.                    #
# macOS uses Docker Desktop (a VM), Linux uses native Docker daemon.           #
# ============================================================================ #
let
  # -------------------------------------------------------------------------- #
  # isDarwin - Platform Detection Variable                                     #
  # -------------------------------------------------------------------------- #
  # This boolean is true on macOS (Darwin) and false on Linux.                 #
  # We use this to conditionally apply platform-specific configurations.       #
  # -------------------------------------------------------------------------- #
  isDarwin = pkgs.stdenv.isDarwin; # true on macOS, false on Linux

in # 'in' begins the expression that uses the 'let' bindings above
# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# We use lib.mkMerge to combine platform-specific configurations.              #
# ============================================================================ #
lib.mkMerge [
  # ========================================================================== #
  # COMMON CONFIGURATION (Both Platforms)                                      #
  # ========================================================================== #
  # Docker-related tools that work on both macOS and Linux.                    #
  # ========================================================================== #
  {
    # ------------------------------------------------------------------------ #
    # System Packages - Docker Tools                                           #
    # ------------------------------------------------------------------------ #
    # These CLI tools work with Docker on any platform.                        #
    # They communicate with the Docker daemon via the Docker socket.           #
    # ------------------------------------------------------------------------ #
    environment.systemPackages = with pkgs; [
      # ---------------------------------------------------------------------- #
      # Docker Compose                                                         #
      # ---------------------------------------------------------------------- #
      # Docker Compose defines multi-container applications.                   #
      # Use docker-compose.yml files to orchestrate multiple containers.       #
      # Project: https://docs.docker.com/compose/                              #
      # ---------------------------------------------------------------------- #
      docker-compose # Define and run multi-container Docker applications

      # ---------------------------------------------------------------------- #
      # Lazydocker - Terminal UI for Docker                                    #
      # ---------------------------------------------------------------------- #
      # Lazydocker provides a terminal user interface for Docker.              #
      # View containers, images, volumes, and logs in an interactive TUI.      #
      # Project: https://github.com/jesseduffield/lazydocker                   #
      # ---------------------------------------------------------------------- #
      lazydocker # Simple terminal UI for Docker

      # ---------------------------------------------------------------------- #
      # Dive - Docker Image Explorer                                           #
      # ---------------------------------------------------------------------- #
      # Dive lets you explore Docker image layers.                             #
      # Useful for optimizing image size by analyzing layer contents.          #
      # Project: https://github.com/wagoodman/dive                             #
      # ---------------------------------------------------------------------- #
      dive # Tool for exploring Docker image layers

    ]; # End of systemPackages list

    # ------------------------------------------------------------------------ #
    # Shell Aliases - Docker Shortcuts                                         #
    # ------------------------------------------------------------------------ #
    # Convenient aliases for common Docker commands.                           #
    # ------------------------------------------------------------------------ #
    environment.shellAliases = {
      # ---------------------------------------------------------------------- #
      # Docker Aliases                                                         #
      # ---------------------------------------------------------------------- #
      d = "docker"; # Short alias for docker
      dc = "docker-compose"; # Short alias for docker-compose
      dps = "docker ps"; # List running containers
      dpsa = "docker ps -a"; # List all containers (including stopped)
      di = "docker images"; # List Docker images
      dex = "docker exec -it"; # Execute command in running container
      dlogs = "docker logs -f"; # Follow container logs
      dprune = "docker system prune -af"; # Remove all unused Docker data

      # ---------------------------------------------------------------------- #
      # Docker Compose Aliases                                                 #
      # ---------------------------------------------------------------------- #
      dcu = "docker-compose up"; # Start services
      dcud = "docker-compose up -d"; # Start services in background
      dcd = "docker-compose down"; # Stop and remove services
      dcr = "docker-compose restart"; # Restart services
      dcl = "docker-compose logs -f"; # Follow compose logs
      dcps = "docker-compose ps"; # List compose services

      # ---------------------------------------------------------------------- #
      # Lazydocker Alias                                                       #
      # ---------------------------------------------------------------------- #
      lzd = "lazydocker"; # Launch Lazydocker TUI

    }; # End of shellAliases

  } # End of common configuration

  # ========================================================================== #
  # MACOS CONFIGURATION (nix-darwin)                                           #
  # ========================================================================== #
  # On macOS, Docker runs in a Linux VM via Docker Desktop.                    #
  # Docker Desktop is installed via Homebrew cask.                             #
  # ========================================================================== #
  (lib.mkIf isDarwin {
    # ------------------------------------------------------------------------ #
    # Homebrew Cask - Docker Desktop                                           #
    # ------------------------------------------------------------------------ #
    # Docker Desktop provides the Docker engine in a macOS-native app.         #
    # It includes the Docker daemon, CLI, and Docker Compose.                  #
    # ------------------------------------------------------------------------ #
    homebrew = {
      enable = true; # Enable nix-darwin's Homebrew integration
      casks = [
        "docker" # Docker Desktop - includes daemon, CLI, and Compose
      ]; # End of casks list
    }; # End of homebrew configuration
  }) # End of macOS configuration

  # ========================================================================== #
  # LINUX CONFIGURATION (NixOS)                                                #
  # ========================================================================== #
  # On Linux, Docker runs natively as a system service.                        #
  # NixOS has a built-in virtualisation.docker module for this.                #
  # ========================================================================== #
  (lib.mkIf (!isDarwin) {
    # ------------------------------------------------------------------------ #
    # Docker Daemon                                                            #
    # ------------------------------------------------------------------------ #
    # virtualisation.docker enables the Docker daemon on NixOS.                #
    # This creates a systemd service and sets up the Docker socket.            #
    # ------------------------------------------------------------------------ #
    virtualisation.docker = {
      enable = true; # Enable the Docker daemon service

      # ---------------------------------------------------------------------- #
      # Rootless Mode (Optional)                                               #
      # ---------------------------------------------------------------------- #
      # Rootless mode runs Docker without root privileges.                     #
      # More secure but may have compatibility issues with some containers.    #
      # Uncomment to enable rootless Docker.                                   #
      # ---------------------------------------------------------------------- #
      # rootless = {
      #   enable = true; # Run Docker daemon without root
      #   setSocketVariable = true; # Set DOCKER_HOST for rootless socket
      # }; # End of rootless configuration

      # ---------------------------------------------------------------------- #
      # Auto-Prune Configuration                                               #
      # ---------------------------------------------------------------------- #
      # Automatically clean up unused Docker data to save disk space.          #
      # Removes dangling images, stopped containers, unused networks.          #
      # ---------------------------------------------------------------------- #
      autoPrune = {
        enable = true; # Enable automatic Docker cleanup
        dates = "weekly"; # Run prune weekly
        flags = [
          "--all" # Remove all unused images, not just dangling ones
        ]; # End of flags list
      }; # End of autoPrune configuration

    }; # End of virtualisation.docker

    # ------------------------------------------------------------------------ #
    # Docker CLI Package                                                       #
    # ------------------------------------------------------------------------ #
    # Install the Docker CLI for interacting with the daemon.                  #
    # The daemon provides dockerd, but we also need the docker CLI.            #
    # ------------------------------------------------------------------------ #
    environment.systemPackages = with pkgs; [
      docker # Docker CLI for interacting with Docker daemon
    ]; # End of systemPackages list

    # ------------------------------------------------------------------------ #
    # Docker Group                                                             #
    # ------------------------------------------------------------------------ #
    # Note: To run Docker without sudo, add users to the 'docker' group.       #
    # This is done in the host configuration, not here (user-specific).        #
    # Example in host config: users.users.<name>.extraGroups = [ "docker" ];   #
    # ------------------------------------------------------------------------ #

  }) # End of Linux configuration

] # End of lib.mkMerge list
