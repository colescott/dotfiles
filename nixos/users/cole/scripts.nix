{ pkgs, fetchzip, ... }:

let 
  musicbee-installer = "${fetchzip {
    url = "https://www.mediafire.com/file/h0u15f0ctglidp5/MusicBeeSetup_3_3_Update5.zip";
    sha256 = "15akp5xfd1xfzjjp6b6ghnpa8xwmqz0pkhzb5rvzjj8qzkib58m1";
    #name = "MusicBeeSetup_3_3_Update5.zip";
    stripRoot = false;
  }}/MusicBeeSetup_3_3_Update5.exe";
  musicbee-wine-prefix = "$HOME/.WineBee";
in
{
  musicbee-setup = pkgs.writeScriptBin "musicbee-setup" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # Script to set up MusicBee under wine
    # https://getmusicbee.com/forum/index.php?topic=30205.0
    
    # Set up new wine prefix
    WINEARCH=win32 WINEPREFIX=${musicbee-wine-prefix} ${pkgs.wine}/bin/winecfg
    
    # Install required libraries
    WINEPREFIX=${musicbee-wine-prefix} ${pkgs.winetricks}/bin/winetricks -q dotnet48 xmllite gdiplus

    # Install MusicBee
    WINEPREFIX=${musicbee-wine-prefix} ${pkgs.wine}/bin/wine ${musicbee-installer}
  '';
  musicbee = pkgs.writeScriptBin "musicbee" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # Install MusicBee
    WINEPREFIX=${musicbee-wine-prefix} ${pkgs.wine}/bin/wine ${musicbee-wine-prefix}/drive_c/Program\ Files/MusicBee/MusicBee.exe
  '';
  physexec = pkgs.writeScriptBin "physexec" ''
    #! ${pkgs.bash}/bin/bash
    set -eou pipefail
    exec sudo -E ${pkgs.iproute}/bin/ip netns exec physical \
         sudo -E -u \#$(${pkgs.coreutils}/bin/id -u) \
                 -g \#$(${pkgs.coreutils}/bin/id -g) \
                 "$@"
  '';
}
