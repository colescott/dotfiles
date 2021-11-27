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

      # Features
      ./features/mopidy.nix
      ./features/yubikey.nix
      ./features/vt420.nix
      ./features/wf-recorder.nix
      ./features/steam.nix

      ./fonts.nix
      ./scripts.nix
   ];

  # Set time zone to pacific
  time.timeZone = "US/Pacific";
  # This allows us to dual boot windows without clock issues
  time.hardwareClockInLocalTime = true;

  # Default packages
  nixpkgs.config = {
    allowUnfree = true; # Allows packages with unfree licences
    
    packageOverrides = pkgs: {
      # Export unstable to everyone
      unstable = unstable;

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
    manpages
  ];

  programs.dconf.enable = true;
  programs.light.enable = true;

  # Hardware defaults
  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      daemon.config = {
        default-sample-rate = 48000;
        alternate-sample-rate = 44410;
        avoid-resampling = true;
      };

      # Add bluetooth support
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa_drivers
        libGL
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      setLdLibraryPath = true;
    };
  };

  # Enable network manager
  networking = {
    usePredictableInterfaceNames = false;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = credentials.wifiNetworks;
      userControlled.enable = true;
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
  boot.supportedFilesystems = [ "ntfs" ];

  #
  # Services:
  #
  services = {
    xserver = {
      enable = true;
      autorun = false;
      desktopManager.xterm.enable = false;
      displayManager = {
        lightdm.enable = true;
        #defaultSession = "sway";
      };
      windowManager.i3.enable = true;
      synaptics = {
        enable = true;
        vertTwoFingerScroll = true;
        vertEdgeScroll = false;
        palmDetect = true;
      };
      videoDrivers = [ "nvidia" ];
      screenSection = ''
        Option         "metamodes" "1920x1080_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      '';
    };

    # Battery/power utils
    tlp.enable = true;
    acpid.enable = true;
    pcscd.enable = true;
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    # Enable CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplipWithPlugin ];
    };

    # Bluetooooth
    blueman.enable = true;

    # Enable geoclue location service
    geoclue2.enable = true;

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
      credentials = credentials.wireguard;
    };
    vt420.enable = true; 
    wf-recorder.enable = true;
    steam.enable = true;
  };

  xdg = {
    icons.enable = true;
  };
  
  nix = {
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos-unstable"
      "nixos-config=/home/cole/dotfiles/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  documentation = {
    dev.enable = true;
    doc.enable = true;
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "21.05";
}
