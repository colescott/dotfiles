{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.yubikey;
in
{
  options.features.yubikey = {
    enable = mkEnableOption "Enable Yibikey support";
  };

  config = mkIf cfg.enable {
    #hardware.u2f.enable = true;

    services.udev.packages = [ pkgs.yubikey-personalization ];

    #services.pcscd.enable = true;
  };
}
