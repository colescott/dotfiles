{
  enable = true;
  
  shellAliases = {
    zshrc = "$EDITOR ~/.zshrc && source ~/.zshrc";
    gitconfig = "$EDITOR ~/.gitconfig";
    nix-config = "sudo $EDITOR /etc/nixos/configuration.nix";
    n = "npm";
    g = "git";
    dd = "dd status=progress";
    stack = "stack --nix";
  };

  initExtra = ''
    function nix-search() { nix-env -qa \* -P | fgrep -i "$1"; }
    function nix-install() { nix-env -iA $1; }
    function nix-list() { nix-env -q; }
    function nix-update() { nix-env -u --keep-going --leq; sudo nixos-rebuild switch --upgrade; }
    function nix-rebuild {
      sudo nixos-rebuild switch;
      sudo mkdir /mnt-boot;
      sudo mount /dev/sda2 /mnt-boot;
      sudo cp /boot/loader/ /mnt-boot/ -R;
      sudo cp /boot/efi/ /mnt-boot/ -R;
      sudo umount /mnt-boot;
      sudo rmdir /mnt-boot;
    }
    function nix-remove-old-versions() { nix-env --delete-generations old; nix-collect-garbage; }
    function nix-remove() { nix-env -e $1; }
    function networkman() { nmtui; }
    function x-update-theme() { xrdb -merge ~/.Xresources; }
    function usb() { udisksctl mount -b $1; }

    [ -n "$TMUX" ] && export TERM=screen-256color
    #TERM=xterm-256color

    if ! { [ -n "$TMUX" ]; } then
      tmux -u2 && exit
    fi

    # Source zim
    if [[ -s ''${ZDOTDIR:-''${HOME}}/.zim/init.zsh ]]; then
      source ''${ZDOTDIR:-''${HOME}}/.zim/init.zsh
    fi

    PATH=$PATH:/home/cole/.local/bin
    PATH=$PATH:/home/cole/.cabal/bin

    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.nix-profile/lib

    DEFAULT_USER="cole"

    fortune -s -o computers | cowthink -f bunny | lolcat
  '';
}

