params@{ pkgs, config, lib, ... }:
let
  # Master for packages that need real time updates
  master = import <nixpkgs-master> { config = { allowUnfree = true; }; };
  
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
      allowBroken = true;
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

      direnv = {                                                                                          
        enable = true;                                                                                    
        nix-direnv.enable = true;                                                                
      };
    };

    home.packages = with pkgs; [
      pass
      qemu
      libnotify

      ripgrep

      # GTK
      lxappearance
      breeze-gtk

      # Sway
      sway
      wl-clipboard

      # Applications
      kitty w3m
      slack spotify
      master.discord # We need the most up to date
      steam xboxdrv # Steam + utils
      pavucontrol # Audio
      feh # Image viewer
      zathura # PDF Viewer
      chromium # firefox-beta-bin

      # OCTAVEEEEE
      (octave.withPackages (ps: with ps; [ control ]))

      # Programming
      elmPackages.elm elmPackages.elm-format # Elm
      gcc #(lowPrio clang) # C(++)
      go # Go
      #idris # Idris
      mitscheme # Scheme
      nodejs yarn # Node
      python python3 # Pseudocode
      rustup # Rust version manager
      ghc stack cabal-install haskellPackages.ghcid # Haskell
      sbcl
      lispPackages.quicklisp

      # Programming utils
      uncrustify astyle

      # Libraries and utils
      # oraclejdk
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
      vim tmux htop nvtop
      cmus ranger newsboat
      graphviz
      #nixops

      gcc-arm-embedded openocd

      wf-recorder
      cv

      # Scripts
      scripts.physexec
    ];

    services.blueman-applet.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryFlavor = "gtk2";
    };
    services.yubikey-touch-detector = {
      enable = true;
      package = pkgs.yubikey-touch-detector;
    };

    xresources.properties = {
      "Xft.dpi" = 96; # The ideal dpi
    };

    services.lorri.enable = true;

    # All home config files
    home.file.".npmrc".source = ./files/.npmrc;
    home.file.".xmobarrc".source = ./files/.xmobarrc;
    home.file.".tmux.conf".source = ./files/.tmux.conf;
    home.file.".stalonetrayrc".source =  ./files/.stalontrayrc;
    home.file.".config/kitty/kitty.conf".source = ./files/.config/kitty/kitty.conf;
    home.file."wallpaper.png".source = ./files/wallpaper.png;
    home.file.".gnupg/gpg.conf".source = ./files/.gnupg/gpg.conf;
    home.file.".stack/config.yaml".source = ./files/.stack/config.yaml;
    home.file.".emacs.d" = {
      source = ./files/.emacs.d;
      recursive = true;
    };
    home.file.".config/waybar" = {
      source = ./files/.config/waybar;
      recursive = true;
    };
    
    home.file.".clang_complete".text = ''
      -I${pkgs.gcc-unwrapped}/include/c++
    '';
    home.file.".config/sway/config".text = pkgs.callPackage ./sway.nix {};
    home.file.".config/i3/config".text = pkgs.callPackage ./i3.nix {};

    # Enable gdb dashboard
    home.file.".gdbinit".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/6c22257da6761aa8f5dabbc7a4c846e5a2d4d0ab/.gdbinit";
      sha256 = "sha256-W8HJCfYdADdM+/f9yUkRM081QcD1Pt9I73wlicCGWko=";
    };
  };
}
