{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.vpn;
in
{
  options.features.vpn = {
    enable = mkEnableOption "config for vpn";
    credentials = mkOption {
      type = types.submodule {
        options = {
          username = mkOption {
            type = types.str;
          };
          password = mkOption {
            type = types.str;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.extraCommands = ''
      # Block all outgoing traffic
      iptables -P OUTPUT DROP

      # Allow connections through vpn and local loopback
      iptables -A OUTPUT -o lo -j ACCEPT
      iptables -A OUTPUT -o tun0 -p icmp -j ACCEPT

      # Local Nets
      iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
      iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT

      # Name Servers
      iptables -A OUTPUT -d 209.222.18.222 -j ACCEPT
      iptables -A OUTPUT -d 209.222.18.218 -j ACCEPT

      # Allow connecting to the vpn
      iptables -A OUTPUT -p udp -m udp --dport 1197 -j ACCEPT
      iptables -A OUTPUT -o tun0 -j ACCEPT
    '';
    networking.nameservers = lib.mkForce [ "209.222.18.222" "209.222.18.218" ];

    systemd.services = {
      openvpn-reconnect = {
        description = "Restart OpenVPN after suspend";
        script = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
        wantedBy = ["sleep.target"];
      };
    };

    services.openvpn.servers = {
      pia = {
        config = ''
          cd /home/cole/dotfiles/vpn
	      auth-nocache
	      config US\ Silicon\ Valley.ovpn
	     '';
	     autoStart = true;
	     authUserPass = {
               username = cfg.credentials.username;
	       password = cfg.credentials.password;
	     };
      };
    };
  };
}
