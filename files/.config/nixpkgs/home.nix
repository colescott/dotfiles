let
  pkgs= import (fetchTarball http://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};
in
{
  home.packages = with pkgs; [
    htop fortune cowsay lolcat
    google-chrome spotify slack
    discord steam xboxdrv
    xclip
    tmux
    nox
    travis heroku git-hub
    stack ghc
    python
    yarn nodejs-7_x
  ];

  programs.git = (import ./git.nix);

  xresources = (import ./xresources.nix);

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
