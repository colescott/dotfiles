with import <nixpkgs> {};
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.openssh;
in
{
  options.features.openssh = {
    enable = mkEnableOption "Enable SSH server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      allowSFTP = false;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
  systemd.services = {
    openvpn-reconnect = {
      description = "Restart OpenVPN after suspend";
      script = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
      wantedBy = ["sleep.target"];
    };
  };
}
