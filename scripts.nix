{ pkgs, ... }:

let 
  iommuGroups = pkgs.writeScriptBin "iommuGroups"
    ''
      #!${pkgs.bash}/bin/bash
      set -e -o pipefail

      shopt -s nullglob
      for d in /sys/kernel/iommu_groups/*/devices/*; do 
          n=''${d#*/iommu_groups/*}; n=''${n%%/*}
          printf 'IOMMU Group %s ' "$n"
          ${pkgs.pciutils}/bin/lspci -nns "''${d##*/}"
      done;
    '';
  replace-ssh-agent = pkgs.writeScriptBin "replace-ssh-agent"
    ''
      #!${pkgs.bash}/bin/bash
      set -e -o pipefail

      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      gpg-connect-agent updatestartuptty /bye
    '';
in
{
  environment.systemPackages = 
   [ iommuGroups
     replace-ssh-agent
   ];
}
