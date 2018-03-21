call plug#begin('~/.local/share/nvim/plugged')
" General stuff
Plug 'tpope/vim-sensible'
Plug 'Raimondi/delimitMate'
Plug 'jumski/vim-colors-solarized'
Plug 'tpope/vim-sleuth'
Plug 'scrooloose/nerdtree'
Plug 'jszakmeister/vim-togglecursor'
Plug 'christoomey/vim-tmux-navigator'
Plug 'iamcco/markdown-preview.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'pbogut/deoplete-elm'
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'mhartington/nvim-typescript'

" Airline stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Ale linter
Plug 'w0rp/ale'

" Misc
Plug 'elmcast/elm-vim'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'

call plug#end()

" General
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Speedyboi
set updatetime=250
set fillchars+=vert:\
let mapleader=" "
set number
set spell
set ignorecase
set noswapfile
set nocompatible
set completeopt=longest,menuone
syntax enable
set background=dark
colorscheme solarized
set notermguicolors
set cursorline

" Deoplete
let g:deoplete#enable_at_startup = 1
" Deoplete tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" Deoplete go support
let g:deoplete#sources#go#gocode_binary = "/home/cole/go/bin/gocode"
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']


" Ale
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1
" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚑'
hi link ALEWarningSign  Warning
let g:ale_change_sign_column_color = 1
" Linters for languages
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'haskell': ['stack-ghc-mod', 'hlint'],
      \   'go': ['gofmt', 'go build', 'golint'],
      \   'rust': ['rls']
      \}
let g:ale_fixers = {
      \   'javascript': ['prettier'],
      \   'cpp': ['clang-format'],
      \   'rust': ['rustfmt'],
      \   'typescript': ['prettier']
      \}
hi ALEWarningSign ctermfg=3 guifg=Black guibg=Yellow

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'

" Enable unused import detection for JS/JSX files
nnoremap <leader>ji :w<CR>:call clearmatches()<CR>:let cmd = system('unused -v true ' . expand('%'))<CR>:exec cmd<CR>

" GitGutter
let g:gitgutter_override_sign_column_highlight = 0


" NerdTree
map <LEADER>f :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 24
let g:NERDTreeMinimalUI = 1
autocmd VimEnter * if (0 == argc()) | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Elm
let g:polyglot_disabled = ['elm']
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1


" Markdown
autocmd BufNewFile,BufRead *.md set spell | set lbr | set nonu
let g:markdown_fenced_languages = ['html', 'json', 'css', 'javascript', 'elm', 'vim']

set history=500
set clipboard+=unnamedplus
set showmatch
set wildmode=list:full
set wildmenu

set number
set ruler
set nowrap

set autoread
set cmdheight=1

set mouse=

set ignorecase
set smartcase
set hlsearch
set incsearch

set encoding=utf8

set expandtab
set shiftwidth=4
set tabstop=4
set autoindent

set undolevels=1000
set undofile
set undodir=~/.neovim/undodir

" Folds
set foldmethod=indent
set nofoldenable

set backspace=indent,eol,start

set ai
set si

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
set noswapfile

imap jj <Esc>
