{ pkgs, ... }:

{
    enable = true;
    userName = "Cole Scott";
    userEmail = "me@colescott.io";
    
    aliases = {
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      co = "checkout";
      f = "fetch";
      rf = "checkout HEAD";
      l = "log --format=oneline --abbrev-commit --graph";
      ll = "log --format=fuller --date=relative --graph --stat";
      l-simple = "log --format=oneline --abbrev-commit --date=relative --graph --first-parent";
      s = "status";
      c = "commit -m";
      amd = "commit --amend -m";
      r = "rebase";
      ri = "rebase -i";
      m = "merge --ff-only";
      cr = "cherry-pick";
      undo = "reset HEAD~";
      b = "branch";
      mb = "checkout -b";
      db = "branch -d";
      ch = "checkout";
      ignore = "update-index --skip-worktree";
      unignore = "update-index --no-skip-worktree";
      ignored = "!git ls-files -v | grep \'^S\'";
    };
    
    signing = {
      signByDefault = true;
      key = "C1E8E9F35739CC98";
    };
    extraConfig = ''
[core]
pager="${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=4 -RFX"

[color]
ui=true
      
[color "diff-highlight"]
oldNormal=red bold
oldHighlight=red bold 52
newNormal=green bold
newHighlight=green bold 22

[color "diff"]
meta=yellow
frag=magenta bold
commit="yellow bold"
old="red bold"
new="green bold"
whitespace="red reverse"
'';
  }
