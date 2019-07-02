{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  home-manager = builtins.fetchGit {
        url = https://github.com/rycee/home-manager;
        ref = "release-19.03";
      };
  credentials = import ./credentials.nix;
in

{
  imports =
    [ # Current machine
      ./machine-configuration.nix
      ./udev.nix

      "${home-manager}/nixos"
      ./users

      ./docker.nix
      ./sway.nix

      ./zsh.nix
      ./modules/zimfw

      # Features
      ./features/vpn.nix
      ./features/yubikey.nix
      ./fonts.nix

      ./scripts.nix
    ];

  # Set time zone to pacific
  time.timeZone = "US/Pacific";

  # Default packages
  nixpkgs.config = {
    allowUnfree = true; # Allows packages with unfree licences
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          gnome3.gtk
          zlib
          dbus
          freetype
          glib
          atk
          cairo
          gdk_pixbuf
          pango
          fontconfig
          xorg.libxcb
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    # GTK
    lxappearance
    breeze-gtk

    # Interface
    feh

    # GPG
    gnupg

    # Command line utils
    git
    xclip xdg_utils
    transmission # Torrent client
    unzip wget gnumake
    travis git-hub
    vim tmux htop
    cmus ranger newsboat

    # Libraries and utils
    jdk
    libelf
    xorg.libX11 xorg.libxcb
    ntfs3g # Write support for NTFS

    # Applications
    firefox slack spotify discord
    steam xboxdrv # Steam + utils
    nox nix-index # Nix utils
    pavucontrol

    # Programming languages
    gcc clang # C(++)
    stack ghc # Haskell
    idris # Idris
    go # Go
    nodejs-8_x yarn # Node
    elmPackages.elm elmPackages.elm-format # Elm
    python python3 # Pseudocode

    uncrustify astyle

    zathura # PDF Viewer
    gitAndTools.diff-so-fancy
    rustup # Rust version manager
  ];

  # Hardware defaults
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    # Add bluetooth support
    package = pkgs.pulseaudioFull;
  };
  sound.mediaKeys.enable = true;
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;
  # hardware.bumblebee.enable = true;

  # Enable network manager
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # pretty boot logo
  boot.plymouth = {
    enable = true;
    theme = "tribar";
  };

  #
  # Services:
  #
  services = {
    postgresql.enable = true;

    # Battery/power utils
    tlp.enable = true;
    acpid.enable = true;

    # Enable CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint ];
    };

    # Manual
    nixosManual = {
      showManual = true;
      # Use tty9 for manual to avoid showing when light-locker runs
      ttyNumber = 9;
    };

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

  # Set default programs
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;

  features = {
    vpn = {
      enable = true;
      credentials = credentials.vpn;
    };
    yubikey.enable = true;
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "19.03";
}
