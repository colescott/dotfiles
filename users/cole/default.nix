params@{ config, pkgs, lib, nix-modules, ... }:
let
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
      "disk"
      "root"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = "/etc/nixos-secrets/passwords/cole";
  };

  home-manager.users.cole = {
    imports = [
      nix-modules.home-manager
    ];

    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
      waybar = pkgs.waybar.override { pulseSupport = true; };
    };

    programs = {
      git = import ./git.nix { inherit pkgs lib; };
      neovim = import ./neovim.nix { inherit pkgs lib; };
      newsboat = import ./newsboat.nix { inherit pkgs lib; };
      rofi = import ./rofi.nix { inherit pkgs lib; };

      # Emacs
      emacs = import ./emacs.nix { inherit pkgs lib; };
      zsh = import ./zsh.nix { inherit pkgs lib; };

      mako.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    home.packages = with pkgs; [
      nix-tree

      pass
      qemu
      libnotify

      ripgrep
      httpie
      cloc
      socat

      # GTK
      lxappearance
      breeze-gtk

      # Sway
      sway swaylock
      wl-clipboard

      # Applications
      kitty w3m
      slack spotify
      unstable.discord # We need the most up to date
      xboxdrv # Steam + utils
      pavucontrol # Audio
      feh # Image viewer
      zathura # PDF Viewer
      chromium # firefox-beta-bin
      texlive.combined.scheme-full
      kicad

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
      rustup rust-analyzer cargo-edit cargo-udeps # Rust
      ghc stack cabal-install haskellPackages.ghcid # Haskell
      sbcl
      lispPackages.quicklisp
      protobuf grpcui sqlx-cli

      # Programming utils
      uncrustify astyle

      # Docker
      dive

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
      vim htop nvtop
      cmus ranger newsboat
      graphviz

      gcc-arm-embedded openocd

      cura

      arandr usbutils pciutils

      wf-recorder
      progress

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

    programs.tmux = {
      enable = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];

      prefix = "C-a";
      terminal = "screen-256color";
      escapeTime = 0;
      keyMode = "vi";
      baseIndex = 1;

      customPaneNavigationAndResize = true;

      extraConfig = ''
set -g status-right "#H | %A %d-%B %r %P"

# Accept vim navigate
not_tmux='`echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"` || `echo "#{pane_start_command}" | grep -iqE "fzf"` || `echo "#{pane_current_command}" | grep -iqE "fzf"`'
bind-key -n C-h if-shell "$not_tmux" "send-keys C-h" "select-pane -L"
bind-key -n C-j if-shell "$not_tmux" "send-keys C-j" "select-pane -D"
bind-key -n C-k if-shell "$not_tmux" "send-keys C-k" "select-pane -U"
bind-key -n C-l if-shell "$not_tmux" "send-keys C-l" "select-pane -R"
bind-key -n C-\ if-shell "$not_tmux" "send-keys C-\\" "select-pane -l"

#### COLOUR (Solarized 256)

# default statusbar colors
set-option -g status-bg colour235 #base02
set-option -g status-fg colour136 #yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg colour244 #base0
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim

# active window title colors
set-window-option -g window-status-current-fg colour166 #orange
set-window-option -g window-status-current-bg default
#set-window-option -g window-status-current-attr bright

# pane border
set-option -g pane-border-fg colour235 #base02
set-option -g pane-active-border-fg colour240 #base01

# message text
set-option -g message-bg colour235 #base02
set-option -g message-fg colour166 #orange

# pane number display
set-option -g display-panes-active-colour colour33 #blue
set-option -g display-panes-colour colour166 #orange

# clock
set-window-option -g clock-mode-colour colour64 #green

# bell
set-window-option -g window-status-bell-style fg=colour235,bg=colour160 #base02, red
      '';
    };

    # All home config files
    home.file.".npmrc".source = ./files/.npmrc;
    home.file.".xmobarrc".source = ./files/.xmobarrc;
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
    home.file.".gdbinit".text = 
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/6c22257da6761aa8f5dabbc7a4c846e5a2d4d0ab/.gdbinit";
      sha256 = "sha256-W8HJCfYdADdM+/f9yUkRM081QcD1Pt9I73wlicCGWko=";
    } + ''
dashboard -style prompt_not_running '\[\e[1;31m\]>>>\[\e[0m\]'
dashboard -style style_low '1;31'
    '');

    home.stateVersion = "22.05";
  };

  # Allow for swaylock to work
  programs.sway.enable = true;
}
