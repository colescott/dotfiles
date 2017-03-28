# ZSH Setup
export ZSH=/home/cole/.oh-my-zsh
ZSH_THEME="agnoster"

# ZSH Config
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DEFAULT_USER="cole"

# ZSH Plugins
plugins=(
	zsh-autosuggestions
	npm
	node
	gitfast
	last-working-dir
	per-directory-history
	sprunge
	vi-mode
	web-search
)

source $ZSH/oh-my-zsh.sh


#NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Ruby setup
export GEM_HOME="$HOME/projects/shared/gems/ruby/1.8/gems"
export GEM_PATH="$GEM_HOME:/var/lib/ruby/gems/1.8"
export PATH=$PATH:$GEM_HOME/bin

# npm setup
export PATH=$PATH:$HOME/.npm-packages/bin

# ant setup
export PATH=$PATH:$HOME/ant/bin

# Go Setup
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Other config
export EDITOR=vim

#
# Aliases
#

# Useful Commands
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias gitconfig="$EDITOR ~/.gitconfig"
alias nix-config="sudo $EDITOR /etc/nixos/configuration.nix"

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

PATH=$PATH:/usr/local/bin

# Shorthands
alias n=npm
alias g=git

# added by travis gem
[ -f /home/cole/.travis/travis.sh ] && source /home/cole/.travis/travis.sh

# Add /usr/bin to path
export PATH=$PATH:/usr/bin
