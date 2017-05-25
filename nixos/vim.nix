with import <nixpkgs> {};

vim_configurable.customize {
    name = "vim";
    
    vimrcConfig.customRC = ''
        execute pathogen#infect()

        set history=500

        set mouse=a

        set showmatch

        set number
        set ruler
        set nowrap

        set autoread
        set cmdheight=2

        set ignorecase
        set smartcase
        set hlsearch
        set incsearch

        syntax enable

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

        set splitbelow
        set splitright

        set noswapfile
    '';
}