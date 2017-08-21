{
    enable = true;
    userName = "Cole Scott";
    userEmail = "colescottsf@gmail.com";
    
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
      key = "792460FD4173F480";
    };
  }
