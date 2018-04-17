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

  # Set time zone to pacific
  time.timeZone = "US/Pacific";

  # Default packages
  nixpkgs.config.allowUnfree = true; # Allows packages with unfree licences
  environment.systemPackages = with pkgs; [
    git gnupg1
    dmenu stalonetray
    haskellPackages.xmobar
    konsole compton lightlocker xorg.xbacklight
    scrot feh xclip
    xorg.libX11 xorg.libxcb xdg_utils
    gcc clang wget gnumake
    unzip vim cmus tmux htop
    jdk
    libelf
  ];

  # Hardware defaults
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    bluetooth.enable = true;
    opengl.driSupport32Bit = true;
  };

  # Enable network manager
  networking.networkmanager.enable = true;

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
      videoDrivers = [ "intel" "nvidia"];

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
      packages = hp: with hp; [ text lens base aeson servant servant-server protolude persistent persistent-template containers mtl transformers ];
    };
  };

  # U2F PAM
  security.pam.enableU2F = true;

  # Set default programs
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;

  # Define user account
  users = {
    extraUsers.cole = {
      isNormalUser = true;
      home = "/home/cole";
      description = "Cole Scott";
      extraGroups = [ "wheel" "networkmanager" "vboxusers" "plugdev" "docker" ];
      uid = 1000;
      shell = pkgs.zsh;
      passwordFile = "/etc/nixos/passwords/cole";
    };
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };
  # Import home-manager config
  home-manager.users.cole = import ./users/cole { pkgs = pkgs; };

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
