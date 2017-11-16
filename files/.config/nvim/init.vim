call plug#begin('~/.local/share/nvim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'jumski/vim-colors-solarized'
Plug 'tpope/vim-sleuth'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'pbogut/deoplete-elm'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/syntastic'
Plug 'elmcast/elm-vim'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'jszakmeister/vim-togglecursor'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

syntax enable
set background=dark
colorscheme solarized

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

" General
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set fillchars+=vert:\ 
let mapleader=" "
set number
set ignorecase
set noswapfile
set completeopt=longest,menuone

" Airline
let g:airline_left_sep= '░'
let g:airline_right_sep= '░'

" NerdTree
map <LEADER>f :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 24
let g:NERDTreeMinimalUI = 1
autocmd VimEnter * if (0 == argc()) | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 1
let g:airline#extensions#syntastic#enabled = 0

" Elm
let g:polyglot_disabled = ['elm']
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_syntastic_show_warnings = 1
let g:syntastic_elm_checkers = ['elm_make']

" Markdown
autocmd BufNewFile,BufRead *.md set spell | set lbr | set nonu
let g:markdown_fenced_languages = ['html', 'json', 'css', 'javascript', 'elm', 'vim']

hi! link Search ColorColumn
hi! link QuickFixLine ColorColumn

set history=500

set showmatch

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
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent

set undolevels=1000

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

set notermguicolors

imap jj <Esc>
