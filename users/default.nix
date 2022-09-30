{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  # All users
  imports = [
    ./cole
  ];
}
