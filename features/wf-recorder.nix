{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.features.wf-recorder;
  
  wf-screenshare = pkgs.writeScriptBin "wf-screenshare"
    ''
      #!${pkgs.bash}/bin/bash
      set -e -o pipefail
      pkill -x wf-recorder

      [ $? -ne 0 ] && {
          #notify-send -t 2000 'Screen sharing' 'Select an area to start the recording...'
          geometry="$(${pkgs.slurp}/bin/slurp)"
          #{ sleep 1 && pkill -RTMIN+3 -x waybar; } &
          ${pkgs.wf-recorder}/bin/wf-recorder --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file=/dev/video9 --geometry="$geometry"
          #pkill -RTMIN+3 -x waybar
          #notify-send 'Screen sharing' 'Recording is complete'
      }
    '';
in
{
  options.features.wf-recorder = {
    enable = mkEnableOption "Enable wf-recorder screensharing module";
  };

  config = mkIf cfg.enable {
    # Extra kernel modules
    boot.extraModulePackages = with unstable; [
      config.boot.kernelPackages.v4l2loopback
    ];

    # Register a v4l2loopback device at boot
    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9
    '';

    environment.systemPackages = [
      wf-screenshare
    ];
  };
}
