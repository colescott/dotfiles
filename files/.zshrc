[ -n "$TMUX" ] && export TERM=screen-256color
#TERM=xterm-256color

if ! { [ -n "$TMUX" ]; } then
  tmux -u2 && exit
fi

#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

PATH=$PATH:/home/cole/.local/bin
PATH=$PATH:/home/cole/.cabal/bin

# Stack GHC
alias stack="stack --nix"


LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.nix-profile/lib

DEFAULT_USER="cole"

fortune -s -o computers | cowthink -f bunny | lolcat

# added by travis gem
[ -f /home/cole/.travis/travis.sh ] && source /home/cole/.travis/travis.sh

