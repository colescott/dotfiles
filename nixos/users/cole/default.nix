params@{ pkgs, config, lib, ... }:
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  
  # XXX: This is a hack to get callPackage to import the current scope
  callPackageWith = autoArgs: fn: args:
  let
    f = if lib.isFunction fn then fn else import fn;
    auto = builtins.intersectAttrs (lib.functionArgs f) autoArgs;
  in f (auto // args);
  callPackage = callPackageWith params;

  scripts = pkgs.callPackage ./scripts.nix {};
in
rec {
  users.users.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers" "docker" "lxd" "libvirtd"
      "plugdev" "dialout"
      "sound" "audio"
      "video"
      "tty"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = "/etc/nixos/passwords/cole";
  };

  home-manager.users.cole = {
    imports = [
      ../../../nix-modules/home-manager
    ];
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
      waybar = pkgs.waybar.override { pulseSupport = true; };
    };

    programs = {
      git = callPackage ./git.nix {};
      neovim = callPackage ./neovim.nix {};
      newsboat = callPackage ./newsboat.nix {}; 
      rofi = callPackageWith pkgs ./rofi.nix {};
      firefox = callPackage ./firefox.nix {};

      # Emacs
      emacs = callPackage ./emacs.nix {};
      zsh = callPackage ./zsh.nix {};

      mako.enable = true;
    };
    services.emacs.enable = true;

    home.packages = with pkgs; [
      pass
      qemu
      libnotify

      ripgrep

      # GTK
      lxappearance
      breeze-gtk

      # Applications
      kitty
      slack spotify discord
      steam xboxdrv # Steam + utils
      pavucontrol # Audio
      feh # Image viewer
      zathura # PDF Viewer
      chromium # firefox-beta-bin

      # Programming
      elmPackages.elm elmPackages.elm-format # Elm
      gcc #(lowPrio clang) # C(++)
      go # Go
      idris # Idris
      mitscheme # Scheme
      nodejs yarn # Node
      python python3 # Pseudocode
      rustup # Rust version manager
      ghc stack cabal-install haskellPackages.ghcid # Haskell
      # (all-hies.selection { selector = p: { inherit (p) ghc865 ghc864 ghc863 ghc843; }; })
      #sbcl
      lispPackages.quicklisp

      # Programming utils
      uncrustify astyle

      # Libraries and utils
      oraclejdk
      libelf
      xorg.libX11 xorg.libxcb
      ntfs3g # Write support for NTFS
      jq

      # Command line utils
      git
      xclip xdg_utils
      transmission-gtk # Torrent client
      unzip wget gnumake
      travis git-hub
      vim tmux htop
      cmus ranger newsboat
      nixops

      gcc-arm-embedded openocd

      wf-recorder
      cv

      # Scripts
      scripts.musicbee scripts.musicbee-setup
      scripts.physexec
    ];

    # Fonts
    # fonts.fontconfig.enable = true;

    services.blueman-applet.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryFlavor = "gtk2";
    };
    services.yubikey-touch-detector = {
      enable = true;
      package = pkgs.nur.repos.mic92.yubikey-touch-detector;
    };

    xresources.properties = {
      "Xft.dpi" = 96; # The ideal dpi
    };

    services.lorri.enable = true;

    # All home config files
    home.file.".npmrc".source = ./files/npmrc;
    home.file.".xmobarrc".source = ./files/xmobarrc;
    home.file.".tmux.conf".source = ./files/tmux.conf;
    home.file.".stalonetrayrc".source =  ./files/stalontrayrc;
    home.file.".config/kitty/kitty.conf".source = ./files/kitty.conf;
    home.file."wallpaper.png".source = ./files/wallpaper.png;
    home.file.".gnupg/gpg.conf".source = ./files/gpg.conf;
    home.file.".stack/config.yaml".source = ./files/stack-config.yaml;

    home.file.".clang_complete".text = pkgs.callPackage ./clang-complete.nix {};
    home.file.".config/sway/config".text = pkgs.callPackage ./sway.nix {};

    home.file.".emacs.d" = {
      source = ./files/emacs;
      recursive = true;
    };
    home.file.".config/waybar" = {
      source = ./files/waybar;
      recursive = true;
    };
  };
}
