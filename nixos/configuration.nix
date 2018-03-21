{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

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
    dmenu stalonetray
    haskellPackages.xmobar
    konsole compton xscreensaver
    scrot
    xorg.libX11 xorg.libxcb xdg_utils
    gcc clang wget gnumake unzip vim
    jdk
    vlc
    libelf
    ((pkgs.callPackage ./programs/nix-home.nix) {})
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker-edge;

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
  virtualisation.virtualbox.host.enable = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;

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

      #videoDrivers = [ "nvidiaLegacy340" "intel" ];

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

    # Udev U2F support
    # and Xbox support
    udev.extraRules = ''
ACTION!="add|change", GOTO="u2f_end"

# Yubico YubiKey
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", MODE="0660", GROUP="users", TAG+="uaccess"

LABEL="u2f_end"

# This fixes the issue where Steam  weren't detecting the controller. My
# theory is that the games needed (wanted) access to the raw USB device rather
# than any interface (/dev/js0)
#
# Device info:
# ID 045e:028e Microsoft Corp. Xbox360 Controller
# fix permissions on /dev/usb/???/???
SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", GROUP="plugdev", MODE="0664"
# fix permissions on /dev/input/event*
SUBSYSTEMS=="input" ATTRS{name}=="Microsoft X-Box 360 pad", GROUP="plugdev", MODE="0640"
    '';
  };

  # U2F PAM
  security.pam.enableU2F = true;

  # Define user account
  users.extraUsers.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    passwordFile = "/etc/nixos/passwords/cole";
  };
  users.extraGroups.docker = {
    name = "docker";
    members = [ "cole" ];
  };
  users.extraGroups.plugdev = {
    name = "plugdev";
    members = [ "cole" ];
  };

  # Disable mutable users to only allow new users through this file
  users.mutableUsers = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
  system.copySystemConfiguration = true;
}
