{ pkgs, ... }:

let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  /*nixpkgs.config.packageOverrides = {
    wayland = unstable.wayland;
  };*/
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      xwayland
      unstable.waybar
    ];
  };
  programs.light.enable = true;
}
