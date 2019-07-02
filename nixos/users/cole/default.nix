{ pkgs, ... }:

{
  users.users.cole = {
    isNormalUser = true;
    home = "/home/cole";
    description = "Cole Scott";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" "docker" "plugdev" "dialout" "sound" "audio" ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = "/etc/nixos/passwords/cole";
  };

  home-manager.users.cole = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    programs.git = import ./git.nix;
    programs.neovim = import ./neovim.nix;
    programs.newsboat = import ./newsboat.nix;
    programs.rofi = import ./rofi.nix;

    home.packages = with pkgs; [
      stalonetray
      kitty
      pass
    ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    # All home config files
    home.file.".config/sway/config".text = pkgs.callPackage ./sway.nix {};
    home.file.".npmrc".source = ./files/npmrc;
    home.file.".xmobarrc".source = ./files/xmobarrc;
    home.file.".tmux.conf".source = ./files/tmux.conf;
    home.file.".stalonetrayrc".source =  ./files/stalontrayrc;
    home.file.".config/kitty/kitty.conf".source = ./files/kitty.conf;
    home.file."wallpaper.png".source = ./files/wallpaper.png;
    home.file.".gnupg/gpg.conf".source = ./files/gpg.conf;

    # Bin dir
    home.file.".local/bin/chrome" = {
      text = "google-chrome-stable";
      executable = true;
    };
    home.file.".local/bin/volume.sh" = {
      source = ./files/volume.sh;
      executable = true;
    };
  };
}
