call plug#begin()

Plug 'compactcode/alternate.vim'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-fugitive'
Plug 'ervandew/supertab'
Plug 'jumski/vim-colors-solarized'
Plug 'tpope/vim-sleuth'
Plug 'mhinz/vim-startify'
Plug 'vim-syntastic/syntastic'
Plug 'bitc/vim-hdevtools'
Plug 'ElmCast/elm-vim'

call plug#end()

syntax enable
set background=dark
colorscheme solarized

hi! link Search ColorColumn
hi! link QuickFixLine ColorColumn

" Synastic syntax checking
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

let g:elm_syntastic_show_warnings = 1
let g:syntastic_elm_checkers = ['elm_make']

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

set history=500

set showmatch

set number
set ruler
set nowrap

set autoread
set cmdheight=1

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

set backspace=indent,eol,start

set ai
set si

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

cnoreabbrev W w

set splitbelow
set splitright

set noswapfile

"au BufWritePost *.elm ElmMake

set notermguicolors
