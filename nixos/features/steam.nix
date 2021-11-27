{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.steam;
in
{
  options.features.steam= {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          gnome3.gtk
          zlib
          dbus
          freetype
          glib
          atk
          cairo
          gdk_pixbuf
          pango
          fontconfig
          xorg.libxcb
        ];
      };
    };

    programs.steam.enable = true;
  };
}
