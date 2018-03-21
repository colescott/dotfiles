#
# User configuration sourced by interactive shells
#

# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

function nix-search() { nix-env -qa \* -P | fgrep -i "$1"; }
function nix-install() { nix-env -iA $1; }
function nix-list() { nix-env -q; }
function nix-update() { nix-env -u --keep-going --leq; sudo nixos-rebuild switch --upgrade; }
function nix-rebuild {
  sudo nixos-rebuild switch;
  sudo mkdir -p /mnt-boot;
  sudo mount /dev/nvme0n1p1 /mnt-boot;
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

#if ! { [ -n "$TMUX" ]; } then
#  NEXT=$(tmux ls | sed '/\(attached\)/d' | sed 's/[^0-9]*:.*//g' | head -1)
#  if [ ! -z $NEXT ]; then 
#    tmux -u2 attach -t $NEXT
#  else
#    tmux -u2
#  fi
#fi
EDITOR=nvim

PATH=$PATH:/home/cole/.local/bin
PATH=$PATH:/home/cole/.cabal/bin
PATH=/home/cole/.npm-packages/bin:$PATH
PATH=$PATH:/home/cole/.gem/ruby/2.3.0/bin
PATH=$PATH:/home/cole/go/bin

#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Start ssh agent
eval `ssh-agent`

DEFAULT_USER="cole"

fortune -s -o computers | cowthink -f bunny | lolcat

alias cd='cd -P'
alias vi='nvim'
alias vim='nvim'
alias conda-shell='nix-shell ~/.conda-shell.nix'
alias dd='dd status=progress'
alias g='git'
alias git-prune-branches='git branch --merged master | grep -v "^[ *]*master$" | xargs git branch -d'
alias gitconfig='$EDITOR ~/.gitconfig'
alias n='npm'
alias nix-config='sudo $EDITOR /etc/nixos/configuration.nix'
alias stack='stack --nix'
alias zshrc='$EDITOR ~/.zshrc && source ~/.zshrc'
alias uncrustify='uncrustify -c ~/.uncrustify'
alias android='wmname LG3D; ANDROID_EMULATOR_USE_SYSTEM_LIBS=1 android-studio'
