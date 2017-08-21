# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # mah st petches
      ./programs/st.nix

      # Current machine
      ./machine-configuration.nix
    ];

  networking.networkmanager.enable = true; # Enable network manager 

  # Set time zone to pacific
  time.timeZone = "US/Pacific";

  # Default packages
  nixpkgs.config.allowUnfree = true; # Allows packages with unfree licences
  environment.systemPackages = with pkgs; [
    git gnupg1 
    dmenu
    haskellPackages.xmobar
    st
    scrot
    xorg.libX11
    gcc clang wget gnumake unzip vim
    jdk
    vlc
    libelf
    (import ./programs/vim.nix) # Vim config
    ((pkgs.callPackage ./programs/nix-home.nix) {})
  ];
  
  programs.zsh.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "Meslo LG L for Powerline" ];
      };
    };
    fonts = with pkgs; [
      powerline-fonts
      source-code-pro
      emojione
    ];
  };

  # Set default editor to vim
  programs.vim.defaultEditor = true;

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;

  # Enable pulse audio 
  hardware.pulseaudio.enable = true;

  # Enable steam support
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  #
  # Services:
  #  
  services = {
    
    # Xserver
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      
      displayManager = {
        slim = {
          enable = true;
          defaultUser = "cole";
        };  
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: with haskellPackages; [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
        ];
      };
      windowManager.default = "xmonad";

      desktopManager.default = "none";
      desktopManager.xterm.enable = false;
    };

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

  # Define user account
  users.extraUsers.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    passwordFile = "/etc/nixos/passwords/cole";
  };

  # Disable mutable users to only allow new users through this file
  users.mutableUsers = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
