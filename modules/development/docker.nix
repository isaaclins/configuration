# ============================================================================ #
# modules/development/docker.nix - Docker Container Configuration (NixOS)      #
# ============================================================================ #
# This module installs and configures Docker for containerization on Linux.    #
# Docker allows running applications in isolated containers.                   #
# NOTE: This module is for NixOS (Linux) only.                                 #
# For macOS, install Docker Desktop via Homebrew in your host config.          #
# ============================================================================ #

{ 
  config, # The current system configuration (allows reading other options)
  pkgs,   # The nixpkgs package set (contains all available packages)
  lib,    # Nix library functions (for conditionals, types, etc.)
  ...     # Allows other arguments to pass through (future compatibility)
}: # Function argument set - this is a NixOS module

# ============================================================================ #
# MODULE CONFIGURATION                                                         #
# ============================================================================ #
# This attribute set defines what this module adds to the system.              #
# ============================================================================ #
{
  # ========================================================================== #
  # SYSTEM PACKAGES                                                            #
  # ========================================================================== #
  # Docker CLI and related tools.                                              #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------------------------ #
    # Docker CLI                                                               #
    # ------------------------------------------------------------------------ #
    # The Docker command-line interface for interacting with the daemon.       #
    # ------------------------------------------------------------------------ #
    docker # Docker CLI for interacting with Docker daemon

    # ------------------------------------------------------------------------ #
    # Docker Compose                                                           #
    # ------------------------------------------------------------------------ #
    # Docker Compose defines multi-container applications.                     #
    # Use docker-compose.yml files to orchestrate multiple containers.         #
    # Project: https://docs.docker.com/compose/                                #
    # ------------------------------------------------------------------------ #
    docker-compose # Define and run multi-container Docker applications

    # ------------------------------------------------------------------------ #
    # Lazydocker - Terminal UI for Docker                                      #
    # ------------------------------------------------------------------------ #
    # Lazydocker provides a terminal user interface for Docker.                #
    # View containers, images, volumes, and logs in an interactive TUI.        #
    # Project: https://github.com/jesseduffield/lazydocker                     #
    # ------------------------------------------------------------------------ #
    lazydocker # Simple terminal UI for Docker

    # ------------------------------------------------------------------------ #
    # Dive - Docker Image Explorer                                             #
    # ------------------------------------------------------------------------ #
    # Dive lets you explore Docker image layers.                               #
    # Useful for optimizing image size by analyzing layer contents.            #
    # Project: https://github.com/wagoodman/dive                               #
    # ------------------------------------------------------------------------ #
    dive # Tool for exploring Docker image layers

  ]; # End of systemPackages list

  # ========================================================================== #
  # SHELL ALIASES                                                              #
  # ========================================================================== #
  # Convenient aliases for common Docker commands.                             #
  # ========================================================================== #
  environment.shellAliases = {
    # ------------------------------------------------------------------------ #
    # Docker Aliases                                                           #
    # ------------------------------------------------------------------------ #
    d = "docker"; # Short alias for docker
    dc = "docker-compose"; # Short alias for docker-compose
    dps = "docker ps"; # List running containers
    dpsa = "docker ps -a"; # List all containers (including stopped)
    di = "docker images"; # List Docker images
    dex = "docker exec -it"; # Execute command in running container
    dlogs = "docker logs -f"; # Follow container logs
    dprune = "docker system prune -af"; # Remove all unused Docker data

    # ------------------------------------------------------------------------ #
    # Docker Compose Aliases                                                   #
    # ------------------------------------------------------------------------ #
    dcu = "docker-compose up"; # Start services
    dcud = "docker-compose up -d"; # Start services in background
    dcd = "docker-compose down"; # Stop and remove services
    dcr = "docker-compose restart"; # Restart services
    dcl = "docker-compose logs -f"; # Follow compose logs
    dcps = "docker-compose ps"; # List compose services

    # ------------------------------------------------------------------------ #
    # Lazydocker Alias                                                         #
    # ------------------------------------------------------------------------ #
    lzd = "lazydocker"; # Launch Lazydocker TUI

  }; # End of shellAliases

  # ========================================================================== #
  # DOCKER DAEMON (NixOS)                                                      #
  # ========================================================================== #
  # Enable and configure the Docker daemon service.                            #
  # This creates a systemd service and sets up the Docker socket.              #
  # ========================================================================== #
  virtualisation.docker = {
    enable = true; # Enable the Docker daemon service

    # ------------------------------------------------------------------------ #
    # Auto-Prune Configuration                                                 #
    # ------------------------------------------------------------------------ #
    # Automatically clean up unused Docker data to save disk space.            #
    # Removes dangling images, stopped containers, unused networks.            #
    # ------------------------------------------------------------------------ #
    autoPrune = {
      enable = true; # Enable automatic Docker cleanup
      dates = "weekly"; # Run prune weekly
      flags = [
        "--all" # Remove all unused images, not just dangling ones
      ]; # End of flags list
    }; # End of autoPrune configuration

  }; # End of virtualisation.docker

  # ========================================================================== #
  # DOCKER GROUP NOTE                                                          #
  # ========================================================================== #
  # To run Docker without sudo, add users to the 'docker' group.               #
  # This is done in the host configuration, not here (user-specific).          #
  # Example in host config: users.users.<name>.extraGroups = [ "docker" ];     #
  # ========================================================================== #

} # End of module configuration
