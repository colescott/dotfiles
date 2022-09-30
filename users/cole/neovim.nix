{ pkgs, ... }:

{
  enable = true;
  withPython3 = true;

  coc = {
    enable = true;
    # https://github.com/nix-community/home-manager/issues/2966
    package = pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "coc.nvim";
      version = "2022-06-14";
      src = pkgs.fetchFromGitHub {
        owner = "neoclide";
        repo = "coc.nvim";
        rev = "87e5dd692ec8ed7be25b15449fd0ab15a48bfb30";
        sha256 = "sha256-bsrCvgQqIA4jD62PIcLwYdcBM+YLLKLI/x2H5c/bR50=";
      };
      meta.homepage = "https://github.com/neoclide/coc.nvim/";
    };
    settings = {
      "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "rust-analyzer.procMacro.enable" = true;
      "rust-analyzer.lens.run" = false;
      "rust-analyzer.cargo.runBuildScripts" = true;
      "rust-analyzer.diagnostics.disabled" = ["inactive-code"];
      "rust-analyzer.checkOnSave.command" = "clippy";
      "coc.preferences.enableFloatHighlight" = true;
      "coc.preferences.snippets.enable" = false;
      "suggest.triggerAfterInsertEnter" = true;
      "suggest.minTriggerInputLength" = 2;
      "suggest.noselect" = false;
      "codeLens.enable" = true;
      "diagnostic.warningSign" = "⚑";
      "diagnostic.errorSign" = "✘";
      "diagnostic.infoSign" = "ℹ";
      "diagnostic.hintSign" = "ℹ";
      "coc.preferences.formatOnSaveFiletypes" = ["rust"];
    };
  };

  plugins = with pkgs.vimPlugins; [
    NeoSolarized # Solarized theme
    sensible # Simple options
    ctrlp-vim
    sleuth # Buffer options based on related files
    gitgutter # Git utils
    tmux-navigator
    vim-airline vim-airline-themes # Better status bar
    #supertab # Tab completion
    

    # Language Client
    coc-rust-analyzer

    # Org Mode
    SyntaxRange
    vim-orgmode

    # Language Plugins
    elm-vim
    vim-nix
    vim-javascript
    typescript-vim
    vim-go
    #vim-polyglot # Package of 100+ language plugins
  ];
  extraPackages = with pkgs; [
    unstable.rust-analyzer
  ];

  extraConfig = ''
" General
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set updatetime=250
set fillchars+=vert:\
nnoremap <Space> <Nop>
let mapleader=" "
set number
set spell
set ignorecase
set noswapfile
set nocompatible
set completeopt=longest,menuone
set signcolumn=yes

set notermguicolors
set background=dark
colorscheme NeoSolarized

set cursorline
set clipboard+=unnamedplus
set showmatch
set wildmode=list:full
set nowrap

set cmdheight=1
set smartcase
set hlsearch
set encoding=utf8
set expandtab
set shiftwidth=4
set tabstop=4

set undolevels=1000
set undofile
set undodir=~/.neovim/undodir

" Folds
set foldmethod=indent
set nofoldenable
set ai
set si

" Clear highlights
nnoremap <Backspace>c :noh<cr>

" Allow ommiting C-W for moving between buffers
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Q q
cnoreabbrev WQ wq

set splitbelow
set splitright

imap jj <Esc>

" ctrlp
let g:ctrlp_map = '<C-Space>'
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 0


" Ale
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚑'

hi link ALEWarningSign  Warning
hi ALEWarningSign ctermfg=3 guifg=Black guibg=Yellow

" Linters for languages
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'haskell': ['hlint'],
      \   'go': ['gofmt', 'go build', 'golint'],
      \   'rust': []
      \}
let g:ale_fixers = {
      \   'javascript': ['prettier'],
      \   'haskell': ['hfmt'],
      \   'cpp': ['clang-format'],
      \   'rust': [],
      \   'typescript': ['prettier']
      \}

"
" coc.nvim
"
nmap <leader>a <Plug>(coc-codeaction-cursor)
nmap <leader>f <Plug>(coc-fix-current)
nmap <Leader>rn <Plug>(coc-rename)
vmap <leader>a <Plug>(coc-codeaction-selected)

nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gD :call CocAction('jumpDefinition', 'vsplit')<cr>
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> <Leader>e  :<C-u>CocList extensions<cr>
nnoremap <silent> <Leader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Leader>c :<C-u>CocList commands<cr>

nnoremap <silent> <Leader>em :<C-u>CocCommand rust-analyzer.expandMacro<cr>
nnoremap <silent> <Leader>p :<C-u>CocCommand rust-analyzer.parentModule<cr>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" https://github.com/neoclide/coc.nvim/issues/511
hi link CocFloating markdown
autocmd BufReadPre,FileReadPre * hi link CocFloating markdown


" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" GitGutter
let g:gitgutter_override_sign_column_highlight = 0

" Polyglot
let g:polyglot_disabled = ['elm']

" Elm
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
  '';
}

