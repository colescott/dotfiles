{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.features.vt420;
in
{
  options.features.vt420 = {
    enable = mkEnableOption "vt420";
  };

  config = mkIf cfg.enable {
    systemd.services = {
      vt420 = {
        description = "vt420";
        #after = [ "sys-subsystem-net-devices-${cfg.wirelessInterface}.device" ];
        path = [ pkgs.utillinux ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeScript "vt420-start" ''
            #!${pkgs.bash}/bin/bash
            set -eou pipefail

            ${pkgs.utillinux}/sbin/agetty ttyUSB0 9600 vt420 --nice -10 
          '';
        };
      };
    };
  };
}
