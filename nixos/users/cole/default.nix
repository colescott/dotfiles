let pkgsUnstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
) { }; in { pkgs, ... }:

{
  home.packages = with pkgs; [
    htop fortune cowsay lolcat feh
    google-chrome slack
    lastpass-cli google-play-music-desktop-player
    discord steam xboxdrv
    xclip stalonetray
    xorg.xbacklight
    tmux
    uncrustify
    cmus
    nox nix-index
    travis git-hub
    stack ghc
    go
    nodejs-8_x yarn
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-reactor
    python
    python3

    # Git diff
    gitAndTools.diff-so-fancy

    # For rust
    rustup

    (import ../../programs/franz.nix)
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.git = import ./git.nix;
  programs.zsh = import ./zsh.nix { pkgs = pkgs; };
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withPython = true;
    configure.customRC = import ./neovim.nix;
  };

  xsession.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    config = ./xmonad.hs;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: with haskellPackages; [
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
    ];
  };

  services.xscreensaver.enable = true;

  # compton is used as a window compositor
  services.compton = {
    enable = true;
    fade = true;
    fadeDelta = 2;
  };

  # stalonetray is used as a tray for programs
  services.stalonetray = {
    enable = true;
    config = {
      background = "#042C4D";
      geometry = "5x1-0+0";
      max_geometry = "5x1-160+0";
      icon_size = 24;
      sticky = true;
      grow_gravity = "NW";
      icon_gravity = "NW";
      window_type = "dock";
      window_layer = "bottom";
      skip_taskbar = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # All home config files
  home.file.".zimrc".source = ./zimrc;
  home.file.".npmrc".text = ''
prefix = ''${HOME}/.npm-packages
save-exact = true
  '';
  home.file.".xmobarrc".source = ./xmobarrc;
  home.file.".tmux.conf".source = ./tmux.conf;

}
