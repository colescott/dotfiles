{ pkgs }:

{
  enable = true;
  plugins = [
    {
      name = "zim";
      file = "init.sh";
      src = pkgs.fetchFromGitHub {
        owner = "zimfw";
        repo = "zimfw";
        rev = "2f0243e";
        sha256 = "149ln6z6qxx871pxa9487jcsn0wqjnmf4nfdsj79vn62cg5frqkw";
      };
    }
  ];
  sessionVariables = {
    EDITOR = "nvim";
    DEFAULT_USER = "cole";
    PATH = ''$HOME/.npm-packages/bin:\
      $PATH:\
      $HOME/.local/bin:\
      $HOME/go/bin
    '';
  };
  initExtra = ''
    [ -n "$TMUX" ] && export TERM=screen-256color
    fortune -s -o computers | cowthink -f bunny | lolcat
  '';
  shellAliases = {
    usb = "udisksctl mount -b";
    vi = "nvim";
    vim = "nvim";
    dd = "dd status=progress";
    g = "git";
    git-prune-branches = "git branch --merged master | grep -v '^[ *]*master$' | xargs git branch -d";
    uncrustify = "uncrustify -c ~/.uncrustify";
    android = "wmname LG3D; ANDROID_EMULATOR_USE_SYSTEM_LIBS=1 android-studio";
  };
}
