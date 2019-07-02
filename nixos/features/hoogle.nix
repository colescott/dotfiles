{ config, lib, ... }:

with lib;

let
  cfg = config.features.hoogle;
in
{
  options.features.hoogle = {
    enable = mkEnableOption "Enable local Hoogle server";
  };

  config = mkIf cfg.enable {
    services = {
      hoogle = {
        enable = true;
        port = 1248;
        packages = hp: with hp;
           [ base
             text
             lens
             split
             optparse-generic
           ];
      };
    };
  };
}
