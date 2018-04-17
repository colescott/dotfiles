{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fortune cowsay lolcat
    google-chrome slack spotify discord
    lastpass-cli
    steam xboxdrv # Steam + utils
    nox nix-index # Nix utils
    travis git-hub

    # Programming languages
    stack ghc
    go
    nodejs-8_x yarn
    elmPackages.elm elmPackages.elm-format elmPackages.elm-reactor
    python python3

    uncrustify

    zathura # PDF Viewer
    alsaUtils # Volume control
    gitAndTools.diff-so-fancy
    rustup # Rust version manager

    (import ../../programs/franz.nix)
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.git = import ./git.nix;
  programs.zsh = import ./zsh.nix { pkgs = pkgs; };
  programs.neovim = import ./neovim.nix;
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      config = ./xmonad.hs;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };
    initExtra = ''
      light-locker &
    '';
  };

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
