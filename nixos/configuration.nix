{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  home-manager = builtins.fetchGit {
        url = https://github.com/rycee/home-manager;
        ref = "release-19.09";
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
      ./lxd.nix
      ./sway.nix

      ./zsh.nix
      ./modules/zimfw

      # Features
      ./features/vpn.nix
      ./features/yubikey.nix
      ./fonts.nix

      ./scripts.nix

      # Cachix
      /etc/nixos/cachix.nix
    ];

  # Set time zone to pacific
  time.timeZone = "US/Pacific";
  time.hardwareClockInLocalTime = true;

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
    git gnumake curl gnupg cachix
  ];

  # Hardware defaults
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull; # Add bluetooth support
  };
  sound.mediaKeys.enable = true;
  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable network manager
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ 5353 ];
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # pretty boot logo
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  # Allow for exFAT
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  #
  # Services:
  #
  services = {
    postgresql.enable = true;

    # Battery/power utils
    tlp.enable = true;
    acpid.enable = true;

    pcscd.enable = true;

    # Enable CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplipWithPlugin ];
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
    };

    # Avahi for mDNS
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
      };
    };
  };
  location.provider = "geoclue2";

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
