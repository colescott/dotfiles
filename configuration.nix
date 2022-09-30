{ config, pkgs, ... }:
let
  credentials = import ./credentials.nix;
in
{
  imports =
    [
      ./udev.nix

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

  # Allow emulating aarch64-linux builds with qemu
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
  boot.binfmt.registrations.armv7l = {
    interpreter = "${pkgs.qemu_full}/bin/qemu-system-arm";
    magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
    mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
  };


  # Set time zone to pacific
  time.timeZone = "US/Pacific";
  # This allows us to dual boot windows without clock issues
  time.hardwareClockInLocalTime = true;

  environment.systemPackages = with pkgs; [
    git
    gnumake
    curl
    gnupg
    man-pages
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
      allowedTCPPorts = [ 56207 ];
      allowedUDPPorts = [ 5353 56207 ];
    };

    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    # Don't take nameservers from DHCP
    dhcpcd.extraConfig = ''
      nooption domain_name_servers, domain_name, domain_search, host_name, ntp_servers
    '';
  };

  boot.supportedFilesystems = [ "ntfs" ];

  #
  # Services:
  #
  services = {
    # xserver = {
    #   enable = true;
    #   autorun = false;
    #   desktopManager.xterm.enable = false;
    #   displayManager = {
    #     lightdm.enable = true;
    #     #defaultSession = "sway";
    #   };
    #   windowManager.i3.enable = true;
    #   synaptics = {
    #     enable = true;
    #     vertTwoFingerScroll = true;
    #     vertEdgeScroll = false;
    #     palmDetect = true;
    #   };
    #   videoDrivers = [ "nvidia" ];
    #   screenSection = ''
    #     Option         "metamodes" "HDMI-0: 1920x1080_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    #   '';
    # };

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
      privateKey = "/etc/nixos-secrets/dnscrypt.pem";
    };
    mopidy = {
      enable = true;
      extensionPackages = with pkgs; [
        mopidy-iris
        mopidy-local
        mopidy-youtube
      ];
      mpd = {
        enable = true;
      };
      mediaDirs = [{
        name = "Music";
        path = "/home/Music";
      }];
      localMediaDir = "/home/Music";
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
  };

  documentation = {
    dev.enable = true;
    doc.enable = true;
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "21.05";
}
