set nocompatible " be iMproved
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'elzr/vim-json'
Bundle 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
Plugin 'nrocco/vim-phpunit'
Plugin 'evidens/vim-twig'
" for GO
Plugin 'fatih/vim-go'

" for python
Plugin 'davidhalter/jedi-vim'

" for git
Plugin 'tpope/vim-fugitive'

syntax enable                                   " Enable syntaxt highlighting/coloring
set t_Co=16                                     " Use 16 ansi color terminal by default
colorscheme Tomorrow-Night
set number                                      " Show line numbers
set showmode                                    " Show in what mode we are in (paste/nopaste)
set nopaste
set numberwidth=6                               " Make space to show line numbers up to 99999
set backspace=indent,eol,start                  " Make backspace works like any other application


" ------------------------------------------------------------------------------------------------------------------------------
"set nowrap                                      " Disable wrapping of lines
set linebreak                                   " If we enable wrapping. Make it at least sensible
set nolist                                      " List disables linebreak
set textwidth=0                                 " Prevent Vim from automatically inserting line breaks
set wrapmargin=0                                " Prevent Vim from automatically inserting line breaks

" ------------------------------------------------------------------------------------------------------------------------------
set scrolloff=4                                 " Always have at least 3 lines before the window's bottom
set lazyredraw                                  " Don't update while in macro
set ttyfast                                     " Improves redrawing
set ttyscroll=3
set nofoldenable                                " Disable Folding
" ------------------------------------------------------------------------------------------------------------------------------

set incsearch                                   " Searching starts after you enter the string
set ignorecase                                  " Searching is not case sensitive
set smartcase                                   " If a pattern contains an uppercase letter, it is case sensitive, otherwise not
set hlsearch                                    " Highlight searches
set gdefault                                    " Assume the /g flag on :s substitutions to replace all matches in a line:
set wrapscan                                    " Set the search scan to wrap around the file
set enc=utf-8                                   " UTF-8 Default encoding
" ------------------------------------------------------------------------------------------------------------------------------

set noerrorbells                                " No audio bell
set novisualbell                                " No visual bell
" ------------------------------------------------------------------------------------------------------------------------------

set autoread                                    " Set to auto read when a file is changed from the outside
set wildmenu                                    " Enables a menu at the bottom of the vim/gvim window.
set wildmode=list:longest,full                  " Completion on the command line
set completeopt=longest,menuone                 " Completion popup doesn’t select first item and typing new letters updates the completion list
set showmatch                                   " Show/highlight matching braches
set nosmartindent                               " Automatically indent braces (overrides autoindent)
set report=0                                    " Tell us when anything is changed via :...
" ------------------------------------------------------------------------------------------------------------------------------

set directory=/var/tmp                          " directory to place swap files in


set expandtab                                   " Tab will be translated to spaces
set softtabstop=4                               " Use these amount of spaces when inserting a tab
set tabstop=4                                   " Use these amount of spaces when inserting a tab
set shiftwidth=4                                " Control how many columns text is indented with the reindent operations


set ruler                                       " Show line number and cursor position
if has('statusline')
    set laststatus=2                              " Always show the status line
endif


let mapleader = ","                             " Set mapleader key to ,

set wildignore+=*.pyc,*/cache/*,*/log/*,*/logs/*,*.so,*.swp
let g:netrw_list_hide = '.*\.pyc'

" ---------------------------------------------------------------
" PLUGIN: vim-go
" ---------------------------------------------------------------
let g:go_fmt_command = "goimports"

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

au FileType go nmap <Leader>s <Plug>(go-implements)

" ---------------------------------------------------------------
" PLUGIN: Clean Trailing Whitespaces from file
" ---------------------------------------------------------------
nnoremap        <leader>c              :call <SID>CleanTrailingWhiteSpaces()<CR>
function! <SID>CleanTrailingWhiteSpaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" PLUGIN: ctrlp.vim
" ---------------------------------------------------------------
let g:ctrlp_map = '<leader>a'
let g:ctrlp_lazy_update = 50
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_open_new_file = 't'
let g:ctrlp_extensions = ['tag']
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-t>'],
            \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
            \ }
let g:ctrlp_buftag_types = {
            \ 'yaml': '--languages=ansible --ansible-types=k',
            \ }
" ---------------------------------------------------------------


" ---------------------------------------------------------------
" PLUGIN: vim-airline
" ---------------------------------------------------------------
let g:airline_theme = 'bubblegum'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
" ---------------------------------------------------------------

" Fix indentiation in whole file
nnoremap      <leader>i       mzgg=G`z<CR>

" phplint
noremap <C-l> :Phplint<CR>

" do spell check
nmap <Leader>s :setlocal spell! spelllang=en_us<CR>

" vim-json: disable concealing of double quotes
let g:vim_json_syntax_conceal = 0

" " Remove the current buffer file from disk
command Rm call delete(expand('%')) | bdelete!

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
