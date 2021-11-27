{ pkgs, lib, ... }:

{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;

  initExtra = ''
    [ -n "$TMUX" ] && export TERM=screen-256color
    ${pkgs.fortune}/bin/fortune -s -o computers | ${pkgs.cowsay}/bin/cowthink -f bunny | ${pkgs.lolcat}/bin/lolcat
    DEFAULT_USER="$USER";
    # PATH=$HOME/.npm-packages/bin:$PATH:$HOME/.local/bin:$HOME/go/bin

    # Setup gpg agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

    # Fix pass issue with keyids
    export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'
  '';

  loginExtra = ''
    . /etc/profile
   '';

  /*
  initExtraBeforeCompInit = ''
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ./zshrc.fake.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
    source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
    '';*/
    

  shellAliases = {
    mnt = "udisksctl mount -b";
    vi = "nvim";
    vim = "nvim";
    g = "git";
    git-prune-branches = "git branch --merged master | grep -v \"^[ *]*master$\" | xargs git branch -d";
    ns = "nix-shell --command zsh";
    news = "newsboat";
  };
    
  oh-my-zsh = {
    enable = true;
    plugins = [ "pass" "sudo" ];
  };

  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.unstable.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
      name = "powerlevel10k-config";
      src = lib.cleanSource ./files/p10k-config;
      file = "p10k.zsh";
    }
  ];
}
