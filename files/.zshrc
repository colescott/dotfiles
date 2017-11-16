#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

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
  NEXT=$(tmux ls | sed '/\(attached\)/d' | sed 's/[^0-9]*:.*//g' | head -1)
  if [ ! -z $NEXT ]; then 
    tmux -u2 attach -t $NEXT && exit
  else
    tmux -u2 && exit
  fi
fi

PATH=$PATH:/home/cole/.local/bin
PATH=$PATH:/home/cole/.cabal/bin
PATH=$PATH:/home/cole/.npm-packages/bin

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

DEFAULT_USER="cole"

fortune -s -o computers | cowthink -f bunny | lolcat

alias vi='nvim'
alias vim='nvim'
alias chrome='google-chrome-stable'
alias chrome-kiwi='google-chrome-stable --user-data-dir=~/.config/google-chrome-kiwi --class="chrome-kiwi"'
alias conda-shell='nix-shell ~/.conda-shell.nix'
alias dd='dd status=progress'
alias g='git'
alias gitconfig='$EDITOR ~/.gitconfig'
alias n='npm'
alias nix-config='sudo $EDITOR /etc/nixos/configuration.nix'
alias stack='stack --nix'
alias zshrc='$EDITOR ~/.zshrc && source ~/.zshrc'


