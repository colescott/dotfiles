{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  credentials = import ./credentials.nix;
in
{
  imports =
    [
      # Current machine
      ./machine-configuration.nix
      ./udev.nix

      ../nix-modules

      <home-manager/nixos>
      ./users

      ./docker.nix
      ./lxd.nix
      ./sway.nix

      #./zsh.nix
      ./modules/zimfw

      # Features
      ./features/mopidy.nix
      ./features/yubikey.nix
      ./features/wireguard.nix

      ./fonts.nix
      ./scripts.nix

      # Cachix
      #/etc/nixos/cachix.nix
    ];

  # Set time zone to pacific
  time.timeZone = "US/Pacific";
  time.hardwareClockInLocalTime = true;

  # Default packages
  nixpkgs.config = {
    allowUnfree = true; # Allows packages with unfree licences
    permittedInsecurePackages = [
      "p7zip-16.02"
    ];
    packageOverrides = pkgs: {
      unstable = unstable;
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
      mopidy = unstable.mopidy;
      mopidy-mpd = unstable.mopidy-mpd;
      mopidy-spotify = unstable.mopidy-spotify;
      mopidy-iris = unstable.mopidy-iris;
    };
  };
  environment.systemPackages = with pkgs; [
    git
    gnumake
    curl
    gnupg
    cachix
  ];
  programs.dconf.enable = true;

  # Hardware defaults
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull; # Add bluetooth support
  };
  sound.mediaKeys.enable = true;
  hardware.bluetooth.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
     extraPackages = with pkgs; [
       libGL
     ];
     setLdLibraryPath = true;
  };

  # Enable network manager
  networking = {
    usePredictableInterfaceNames = false;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = credentials.wifiNetworks;
    };
    networkmanager = {
      enable = false;
      dns = "none";
    };
    firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ 5353 ];
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    # Don't take nameservers from DHCP
    dhcpcd.extraConfig = ''
      nooption domain_name_servers, domain_name, domain_search, host_name, ntp_servers
    '';
  };

  # pretty boot logo
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  # Allow for exFAT (hopefully not needed soon)
  # boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  #
  # Services:
  #
  services = {
    postgresql.enable = true;

    # Xserver for matlab :(
    xserver = {
      enable = true;
      autorun = false;
      desktopManager.xterm.enable = false;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "sway";
      };
      windowManager.i3.enable = true;
      synaptics = {
        enable = true;
        vertTwoFingerScroll = true;
        vertEdgeScroll = false;
        palmDetect = true;
      };
    };

    # Battery/power utils
    tlp.enable = true;
    acpid.enable = true;
    pcscd.enable = true;

    # Enable CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplipWithPlugin ];
    };

    # Bluetooooth
    blueman.enable = true;

    # Manual
    nixosManual = {
      showManual = true;
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
  environment.pathsToLink = [ "/share/zsh" ];

  networking.wireguard.enable = true;

  features = {
    yubikey.enable = true;
    dnscrypt = {
      enable = true;
      localDoh.enable = true;
      cache.enable = true;
    };
    mopidy = {
      enable = true;
      extensionPackages = [
        pkgs.mopidy-iris
      ];
      mpd = {
        enable = true;
      };
      spotify = {
        enable = true;
        credentials = credentials.spotify;
      };
      mediaDirs = [{
        name = "Music";
        path = "/home/cole/Music";
      }];
    };
    wireguard = {
      enable = true;
      wirelessInterface = "wlan0";
      extraInterfaces = [ "eth0" ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/cole/dotfiles/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "20.03";
}
