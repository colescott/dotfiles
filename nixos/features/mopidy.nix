{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.features.mopidy;

  extensionPackages = cfg.extensionPackages
    ++ optional cfg.spotify.enable pkgs.mopidy-spotify
    ++ optional cfg.mpd.enable pkgs.mopidy-mpd;
in
{
  options.features.mopidy = {
    enable = mkEnableOption "The Mopidy music daemon";
    mediaDirs = mkOption {
      description = "Directories Mopidy daemon will scan for music";
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            description = "Common name of media location";
            type = types.str;
          };
          path = mkOption {
            description = "Path of media location";
            type = types.str;
          };
        };
      });
      default = [ ];
    };
    extensionPackages = mkOption {
      description = "Extension packages to be installed in mopidy";
      type = types.listOf types.package;
      default = [ ];
    };
    pulseServer = mkOption {
      description = "Address of pulseaudio server to attach to";
      type = types.str;
      default = "127.0.0.1";
    };
    spotify = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Spotify support for Mopidy";
          credentials = mkOption {
            type = types.submodule {
              options = {
                username = mkOption {
                  description = "Spotify username";
                  type = types.str;
                };
                password = mkOption {
                  description = "Spotify password";
                  type = types.str;
                };
                client_id = mkOption {
                  description = "Spotify API client id";
                  type = types.str;
                };
                client_secret = mkOption {
                  description = "Spotify API client secret";
                  type = types.str;
                };
              };
            };
          };
          bitrate = mkOption {
            description = "Bitrate for streaming on spotify";
            type = types.int;
            default = 320;
          };
          volumeNormalization = mkOption {
            description = "Whether to enable volume normalization on spotify";
            type = types.bool;
            default = false;
          };
        };
      };
    };
    mpd = {
      enable = mkEnableOption "mpd support for Mopidy";
    };
  };
  config = mkIf cfg.enable {
    services.mopidy = {
      enable = true;
      extensionPackages = extensionPackages;
      configuration = ''
        [audio]
        output = pulsesink server=127.0.0.1

        ${optionalString cfg.spotify.enable ''
          [spotify]
          username = ${cfg.spotify.credentials.username}
          password = ${cfg.spotify.credentials.password}
          client_id = ${cfg.spotify.credentials.client_id}
          client_secret = ${cfg.spotify.credentials.client_secret}
          bitrate = ${builtins.toString cfg.spotify.bitrate}
          volume_normalization = ${lib.boolToString cfg.spotify.volumeNormalization}

        ''}

        [file]
        enabled = true
        media_dirs = ${concatStringsSep "\n" (builtins.map (dir: "${dir.path}|${dir.name}") cfg.mediaDirs)}
        show_dotfiles = false
        excluded_file_extensions =
          .jpg
          .jpeg
          .txt
          .url
          .png
          .log
          .cue
          .CUE
          .m3u
          .ini
          .bmp
          .pdf
          .zip
        follow_symlinks = false
        metadata_timeout = 1000

        [http]
        enabled = true

        ${optionalString cfg.mpd.enable ''
          [mpd]
          enabled = true
          hostname = 127.0.0.1
          port = 6600
          password =
          max_connections = 20
          connection_timeout = 60
          zeroconf =

        ''}
      '';
    };

    hardware.pulseaudio.tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    };
  };
}
