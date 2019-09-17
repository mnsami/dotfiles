" ------------------------------------------------------------------------------------------------------------------------------
set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'arcticicestudio/nord-vim'
    Plug 'joshdick/onedark.vim'
    Plug 'morhetz/gruvbox'

    Plug 'SirVer/ultisnips'

    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-ragtag'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'

    Plug 'janko-m/vim-test'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-sensible'
    Plug 'chrisbra/csv.vim'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Syntax bundle
    Plug 'sheerun/vim-polyglot'

    " go stuff
    Plug 'fatih/vim-go', { 'for': 'go' }

    " php stuff
    Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
    Plug 'sumpygump/php-documentor-vim', { 'for': 'php' }

    " chef stuff
    " Plug 'gregf/ultisnips-chef'
    Plug 'ngmy/vim-rubocop'
    Plug 'dougireton/vim-chef'

    " python stuff
    Plug 'vim-scripts/indentpython.vim'
    Plug 'davidhalter/jedi-vim'
call plug#end()
" ------------------------------------------------------------------------------------------------------------------------------


" ------------------------------------------------------------------------------------------------------------------------------
set hidden
set noshowmode
set nomodeline                                  " Disable modeline for security reasons (FreeBSD tip)
" ------------------------------------------------------------------------------------------------------------------------------
syntax on                                   " Enable syntaxt highlighting/coloring
set termguicolors
set number                                      " Show line numbers
set showmode                                    " Show in what mode we are in (paste/nopaste)
set nopaste
set background=dark
set numberwidth=4                               " Make space to show line numbers up to 999
colorscheme gruvbox 
" ------------------------------------------------------------------------------------------------------------------------------
set nowrap                                      " Disable wrapping of lines
set linebreak                                   " If we enable wrapping. Make it at least sensible
set nolist                                      " List disables linebreak
set textwidth=0                                 " Prevent Vim from automatically inserting line breaks
set wrapmargin=0                                " Prevent Vim from automatically inserting line breaks
" ------------------------------------------------------------------------------------------------------------------------------
set scrolloff=3                                 " Always have at least 3 lines before the window's bottom
set lazyredraw                                  " Don't update while in macro
set ttyfast                                     " Improves redrawing
set ttyscroll=3
set nofoldenable                                " Disable Folding
set foldcolumn=1                                " Add a bit extra margin to the left
" ------------------------------------------------------------------------------------------------------------------------------
set backspace=eol,start,indent                  " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l                          " Configure backspace so it acts as it should act
" ------------------------------------------------------------------------------------------------------------------------------
set incsearch                                   " Searching starts after you enter the string
set ignorecase                                  " Searching is not case sensitive
set smartcase                                   " If a pattern contains an uppercase letter, it is case sensitive, otherwise not
set hlsearch                                    " Highlight searches
set gdefault                                    " Assume the /g flag on :s substitutions to replace all matches in a line:
set wrapscan                                    " Set the search scan to wrap around the file
set encoding=utf8                               " UTF-8 Default encoding
" ------------------------------------------------------------------------------------------------------------------------------
filetype plugin indent on                       " Enable plugins on a file type basis
" ------------------------------------------------------------------------------------------------------------------------------
set noerrorbells                                " No audio bell
set novisualbell                                " No visual bell
set t_vb=
set tm=500
" ------------------------------------------------------------------------------------------------------------------------------
set autoread                                    " Set to auto read when a file is changed from the outside
set wildmenu                                    " Enables a menu at the bottom of the vim/gvim window.
set wildmode=list:longest,full                  " Completion on the command line
"  set completeopt=menuone,longest,preview         " Completion popup doesn’t select first item and typing new letters updates the completion list
set showmatch                                   " Show/highlight matching braches
set mat=2                                       " How many tenths of a second to blink when matching brackets
set nosmartindent                               " Automatically indent braces (overrides autoindent)
set report=0                                    " Tell us when anything is changed via :...
" ------------------------------------------------------------------------------------------------------------------------------
set directory=~/.cache/vim                      " Directory to place swap files in
set nobackup                                    " Turn backup off since most stuff is in git anyway
set nowb                                        " Turn backup off since most stuff is in git anyway
set noswapfile                                  " Turn backup off since most stuff is in git anyway
" ------------------------------------------------------------------------------------------------------------------------------
set expandtab                                   " Tab will be translated to spaces
set softtabstop=4                               " Use these amount of spaces when inserting a tab
set tabstop=4                                   " Use these amount of spaces when inserting a tab
set shiftwidth=4                                " Control how many columns text is indented with the reindent operations
" ------------------------------------------------------------------------------------------------------------------------------
set ruler                                       " Show line number and cursor position
set laststatus=2                                " Always show the status line
set cmdheight=1                                 " Height of the command bar
" ------------------------------------------------------------------------------------------------------------------------------
set clipboard-=autoselect                       " Disable the automatic selection and copying of text in terminal Vim
" ------------------------------------------------------------------------------------------------------------------------------
let g:elite_mode=1                              " Enable Elite mode, No ARRRROWWS
" ------------------------------------------------------------------------------------------------------------------------------

