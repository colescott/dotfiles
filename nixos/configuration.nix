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

      # Zsh config
      ./zsh.nix

      # Home manager
      "${builtins.fetchGit {
        url = https://github.com/rycee/home-manager;
        ref = "master";
      }}/nixos"

      # Zimfw module
      ./modules/zimfw

      # Users
      ./users
    ];

  # Set time zone to pacific
  time.timeZone = "US/Pacific";

  # Default packages
  nixpkgs.config.allowUnfree = true; # Allows packages with unfree licences
  nixpkgs.config.packageOverrides = pkgs: {
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
  environment.systemPackages = with pkgs; [
    # GTK
    lxappearance
    breeze-gtk

    # Interface
    compton lightlocker xorg.xbacklight
    scrot feh

    # Command line utils
    git
    xclip xdg_utils
    alsaUtils # Volume control
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
    google-chrome slack spotify discord
    steam xboxdrv # Steam + utils
    nox nix-index nix-repl # Nix utils

    # Programming languages
    gcc clang # C(++)
    stack ghc # Haskell
    idris # Idris
    go # Go
    nodejs-8_x yarn # Node
    elmPackages.elm elmPackages.elm-format elmPackages.elm-reactor # Elm
    python python3 # Pseudocode

    uncrustify astyle

    zathura # PDF Viewer
    gitAndTools.diff-so-fancy
    rustup # Rust version manager

    (import ./programs/franz.nix)
  ];

  # Hardware defaults
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;
  # hardware.bumblebee.enable = true;

  # Enable network manager
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = false;
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

  # Security
  security.pam.enableU2F = true;
  boot.loader.systemd-boot.editor = false;

  #
  # Services:
  #
  services = {
    # Xserver
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:swapescape, eurosign:e";
      # videoDrivers = [ "nvidia" "intel" ];

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: with hp; [
          xmonad-contrib
          xmonad-extras
        ];
      };

      displayManager.lightdm = {
        enable = true;
        background = "/etc/nixos/users/cole/wallpaper.png";
        greeters.gtk.enable = true;
      };

      windowManager.default = "xmonad";
      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      dpi = 96;
      xrandrHeads = [
        {
          output = "eDP1";
          primary = true;
          monitorConfig = ''
DisplaySize 1920 1080
          '';
        }
        {
          output = "DP2-2";
          monitorConfig = ''
DisplaySize 1920 1080
Option "RightOf" "eDP1"
          '';
        }
      ];
    };

    postgresql.enable = true;

    # Smart card util
    pcscd.enable = true;

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

    hoogle = {
      enable = true;
      port = 1248;
      packages = hp: with hp; [
        text lens base
        aeson servant servant-server
        protolude
        persistent persistent-template
        containers mtl transformers
        xmonad xmonad-contrib xmonad-extras
      ];
    };
  };

  # Set default programs
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;

  # Install pretty fonts
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

  system.copySystemConfiguration = true;
  system.stateVersion = "18.03";
}
