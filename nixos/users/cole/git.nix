{ pkgs, ... }:

{
    enable = true;
    userName = "Cole Scott";
    userEmail = "me@colescott.io";
    
    aliases = {
      unstage = "reset HEAD --";
      co = "checkout";
      f = "fetch";
      l = "log --format=oneline --abbrev-commit --graph";
      ll = "log --format=fuller --date=relative --graph --stat";
      s = "status";
      r = "rebase";
      ri = "rebase -i";
      m = "merge --ff-only";
      cr = "cherry-pick";
      undo = "reset HEAD~";
      b = "branch";
      mb = "checkout -b";
      db = "branch -d";
      ignore = "update-index --skip-worktree";
      unignore = "update-index --no-skip-worktree";
      ignored = "!git ls-files -v | grep \'^S\'";
    };
    
    signing = {
      signByDefault = true;
      key = "C1E8E9F35739CC98";
    };
    
    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
        pager = ''
          ${pkgs.unstable.gitAndTools.delta}/bin/delta --plus-color="#012800" --minus-color="#340001" --theme=none --hunk-style=plain'';
      };
      commit = { verbose = true; };
      status = {
        showStatus = true;
        submoduleSummary = true;
      };
      interactive = {
        diffFilter =
          "${pkgs.unstable.gitAndTools.delta}/bin/delta --color-only --theme=none";
      };
      diff = { mnemonicPrefix = true; };
      push = { default = "current"; };
      pull = { ff = "only"; };
    };
    
    ignores = [
        # Virtualenv
        # http://iamzed.com/2009/05/07/a-primer-on-virtualenv/
        ".Python"
        "[Bb]in"
        "[Ii]nclude"
        "[Ll]ib"
        "[Ll]ib64"
        "[Ll]ocal"
        "[Ss]cripts"
        "pyvenv.cfg"
        ".venv"
        "pip-selfcheck.json"

        # Vim
        # Swap
        "[._]*.s[a-v][a-z]"
        "!*.svg"  # comment out if you don't need vector files
        "[._]*.sw[a-p]"
        "[._]s[a-rt-v][a-z]"
        "[._]ss[a-gi-z]"
        "[._]sw[a-p]"

        # Session
        "Session.vim"
        "Sessionx.vim"

        # Temporary
        ".netrwhist"
        "*~"
        # Auto-generated tag files
        "tags"
        # Persistent undo
        "[._]*.un~"

        # Emacs
        "*~"
        "\\#*\\#"
        "/.emacs.desktop"
        "/.emacs.desktop.lock"
        "*.elc"
        "auto-save-list"
        "tramp"
        ".\\#*"
        
        # Org-mode
        ".org-id-locations"
        "*_archive"
        
        # flymake-mode
        "*_flymake.*"
        
        # eshell files
        "/eshell/history"
        "/eshell/lastdir"
        
        # elpa packages
        "/elpa/"
        
        # reftex files
        "*.rel"
        
        # AUCTeX auto folder
        "/auto/"
        
        # cask packages
        ".cask/"
        "dist/"
        
        # Flycheck
        "flycheck_*.el"
        
        # projectiles files
        ".projectile"
        
        # directory configuration
        ".dir-locals.el"
        
        # network security
        "/network-security.data"
    ];
}
