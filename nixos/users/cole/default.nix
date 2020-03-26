params@{ pkgs, ... }:
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in
{
  users.users.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers" "docker" "lxd"
      "plugdev" "dialout"
      "sound" "audio"
      "video"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = "/etc/nixos/passwords/cole";
  };

  home-manager.users.cole = {
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };

    # TODO: Figure this one out
    programs.git = import ./git.nix params;
    programs.neovim = import ./neovim.nix params;
    programs.newsboat = import ./newsboat.nix params; 
    programs.rofi = import ./rofi.nix params;
    # programs.firefox = import ./firefox.nix params;

    # Emacs
    programs.emacs = import ./emacs.nix params;
    services.emacs.enable = true;

    home.packages = with pkgs; [
      pass
      qemu

      gnuplot # For emacs org-plot

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
      firefox-beta-bin

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
      sbcl lispPackages.quicklisp

      # Programming utils
      uncrustify astyle

      # Libraries and utils
      jdk
      libelf
      xorg.libX11 xorg.libxcb
      ntfs3g # Write support for NTFS
      jq

      # Command line utils
      git
      xclip xdg_utils
      transmission # Torrent client
      unzip wget gnumake
      travis git-hub
      vim tmux htop
      cmus ranger newsboat
      nixops

      gcc-arm-embedded openocd
    ];

    # Fonts
    # fonts.fontconfig.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    # All home config files
    home.file.".config/sway/config".text = pkgs.callPackage ./sway.nix {};
    home.file.".config/waybar/config".source = ./files/waybar/config;
    home.file.".config/waybar/style.css".source = ./files/waybar/style.css;
    home.file.".npmrc".source = ./files/npmrc;
    home.file.".xmobarrc".source = ./files/xmobarrc;
    home.file.".tmux.conf".source = ./files/tmux.conf;
    home.file.".zshrc".source = ./files/zshrc;
    home.file.".stalonetrayrc".source =  ./files/stalontrayrc;
    home.file.".config/kitty/kitty.conf".source = ./files/kitty.conf;
    home.file."wallpaper.png".source = ./files/wallpaper.png;
    home.file.".gnupg/gpg.conf".source = ./files/gpg.conf;
    home.file.".stack/config.yaml".source = ./files/stack-config.yaml;
    home.file.".emacs.d/init.el".source = ./files/emacs/init.el;
    home.file.".emacs.d/irony.el".source = ./files/emacs/irony.el;
    home.file.".emacs.d/fira-code.el".source = ./files/emacs/fira-code.el;
    home.file.".clang_complete".text = pkgs.callPackage ./clang-complete.nix {};
  };
}
