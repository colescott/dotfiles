# Zsh config

{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    st = pkgs.callPackage ./st {
      patches =
        [ ./st/st-meslo-for-powerline.diff
          ./st/st-solarized-dark.diff
          ./st/st-0.5-no-bold-colors.diff ];
    };
  };
}