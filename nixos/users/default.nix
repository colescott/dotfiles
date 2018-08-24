{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.cole = {
      isNormalUser = true;
      home = "/home/cole";
      description = "Cole Scott";
      extraGroups = [ "wheel" "networkmanager" "vboxusers" "plugdev" "docker" ];
      uid = 1000;
      shell = pkgs.zsh;
      passwordFile = "/etc/nixos/passwords/cole";
    };
  };
  home-manager.users.cole = import ./cole pkgs;
}
