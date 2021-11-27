{ pkgs, lib, ... }:

let
  liblapack = pkgs.liblapack.override { shared = true; };
in
{
  enable = true;
  extraPackages = epkgs: [
    # Basics
    epkgs.solarized-theme
    epkgs.workgroups2
    epkgs.use-package
    epkgs.smart-mode-line

    epkgs.multi-term

    # Programming
    epkgs.nix-mode # Nix
    epkgs.slime epkgs.paredit # Lisp
    epkgs.slime-company
    epkgs.haskell-mode
    epkgs.markdown-mode # Markdown
    epkgs.rainbow-delimiters

    # Irony
    #epkgs.irony epkgs.irony-eldoc epkgs.company-irony epkgs.flycheck-irony
    #epkgs.company-irony-c-headers epkgs.clang-format

    # Company
    epkgs.company

    # Helm
    epkgs.helm
    epkgs.helm-company

    # Flycheck
    epkgs.flycheck

    # LSP
    epkgs.lsp-mode
    epkgs.lsp-ui
    epkgs.helm-lsp

    # Org mode
    #epkgs.org-mode
    #epkgs.org-babel
    #epkgs.org-babel-gnuplot
    epkgs.graphviz-dot-mode
    #epkgs.gnuplot
    #pkgs.gnuplot

    pkgs.libffi
    pkgs.blas
    pkgs.liblapack
    pkgs.gfortran
    (lib.getLib pkgs.gfortran.cc)
    
    pkgs.nixpkgs-fmt
    #pkgs.nur.repos.mic92.rnix-lsp-unstable
  ];
}

