with import <nixpkgs> {};

let
  customPackages.NeoSolarized = pkgs.vimUtils.buildVimPlugin {
    name = "NeoSolarized";
    src = pkgs.fetchFromGitHub {
      owner = "icymind";
      repo = "NeoSolarized";
      rev = "8a9ff861f2bd4b214b9f106edf252f7c5be02a41";
      sha256 = "18cv8j679725jmd67v6fqv3r2n3pi1fh84alm2x7hqggaqh8nd8p";
    };
  };
in

{
  enable = true;
  withPython3 = true;
  withPython = true;
  configure = {
    customRC = import ./nvimrc;
    vam.knownPlugins = pkgs.vimPlugins // customPackages;
    vam.pluginDictionaries = [
      { names = [
        "NeoSolarized" # Solarized theme
        "sensible" # Simple options
        "sleuth" # Buffer options based on related files
        "fugitive" "gitgutter" # Git utils
        "The_NERD_tree" # File tree
        "tmux-navigator"
        "vim-airline" "vim-airline-themes" # Better status bar

        "ale" # Lint and complete
        "LanguageClient-neovim"

        # Language Plugins
        "elm-vim"
        "vim-nix"
        "vim-javascript"
        "typescript-vim"
        "vim-go"
        "vim-polyglot" # Package of 100+ language plugins
        ]; 
      }
      {
        name = "deoplete-nvim";
        exec = ":UpdateRemotePlugins";
      }
    ];
  };
}

