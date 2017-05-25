# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Zsh
      ./programs/zsh.nix
      
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
    gcc clang wget gnumake unzip vim
    jdk
    vlc
    libelf
    (import ./programs/vim.nix) # Vim config
  ];

  # Set default editor to vim
  programs.vim.defaultEditor = true;

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
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
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

    # SSH for my sanity
    openssh = {
      enable = true;
      forwardX11 = true;
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
