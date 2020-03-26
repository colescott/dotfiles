let g:deoplete#enable_at_startup = 1

let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie', '--lsp'],
    \ 'rust': ['rls']
    \ }

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
      \   'rust': ['rls']
      \}
let g:ale_fixers = {
      \   'javascript': ['prettier'],
      \   'haskell': ['hfmt'],
      \   'cpp': ['clang-format'],
      \   'rust': ['rustfmt'],
      \   'typescript': ['prettier']
      \}

" CoC

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

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

" Polyglot
let g:polyglot_disabled = ['elm']

" Elm
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1

" General
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set updatetime=250
set fillchars+=vert:\
let mapleader=" "
set number
set spell
set ignorecase
set noswapfile
set nocompatible
set completeopt=longest,menuone

set notermguicolors
set background=dark
colorscheme NeoSolarized

set cursorline
set clipboard+=unnamedplus
set showmatch
set wildmode=list:full
set nowrap

set cmdheight=1
set mouse=
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
