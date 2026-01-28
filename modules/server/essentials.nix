# ============================================================================ #
# modules/server/essentials.nix - Server Essentials Configuration              #
# ============================================================================ #
# This module installs essential tools for headless Linux servers.             #
# Includes monitoring, networking, security, and system administration tools.  #
# NOTE: This module is for NixOS only - not for macOS (servers are Linux).     #
# These are CLI-only tools - NO GUI applications included.                     #
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
  # Install essential server tools system-wide.                                #
  # All tools are CLI-based and suitable for headless operation.               #
  # ========================================================================== #
  environment.systemPackages = with pkgs; [
    # ======================================================================== #
    # SYSTEM MONITORING                                                        #
    # ======================================================================== #
    # Tools for monitoring system resources and performance.                   #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # htop - Interactive Process Viewer                                        #
    # ------------------------------------------------------------------------ #
    # htop is an improved version of top with a better interface.              #
    # Shows CPU, memory, swap usage and running processes.                     #
    # Navigate with arrow keys, kill processes with F9.                        #
    # ------------------------------------------------------------------------ #
    htop # Interactive process viewer with better UI than top

    # ------------------------------------------------------------------------ #
    # btop - Resource Monitor                                                  #
    # ------------------------------------------------------------------------ #
    # btop is a modern resource monitor with graphs and themes.                #
    # Shows CPU, memory, disks, network, and processes beautifully.            #
    # Project: https://github.com/aristocratos/btop                            #
    # ------------------------------------------------------------------------ #
    btop # Modern resource monitor with graphs

    # ------------------------------------------------------------------------ #
    # iotop - I/O Monitoring                                                   #
    # ------------------------------------------------------------------------ #
    # iotop shows disk I/O usage by process.                                   #
    # Useful for finding which processes are causing disk load.                #
    # Requires root to run (sudo iotop).                                       #
    # ------------------------------------------------------------------------ #
    iotop # Monitor disk I/O by process

    # ------------------------------------------------------------------------ #
    # nethogs - Network Monitoring by Process                                  #
    # ------------------------------------------------------------------------ #
    # nethogs shows network bandwidth usage per process.                       #
    # Like top but for network traffic instead of CPU.                         #
    # Requires root to run (sudo nethogs).                                     #
    # ------------------------------------------------------------------------ #
    nethogs # Monitor network bandwidth by process

    # ------------------------------------------------------------------------ #
    # duf - Disk Usage                                                         #
    # ------------------------------------------------------------------------ #
    # duf is a better df alternative with colors and better formatting.        #
    # Shows disk usage of mounted filesystems in a clear table.                #
    # Project: https://github.com/muesli/duf                                   #
    # ------------------------------------------------------------------------ #
    duf # Modern disk usage utility (better df)

    # ------------------------------------------------------------------------ #
    # ncdu - NCurses Disk Usage                                                #
    # ------------------------------------------------------------------------ #
    # ncdu is an interactive disk usage analyzer.                              #
    # Navigate directories to find what's using disk space.                    #
    # Very useful for cleaning up large directories.                           #
    # ------------------------------------------------------------------------ #
    ncdu # Interactive disk usage analyzer

    # ======================================================================== #
    # TERMINAL MULTIPLEXER                                                     #
    # ======================================================================== #
    # Tools for managing multiple terminal sessions.                           #
    # Essential for server administration - sessions persist on disconnect.    #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # tmux - Terminal Multiplexer                                              #
    # ------------------------------------------------------------------------ #
    # tmux allows multiple terminal sessions in one window.                    #
    # Sessions persist when you disconnect - essential for servers.            #
    # Use: tmux new -s <name>, tmux attach -t <name>                           #
    # ------------------------------------------------------------------------ #
    tmux # Terminal multiplexer for persistent sessions

    # ======================================================================== #
    # NETWORKING TOOLS                                                         #
    # ======================================================================== #
    # Tools for network diagnostics and administration.                        #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # curl - HTTP Client                                                       #
    # ------------------------------------------------------------------------ #
    # curl transfers data from/to servers using various protocols.             #
    # Essential for testing APIs, downloading files, debugging HTTP.           #
    # ------------------------------------------------------------------------ #
    curl # Command-line HTTP client

    # ------------------------------------------------------------------------ #
    # wget - File Downloader                                                   #
    # ------------------------------------------------------------------------ #
    # wget downloads files from the web.                                       #
    # Supports recursive downloads, resuming, and mirroring.                   #
    # ------------------------------------------------------------------------ #
    wget # File downloader with resume support

    # ------------------------------------------------------------------------ #
    # dig - DNS Lookup                                                         #
    # ------------------------------------------------------------------------ #
    # dig performs DNS lookups and diagnostics.                                #
    # Part of bind package (dnsutils).                                         #
    # Usage: dig example.com, dig @8.8.8.8 example.com                         #
    # ------------------------------------------------------------------------ #
    dnsutils # DNS utilities including dig and nslookup

    # ------------------------------------------------------------------------ #
    # netcat - Network Swiss Army Knife                                        #
    # ------------------------------------------------------------------------ #
    # netcat (nc) reads/writes data across network connections.                #
    # Useful for testing ports, simple file transfers, debugging.              #
    # ------------------------------------------------------------------------ #
    netcat-openbsd # Network debugging and investigation tool

    # ------------------------------------------------------------------------ #
    # nmap - Network Scanner                                                   #
    # ------------------------------------------------------------------------ #
    # nmap scans networks to discover hosts and services.                      #
    # Essential for security audits and network inventory.                     #
    # Usage: nmap -sV 192.168.1.0/24                                           #
    # ------------------------------------------------------------------------ #
    nmap # Network scanner for security audits

    # ------------------------------------------------------------------------ #
    # iperf3 - Network Performance Testing                                     #
    # ------------------------------------------------------------------------ #
    # iperf3 measures network bandwidth between two hosts.                     #
    # Run server: iperf3 -s | Run client: iperf3 -c <server-ip>                #
    # ------------------------------------------------------------------------ #
    iperf3 # Network bandwidth measurement tool

    # ======================================================================== #
    # FILE AND TEXT UTILITIES                                                  #
    # ======================================================================== #
    # Tools for working with files and text.                                   #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # rsync - File Synchronization                                             #
    # ------------------------------------------------------------------------ #
    # rsync efficiently syncs files locally or over SSH.                       #
    # Only transfers changed portions of files (delta transfer).               #
    # Essential for backups: rsync -avz source/ dest/                          #
    # ------------------------------------------------------------------------ #
    rsync # Fast, incremental file transfer utility

    # ------------------------------------------------------------------------ #
    # tree - Directory Tree View                                               #
    # ------------------------------------------------------------------------ #
    # tree displays directory structure as a tree.                             #
    # Useful for understanding project layouts.                                #
    # Usage: tree -L 2 (limit depth to 2)                                      #
    # ------------------------------------------------------------------------ #
    tree # Display directory structure as tree

    # ------------------------------------------------------------------------ #
    # jq - JSON Processor                                                      #
    # ------------------------------------------------------------------------ #
    # jq is a lightweight JSON processor.                                      #
    # Parse, filter, and transform JSON from command line.                     #
    # Essential for working with APIs and config files.                        #
    # Usage: cat file.json | jq '.key'                                         #
    # ------------------------------------------------------------------------ #
    jq # Command-line JSON processor

    # ------------------------------------------------------------------------ #
    # yq - YAML Processor                                                      #
    # ------------------------------------------------------------------------ #
    # yq is like jq but for YAML (and JSON, XML, TOML).                        #
    # Essential for working with Kubernetes manifests, configs.                #
    # Usage: yq '.key' file.yaml                                               #
    # ------------------------------------------------------------------------ #
    yq # Command-line YAML processor

    # ======================================================================== #
    # COMPRESSION TOOLS                                                        #
    # ======================================================================== #
    # Tools for compressing and extracting archives.                           #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # Compression Utilities                                                    #
    # ------------------------------------------------------------------------ #
    # Various compression formats used in server administration.               #
    # ------------------------------------------------------------------------ #
    gzip # GNU zip compression
    bzip2 # bzip2 compression
    xz # XZ compression (high ratio)
    unzip # Extract ZIP archives
    p7zip # 7-Zip compression (7z format)
    zstd # Zstandard compression (fast, good ratio)

    # ======================================================================== #
    # SYSTEM UTILITIES                                                         #
    # ======================================================================== #
    # General system administration tools.                                     #
    # ======================================================================== #

    # ------------------------------------------------------------------------ #
    # lsof - List Open Files                                                   #
    # ------------------------------------------------------------------------ #
    # lsof lists open files and the processes using them.                      #
    # Find which process is using a port: lsof -i :80                          #
    # Find open files by process: lsof -p <pid>                                #
    # ------------------------------------------------------------------------ #
    lsof # List open files and associated processes

    # ------------------------------------------------------------------------ #
    # pciutils - PCI Utilities                                                 #
    # ------------------------------------------------------------------------ #
    # lspci lists all PCI devices in the system.                               #
    # Useful for identifying hardware (GPUs, network cards, etc.).             #
    # ------------------------------------------------------------------------ #
    pciutils # PCI device utilities (lspci)

    # ------------------------------------------------------------------------ #
    # usbutils - USB Utilities                                                 #
    # ------------------------------------------------------------------------ #
    # lsusb lists USB devices connected to the system.                         #
    # Useful for debugging USB hardware.                                       #
    # ------------------------------------------------------------------------ #
    usbutils # USB device utilities (lsusb)

    # ------------------------------------------------------------------------ #
    # file - File Type Identification                                          #
    # ------------------------------------------------------------------------ #
    # file determines file type by examining contents.                         #
    # Usage: file somefile (shows type regardless of extension)                #
    # ------------------------------------------------------------------------ #
    file # Determine file type

  ]; # End of systemPackages list

  # ========================================================================== #
  # SSH SERVER                                                                 #
  # ========================================================================== #
  # Enable SSH server for remote access to the server.                         #
  # Essential for headless server administration.                              #
  # ========================================================================== #
  services.openssh = {
    enable = true; # Enable the OpenSSH server daemon

    # ------------------------------------------------------------------------ #
    # SSH Security Settings                                                    #
    # ------------------------------------------------------------------------ #
    # Configure SSH for better security.                                       #
    # ------------------------------------------------------------------------ #
    settings = {
      PermitRootLogin = "prohibit-password"; # Allow root only with SSH keys
      PasswordAuthentication = false; # Disable password auth (use keys only)
    }; # End of settings

  }; # End of services.openssh

  # ========================================================================== #
  # FIREWALL                                                                   #
  # ========================================================================== #
  # Enable and configure the firewall.                                         #
  # By default, allow SSH and block everything else.                           #
  # ========================================================================== #
  networking.firewall = {
    enable = true; # Enable the NixOS firewall

    # ------------------------------------------------------------------------ #
    # Allowed TCP Ports                                                        #
    # ------------------------------------------------------------------------ #
    # Ports to allow incoming TCP connections on.                              #
    # Add more ports as needed for your services.                              #
    # ------------------------------------------------------------------------ #
    allowedTCPPorts = [
      22 # SSH - remote access
      # 80 # HTTP - uncomment if running a web server
      # 443 # HTTPS - uncomment if running a web server
    ]; # End of allowedTCPPorts

  }; # End of networking.firewall

  # ========================================================================== #
  # AUTOMATIC UPDATES                                                          #
  # ========================================================================== #
  # Enable automatic security updates for the server.                          #
  # Keeps the system secure without manual intervention.                       #
  # ========================================================================== #
  system.autoUpgrade = {
    enable = true; # Enable automatic system upgrades
    allowReboot = false; # Don't auto-reboot (manual reboots are safer)
    dates = "04:00"; # Run upgrades at 4 AM daily
  }; # End of system.autoUpgrade

  # ========================================================================== #
  # GARBAGE COLLECTION                                                         #
  # ========================================================================== #
  # Automatically clean up old Nix store paths.                                #
  # Prevents disk space from filling up with old generations.                  #
  # ========================================================================== #
  nix.gc = {
    automatic = true; # Enable automatic garbage collection
    dates = "weekly"; # Run weekly
    options = "--delete-older-than 30d"; # Delete generations older than 30 days
  }; # End of nix.gc

  # ========================================================================== #
  # SHELL ALIASES                                                              #
  # ========================================================================== #
  # Convenient aliases for server administration.                              #
  # ========================================================================== #
  environment.shellAliases = {
    # ------------------------------------------------------------------------ #
    # System Information                                                       #
    # ------------------------------------------------------------------------ #
    sysinfo = "echo '=== Uptime ===' && uptime && echo '=== Memory ===' && free -h && echo '=== Disk ===' && duf"; # Quick system overview
    
    # ------------------------------------------------------------------------ #
    # Service Management                                                       #
    # ------------------------------------------------------------------------ #
    ss = "sudo systemctl status"; # Check service status
    sr = "sudo systemctl restart"; # Restart a service
    sj = "sudo journalctl -u"; # View service logs
    sjf = "sudo journalctl -fu"; # Follow service logs

    # ------------------------------------------------------------------------ #
    # Tmux Shortcuts                                                           #
    # ------------------------------------------------------------------------ #
    ta = "tmux attach -t"; # Attach to tmux session
    tl = "tmux list-sessions"; # List tmux sessions
    tn = "tmux new -s"; # Create new tmux session

  }; # End of shellAliases

} # End of module configuration
