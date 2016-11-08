"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My vimrc
"
" OS:
"   Primarily Windows
"
" Languages:
"   Primarily C++11
"   Java
"
" Author:
"   Jonathan Hale
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required


let mapleader = ","

set relativenumber

" ---------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------
set rtp+=$USERPROFILE/dotfiles/bundle/Vundle.vim/
call vundle#begin('$USERPROFILE/vimfiles/bundle/')

Plugin 'VundleVim/Vundle.vim'

" General
Plugin 'Valloric/YouCompleteMe'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'
Plugin 'scrooloose/nerdtree'

" Efficiency
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-surround'
Plugin 'zef/vim-cycle'

" Movement
Plugin 'bkad/CamelCaseMotion'

" File browsing
Plugin 'ctrlpvim/ctrlp.vim'

" Themes
Plugin 'tomasr/molokai'

" C++
Plugin 'vim-scripts/a.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-jp/vim-cpp'
Plugin 'T4ng10r/vim-cmake'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ---------------------------------------------------------------------------
" Tabs (spaces only, tabs expanded to 4 spaces)
" ---------------------------------------------------------------------------
set expandtab           " use spaces, not tabs
set shiftwidth=4        " indents of 4, e.g. < commands use this
set softtabstop=4
set shiftround          " round indent to nearest shiftwidth multiple

" ---------------------------------------------------------------------------
" Syntax highlighting
" ---------------------------------------------------------------------------
if !exists("syntax_on")
    syntax on
endif

" ---------------------------------------------------------------------------
" GUI specific settings
" ---------------------------------------------------------------------------
if has("gui_running")
    if has("gui_gtk2")
        silent! colorscheme molokai
        set guifont=Consolas\ 11
        set guioptions-=m   " remove menubar
        set laststatus=2
        let g:airline#extensions#tabline#enabled = 1
    elseif has("gui_win32")
        silent! colorscheme molokai
        set guifont=Consolas\ for\ Powerline\ FixedD:h11
        set lines=40 columns=120
        set diffexpr=MyDiff()
        " Set to fullscreen
        au GUIEnter * simalt ~x " TODO: doesn't work
    endif
    set guioptions-=T	" remove icons
    set guioptions-=r   " remove right scrollbar
    set guioptions-=L   " remove left scrollbar
elseif &t_Co == 256
    " If we have 256 colors in the current terminal, set some nice theme
    silent! colorscheme molokai
end

" ---------------------------------------------------------------------------
" Plugin settings
" ---------------------------------------------------------------------------

" vim-cmake
let g:cmake_install_prefix = 'C:/local'
let g:cmake_project_generator = 'Ninja'

" CamelCaseMotion
call camelcasemotion#CreateMotionMappings('<Leader>')

" numbertoggle
let g:NumberToggleTrigger="<F2>"

" vim-airline

set encoding=utf-8
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

let g:airline_theme='molokai'
set laststatus=2

" ---------------------------------------------------------------------------
" Commands and Mappings
" ---------------------------------------------------------------------------

" Commands
command! Vimrc tabnew $USERPROFILE/dotfiles/vimrc
command! Refrc so $MYVIMRC

command! I make install | vert copen
command! Build make all | vert copen
command! B Build

" Maps
map <C-B> :Build<CR>
map <C-S-B> :I<CR>
map <C-S> :w<CR>
imap <C-S> <ESC>:w<CR>

" ---------------------------------------------------------------------------
" Show invisible characters
" ---------------------------------------------------------------------------
set list
set listchars=tab:→\ ,eol:¬,space:·

