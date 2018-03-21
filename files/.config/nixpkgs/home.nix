let pkgsUnstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
) { }; in pkgs:

{
  home.packages = with pkgsUnstable; [
    htop fortune cowsay lolcat
    google-chrome slack resilio-sync franz
    lastpass-cli google-play-music-desktop-player
    discord steam xboxdrv
    xclip stalonetray
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
    python
    python3
    # Git diff
    gitAndTools.diff-so-fancy

    # For go deoplete
    python27Packages.neovim
    python36Packages.neovim
    # For rust
    rustup
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
