{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Current machine
      ./machine-configuration.nix

      # Udev rules
      ./udev.nix

      # Docker virtualisation
      ./docker.nix

      # Home manager
      "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
    ];

  networking.networkmanager.enable = true; # Enable network manager

  # Set time zone to pacific
  time.timeZone = "US/Pacific";

  # Default packages
  nixpkgs.config.allowUnfree = true; # Allows packages with unfree licences
  environment.systemPackages = with pkgs; [
    git gnupg1
    dmenu stalonetray
    haskellPackages.xmobar
    konsole compton xscreensaver
    scrot
    xorg.libX11 xorg.libxcb xdg_utils
    gcc clang wget gnumake unzip vim
    jdk
    libelf
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code Light" ];
      };
    };
    fonts = with pkgs; [
      powerline-fonts
      source-code-pro
      fira
      fira-code
      fira-code-symbols
      fira-mono
      emojione
    ];
  };

  # Set default editor to vim
  programs.vim.defaultEditor = true;

  # VirtualBox
  # virtualisation.virtualbox.host.enable = true;
  # nixpkgs.config.virtualbox.enableExtensionPack = true;

  # Enable pulse audio
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Enable steam support
  hardware.opengl.driSupport32Bit = true;

  # pretty boot logo
  boot.plymouth = {
    enable = true;
    theme = "tribar";
  };

  #
  # Services:
  #
  services = {
    # Xserver
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:swapescape, eurosign:e";

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: with haskellPackages; [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
        ];
      };

      displayManager.lightdm = {
        enable = true;
      };

      windowManager.default = "xmonad";
      desktopManager.default = "none";
      desktopManager.xterm.enable = false;

      # Xrandr
      xrandrHeads = [
        {
          output = "eDPI1";
          primary = true;
          monitorConfig = ''
DisplaySize 1920 1080
          '';
        }
        {
          output = "HDMI2";
          monitorConfig = ''
DisplaySize 1920 1080
Option "RightOf" "eDPI1"
          '';
        }
      ];
    };

    postgresql.enable = true;

    pcscd.enable = true;
    tlp.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    # Manual
    nixosManual.showManual = true;

    # Enable geoclue location service
    geoclue2.enable = true;

    # Redshift for my eyes
    redshift = {
      enable = true;
      latitude = "37.774929";
      longitude = "-122.419416";
    };

    # Avahi for mDNS
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  # U2F PAM
  security.pam.enableU2F = true;

  # Define user account
  users.extraUsers.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" "plugdev" ];
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    passwordFile = "/etc/nixos/passwords/cole";
  };
  # Import home-manager config
  home-manager.users.cole = import ./users/cole { pkgs = pkgs; };

  # Disable mutable users to only allow new users through this file
  users.mutableUsers = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
  system.copySystemConfiguration = true;
}
