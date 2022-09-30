{ pkgs, fetchzip, ... }:

{
  physexec = pkgs.writeScriptBin "physexec" ''
    #! ${pkgs.bash}/bin/bash
    set -eou pipefail
    exec sudo -E ${pkgs.iproute}/bin/ip netns exec physical \
         sudo -E -u \#$(${pkgs.coreutils}/bin/id -u) \
                 -g \#$(${pkgs.coreutils}/bin/id -g) \
                 "$@"
  '';
}
