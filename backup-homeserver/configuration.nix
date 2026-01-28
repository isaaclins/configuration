# Isaac, please document everything from now on.
#
# FOR ANY QUESTIONS ABOUT OPTIONS:
# https://search.nixos.org/options?channel=25.11&query=
#
# FOR ANY QUESTIONS ABOUT PACKAGES:
# https://search.nixos.org/packages?channel=25.11&query=
#
#
{
  config,
  pkgs,
  ...
}: let
  # THIS SHOULD BE ALL CONFIG DIRECTORIES LIKE ~/.config/ghostty ~/.config/fish, etc.
  configurationdirectories = [
    "~/.config/ghostty"
    "~/.config/fish"
    "~/.config/ngrok"
    "/etc/nixos"
  ];
in {
  # NEEDED abbreviations
  programs.fish.shellAbbrs = {
    rnix = "sudo nixos-rebuild switch";
    r = "source ~/.config/fish/config.fish";
    cls = "clear";
    conf = "sudo code ${builtins.concatStringsSep " " configurationdirectories} --no-sandbox --user-data-dir=/tmp/code/";
  };

  imports = [
    ./hardware-configuration.nix
    # keybinds
    <home-manager/nixos>
  ];
  #keybinds shit
  home-manager.useGlobalPkgs = true;
  #keybinds shit
  home-manager.useUserPackages = true;
  #keybinds shit
  home-manager.users.isaaclins = {
    home.stateVersion = "23.05";
    # Minimal keybinds via kglobalshortcuts (Plasma 6)
    # Note: adjust the desktop entry name if ghostty uses a different .desktop id
    /*
       xdg.configFile."kglobalshortcutsrc" = {
      force = true;
      text = ''
        [kwin]
        Window Close=Alt+Q,Alt+F4,Close Window

        [ghostty.desktop]
        _launch=Meta+T,none,Launch Ghostty
      '';
    };
    */
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      home-wifi = {
        connection = {
          id = "home-wifi";
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          mode = "infrastructure";
          ssid = "blanco_wifi";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "0763066943";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.nix-ld.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.isaaclins = {
    isNormalUser = true;
    description = "Isaac Lins";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyOdzvq7oIzblQCRNfsMO9jQMaYK1UWKkFVQwoDnmdG bitwarden"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false; # no interactive auth
      AllowUsers = ["isaaclins"];
    };
  };

  # enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # BITWARDEN
    pkgs.bitwarden-desktop

    # CURSOR IDE
    pkgs.code-cursor-fhs

    # WARNING: THIS IS FUCKING CHROMIUM???? Discord fucking dies when installing native
    pkgs.vesktop

    # Shell
    pkgs.fish

    # KDE Bluetooth bullshit
    pkgs.kdePackages.bluedevil

    # Terminal
    pkgs.ghostty

    # VSCODE
    pkgs.vscode

    # whatsapp
    pkgs.whatsapp-electron

    # steam bro its not that deep
    pkgs.steam

    # docker CLI
    pkgs.docker-client

    # MINECRAFT LAUNCHER WITH PREINSTALLED JAVA
    pkgs.prismlauncher

    # FASTFETCH
    pkgs.fastfetch

    # GIT
    pkgs.git

    # github cli (for login)
    pkgs.gh

    # better CD  hardware.graphics.enable = true;

    pkgs.zoxide

    # JAVA JDK 17 (needed for MC-SERVER)
    pkgs.jdk21

    # NIX FORMATTER, NOT PRETTIER.
    pkgs.alejandra

    #SPOTIFY APP (probs electron)
    pkgs.spotify

    # NGROK FOR TUNNELS FOR MC SERVER
    pkgs.ngrok

    # CURL FOR REQUESTS FOR MC SERVER STARTUP SCRIPTS
    pkgs.curl
  ];

  hardware.graphics.enable = true;

  # Name:
  #     hardware.graphics.enable32Bit
  # Description:
  #     On 64-bit systems, whether to also install 32-bit drivers for 32-bit applications (such as Wine).
  # Type:
  #     boolean
  # Default:
  #     false
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = ["amdgpu"];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # START MC SERVER ON STARTUP
  # This service runs as a system service at boot, independent of any user login.
  # It waits for a stable network connection before starting.
  # Uses systemd-networkd-wait-online to ensure internet is available before MC server starts.
  systemd.services.mc-server-startup = {
    description = "Minecraft Server Startup";
    documentation = ["file:///DATA/mc-server"];
    # Wait for network to be fully online before starting
    after = [
      "network-online.target"
      "systemd-networkd-wait-online.service"
      "NetworkManager.service"
    ];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    preStart = "${pkgs.coreutils}/bin/mkdir -p /run/mc-server && ${pkgs.coreutils}/bin/chmod 755 /run/mc-server";

    serviceConfig = {
      Type = "simple";
      # Start the server in background and let it run continuously
      ExecStart = "${pkgs.bash}/bin/bash -c 'sed \"s|/tmp|/run/mc-server|g\" /DATA/mc-server/start.sh | ${pkgs.bash}/bin/bash'";

      # Keep the service running - don't restart if MC server crashes (set to on-failure if you want auto-restart)
      Restart = "no";

      # Run as root to access all resources
      User = "root";

      # Logging
      StandardOutput = "journal";
      StandardError = "journal";
      StandardInput = "null";

      # Environment variables needed
      Environment = [
        "PATH=${pkgs.jdk21}/bin:${pkgs.ngrok}/bin:${pkgs.git}/bin:${pkgs.curl}/bin:/run/current-system/sw/bin"
      ];

      # Security: set reasonable limits
      LimitNOFILE = 65536;
      LimitNPROC = 4096;

      # Network timeout - wait up to 120 seconds for network to stabilize
      TimeoutStartSec = 300;
    };
  };
}
