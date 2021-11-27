{ pkgs, ... }:

let
  customPackages.ghcid-neovim = pkgs.vimUtils.buildVimPlugin {
    name = "ghcid-neovim";
    src = "${pkgs.fetchFromGitHub {
      owner = "ndmitchell";
      repo = "ghcid";
      rev = "v0.8.7";
      sha256 = "0flq6a1yja47hn2h5hvcikmg7ysciscvqm9z1a24vdp890m8zrb3";
    }}/plugins/nvim";
  };
  customPackages.universal-text-linking = pkgs.vimUtils.buildVimPlugin {
    name = "universal-text-linking";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "utl.vim";
      rev = "67a6506a7a8a3847d00d3af3e2ed9707460d5ce5";
      sha256 = "0ax68nmzlka9193n2h82qzvhzv4dv6lm7rg3b1vhj2pn1r6ci6p4";
    };
  };
  customPackages.coc = pkgs.vimUtils.buildVimPlugin {
    name = "coc";
    src = pkgs.fetchFromGitHub {
      owner = "neoclide";
      repo = "coc.nvim";
      rev = "0.0.80";
      sha256 = "0f5vg0cp466krsh3h2sra0bix1myymliz79jf06zw88pbzycvcn7";
    };
  };
in

{
  enable = true;
  withPython3 = true;
  extraConfig = builtins.readFile ./nviminit.vim;
  plugins = with pkgs.vimPlugins; [
    NeoSolarized # Solarized theme
    sensible # Simple options
    sleuth # Buffer options based on related files
    gitgutter # Git utils
    tmux-navigator
    vim-airline vim-airline-themes # Better status bar
    #supertab # Tab completion
    

    #LanguageClient-neovim
    #ale # Lint and complete

    # Language Client
    customPackages.coc

    # Org Mode
    customPackages.universal-text-linking
    SyntaxRange
    vim-orgmode

    # Language Plugins
    elm-vim
    vim-nix
    vim-javascript
    typescript-vim
    vim-go
    #vim-polyglot # Package of 100+ language plugins
    idris-vim
    customPackages.ghcid-neovim
    deoplete-nvim
  ];
}

