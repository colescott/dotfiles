pkgs:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.git = import ./git.nix;
  programs.neovim = import ./neovim.nix;
  programs.newsboat = import ./newsboat.nix;

  home.packages = with pkgs; [
    haskellPackages.xmobar
    dmenu stalonetray
    kitty
  ];

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

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # All home config files
  home.file.".npmrc".source = ./npmrc;
  home.file.".xmobarrc".source = ./xmobarrc;
  home.file.".tmux.conf".source = ./tmux.conf;
  home.file.".stalonetrayrc".source =  ./stalontrayrc;
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
}
