set nocompatible " be iMproved
filetype off

" Stuff for Vundle bundle manager
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

set runtimepath^=~/.vim/bundle/ctrlp.vim

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
execute pathogen#infect()

" Bundles to include
" CtrlP bundle to open files inside vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

filetype plugin indent on
set wildmenu

" ColorScheme
syntax on
set background=dark
set t_Co=256
colorscheme jellybeans

"set showcmd
set ruler " Show ruler

" Indenting *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent (local to buffer)
set pastetoggle=<F2>
set expandtab
set shiftwidth=4
set softtabstop=4

" Programming Stuff
set showmatch
set number
set showtabline=4

" trimming trailing whitespace in a smart way
" autocmd BufWritePre * :%s/\s\+$//e
" set wrap
" set linebreak
" note trailing space at end of next line
" set showbreak=>\ \ \

" needed for airline status bundle
set laststatus=2

" Keymapping
noremap <C-l> :Phplint<CR>