" Disable vim netrw plugin
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

let mapleader = ","                             " Set mapleader key to ,
let g:mapleader = ","

set wildignore+=*.pyc,*/cache/*,*/log/*,*/logs/*,*.so,*.swp
set wildignorecase


" ---------------------------------------------------------------
" PLUGIN: Clean Trailing Whitespaces from file
" ---------------------------------------------------------------
nnoremap <leader>c :call <SID>CleanTrailingWhiteSpaces()<CR>
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
" PLUGIN: vim-airline
" ---------------------------------------------------------------
  let g:airline_theme = 'gruvbox'
  let g:hybrid_custom_term_colors = 1
  let g:hybrid_reduced_contrast = 1
  let g:airline_powerline_fonts = 1
  " Enable the list of buffers
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_tabs = 1
  " Show just the filename
  let g:airline#extensions#tabline#fnamemod = ':t'
  " let g:onedark_termcolors=16
" ---------------------------------------------------------------


" ---------------------------------------------------------------
" PLUGIN: fzf - A command-line fuzzy finder written in Go
" ---------------------------------------------------------------
nnoremap <leader>f :call fzf#run({'source': 'fd --type f --no-ignore --follow --color never', 'sink': 'e', 'down': '40%'})<CR>
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" PLUGIN: commentary.vim
" Set default comment prefixes for different file types.
" ---------------------------------------------------------------
autocmd FileType apache   set commentstring=#\ %s
autocmd FileType nginx    set commentstring=#\ %s
autocmd FileType php      set commentstring=//\ %s
autocmd FileType markdown set commentstring=>\ %s
autocmd FileType yaml     set commentstring=#\ %s

nmap \\\ gcc
vmap \\ gc
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" PLUGIN: tagbar
" ---------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>
" ---------------------------------------------------------------


" ---------------------------------------------------------------
" Keyboard shortcuts
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell:
" ---------------------------------------------------------------

" Shortcut to start command mode with the spacebar
nmap <space> :

" Keep selection in visual mode after indenting lines
vnoremap < <gv
vnoremap > >gv

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" Fix indentiation in whole file
nnoremap <leader>i mzgg=G`z<CR>

" Keyboard shortcut for find-and-replace
nnoremap <leader>s :%s/
vmap <leader>s :s/

" ---------------------------------------------------------------
" Buffer navigation
map  <C-h>  <ESC>:bprevious<CR>
nmap <C-h>  <ESC>:bprevious<CR>
map  <C-l>  <ESC>:bnext<CR>
nmap <C-l>  <ESC>:bnext<CR>

nmap <leader>q :bprevious <BAR> bdelete #<CR>
nmap <leader>n :enew<CR>

" Remove the current buffer file from disk
command Rm call delete(expand('%')) | bdelete!
" ---------------------------------------------------------------


" ---------------------------------------------------------------
" Fix Home/End keys in vim
:map  <ESC>[H <Home>
:map  <ESC>[F <End>
:imap <ESC>[H <C-O><Home>
:imap <ESC>[F <C-O><End>
:cmap <ESC>[H <Home>
:cmap <ESC>[F <End>
" ---------------------------------------------------------------

" Automatically save non-existent directories on save
autocmd BufWritePre * :silent !mkdir -p %:p:h

" Use q to close vim help
autocmd FileType help noremap <buffer> q :helpclose<CR>

" ---------------------------------------------------------------
" Map :q to close the buffer, and if it is the last buffer, close vim
fun! s:quitiflast()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    bdelete
    if bufcnt < 2
        quit
    endif
endfun

command! Bd :call s:quitiflast()

" cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Bd' : 'q'
" ---------------------------------------------------------------


" ---------------------------------------------------------------
" Restore cursor position when switching buffers and back
" ---------------------------------------------------------------
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" Jedi-Vim for Python
" --------------------------------------------------------------
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#popup_on_dot = 0
call jedi#configure_call_signatures()
let g:jedi#show_call_signatures = 1

" ------------------------------------------------------------------------------------------------------------------------------
" PLUGIN: junegunn/fzf.vim - A command-line fuzzy finder written in Go
" ------------------------------------------------------------------------------------------------------------------------------
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_history_dir = '~/.cache/fzf-history'

nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fc :BCommits<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fT :exec "Tags ".expand("<cword>")<CR>
nnoremap <leader>fs :History/<CR>
nnoremap <leader>fa :Rg<CR>
nnoremap <leader>fA :exec "Rg ".expand("<cword>")<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

autocmd VimEnter * command! -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" ------------------------------------------------------------------------------------------------------------------------------
