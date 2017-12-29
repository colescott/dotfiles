{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop fortune cowsay lolcat
    google-chrome spotify slack
    lastpass-cli
    discord steam xboxdrv
    xclip
    xorg.xbacklight
    tmux
    neovim uncrustify
    cmus
    nox
    travis git-hub
    stack ghc
    python ruby nodejs-8_x yarn
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-reactor
  ];

  programs.git = (import ./git.nix);

  #xresources = (import ./xresources.nix);

  services.xscreensaver.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
