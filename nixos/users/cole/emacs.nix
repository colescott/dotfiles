{ pkgs, ... }:

{
  enable = true;
  extraPackages = epkgs: [
    # Basics
    epkgs.solarized-theme
    epkgs.workgroups2
    epkgs.use-package

    epkgs.multi-term

    # Programming
    epkgs.nix-mode # Nix
    epkgs.slime epkgs.paredit # Lisp
    epkgs.slime-company
    epkgs.haskell-mode
    epkgs.markdown-mode # Markdown

    # Irony
    epkgs.irony epkgs.irony-eldoc epkgs.company-irony epkgs.flycheck-irony
    epkgs.company-irony-c-headers epkgs.clang-format

    # Company
    epkgs.company

    # Helm
    epkgs.helm
    epkgs.helm-company

    # Flycheck
    epkgs.flycheck

    # Org mode
    #epkgs.org-mode
    #epkgs.org-babel
    #epkgs.org-babel-gnuplot
    #epkgs.gnuplot
    #pkgs.gnuplot
   ];
}

