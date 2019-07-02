{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    zimfw = {
      enable = true;
      theme = "eriner";
      inputMode = "vi";
    };
    interactiveShellInit = ''
      [ -n "$TMUX" ] && export TERM=screen-256color
      fortune -s -o computers | cowthink -f bunny | lolcat
      EDITOR="nvim";
      DEFAULT_USER="$USER";
      PATH=$HOME/.npm-packages/bin:$PATH:$HOME/.local/bin:$HOME/go/bin

      # Setup gpg agent
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

      export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'
    '';
    shellAliases = {
      mnt = "udisksctl mount -b";
      vi = "nvim";
      vim = "nvim";
      dd = "dd status=progress";
      g = "git";
      git-prune-branches = "git branch --merged master | grep -v \"^[ *]*master$\" | xargs git branch -d";
    };
  };
  # Add required packages for beautiful fortune
  environment.systemPackages = with pkgs; [
    fortune cowsay lolcat
  ];
}
