# Zsh config

{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    st = pkgs.st.override {
      patches =
        [ ./st/st-meslo-for-powerline-0.7.diff
          ./st/st-solarized-dark-0.7.diff
          ./st/st-no_bold_colors-0.7.diff ];
    };
  };
}
