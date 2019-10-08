"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My vimrc
"
" Primarily used on windows with gvim 8.0, but should work on unix systems aswell.
" Mostly C++11, glsl, python, ruby on rails.
"
" Author:
"   Jonathan Hale
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible " be iMproved
filetype off

let mapleader = ","

set relativenumber

" Machine dependent env:

if trim(system('hostname')) == 'DESKTOP-G51IO25'
    echo "Detected DESKTOP-G51IO25"
    let $VCVARSALL = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
else
    let $VCVARSALL = 'C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/vcvarsall.bat'
end

command! Vcvarsall call term_sendkeys(bufnr("%"), "\"%VCVARSALL%\" x64\<CR>")
command! YcmSymlink call term_sendkeys(bufnr("%"), "mklink ../compile_commands.json ./compile_commands.json<CR>")
command! RerunLastTerminalCommand call term_sendkeys(bufnr("!C:\\WINDOWS\\system32\\cmd.exe"), "\<Up>\<CR>")

" ---------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------
if has("win32")
    set rtp+=$USERPROFILE/dotfiles/bundle/Vundle.vim/
    call vundle#begin('$USERPROFILE/vimfiles/bundle/')
    command! YcmCompile !python '$USERPROFILE/vimfiles/bundle/' --clang-completer
else
    set rtp+=~/dotfiles/bundle/Vundle.vim/
    call vundle#begin('~/vimfiles/bundle/')
    let $USERPROFILE = '~'
    command! YcmCompile !python '~/vimfiles/bundle/' --clang-completer
end

Plugin 'VundleVim/Vundle.vim'

" General
Plugin 'Valloric/YouCompleteMe'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'
Plugin 'vim-scripts/operator-user'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-syntastic/syntastic'

" Efficiency
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'zef/vim-cycle'
Plugin 'kana/vim-operator-replace'

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
" Plugin 'Squareys/vim-cmake'

Plugin 'idbrii/vim-unreal'

" Snippets
Plugin 'SirVer/UltiSnips'
Plugin 'honza/vim-snippets'
Plugin 'rbonvall/snipmate-snippets-bib'

" Python
Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'

" Vimscript testing and development
Plugin 'junegunn/vader.vim'
Plugin 'vim-scripts/ReloadScript'

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
    if has("gui_gtk2") || has("gui_gtk3")
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
        if !exists("s:vimrc_loaded")
            au GUIEnter * simalt ~x
            let s:vimrc_loaded=1
        endif
    endif
    set guioptions-=T	" remove icons
    set guioptions-=r   " remove right scrollbar
    set guioptions-=L   " remove left scrollbar

    " Startup
    autocmd VimEnter * NERDTree
elseif &t_Co == 256
    " If we have 256 colors in the current terminal, set some nice theme
    silent! colorscheme molokai
end

" ---------------------------------------------------------------------------
" Folding
" ---------------------------------------------------------------------------

set foldlevelstart=99

" ---------------------------------------------------------------------------
" Plugin settings
" ---------------------------------------------------------------------------

" vim-cmake
if has("win32")
    let g:cmake_install_prefix = 'C:/local'
else
    let g:cmake_install_prefix = '/usr'
end
let g:cmake_project_generator = 'Ninja'
let g:cmake_export_compile_commands = 1
let g:cmake_ycm_symlinks = 1

"augroup filetype_cpp
"    autocmd!
"    autocmd FileType cpp,cmake :CMakeFindBuildDir
"augroup END
 "autocmd BufEnter *.cpp,CMakeLists.txt :CMakeFindBuildDir

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

" Latex-box
let g:LatexBox_latexmk_async=1

" UltiSnips
let g:UltiSnipsSnippetsDir=$USERPROFILE.'/dotfiles/UltiSnips'
let g:UltiSnipsSnippetDirectories=["UltiSnips", $USERPROFILE.'/dotfiles/UltiSnips']

let g:UltiSnipsExpandTrigger="<S-SPACE>"
let g:UltiSnipsJumpForwardTrigger="<TAB>"
let g:UltiSnipsJumpBackwardTrigger="<S-TAB>"

" YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
map <F3> :YcmCompleter GoTo<CR>

" Ctrl+P

set wildignore+=*/output/*
set wildignore+=*/build*/*
set wildignore+=*.obj
set wildignore+=*.lib
set wildignore+=*.pdb
set wildignore+=*.vcxproj
set wildignore+=*/node_modules/*
set wildignore+=*/bower_components/*
set wildignore+=*/doc/*
set wildignore+=*/dist/*

" ---------------------------------------------------------------------------
" Filetype specific settings
" ---------------------------------------------------------------------------
"
" Search superdirectories for files with given extension
" Returns true if such a file exists, false otherwise
"
" Example:
" call s:file_with_ext_in_superdir('md')
function s:file_with_ext_in_superdir(ext)
    " Split path into components
    let components = split(expand('%:p:h'), '[\\/]')
    let path = ''
    for component in components
        let path = path.component.'/'
        let file_found = globpath(path, '*.'.a:ext)
        if file_found != ""
            echom "Found file with extension '".a:ext."': ".file_found
            return 1
        end
    endfor

    return 0
endfunction

function s:conditional_filetype(ext, type)
    if s:file_with_ext_in_superdir(a:ext)
        execute 'set filetype='.a:type
    end
endfunction

au FileType cpp call s:conditional_filetype('uproject', 'cpp.ue4')

" Python
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

let python_highlight_all=1

" Web (yes, I use js only for web stuff)
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" ---------------------------------------------------------------------------
" Commands and Mappings
" ---------------------------------------------------------------------------

" Commands
command! Vimrc tabnew $USERPROFILE/dotfiles/vimrc
command! Refrc so $MYVIMRC

command! Build RerunLastTerminalCommand

" Maps
map <C-b> :Build<CR>
map <C-S> :StripWhitespace<CR>:w<CR>
map <S-F8> :NERDTree<CR>
noremap <F5> :Build<CR>
inoremap <C-S> <ESC>:StripWhitespace<CR>:w<CR>
inoremap jf <ESC>
inoremap fj <ESC>
inoremap jkl <ESC>
inoremap lkj <ESC>

" ---------------------------------------------------------------------------
" Show invisible characters
" ---------------------------------------------------------------------------
set list
set listchars=tab:→\ ,eol:¬,space:·

" Abbreviations
iabbrev @@ squareys@googlemail.com
iabbrev copyr Copyright © 2018 Jonathan Hale <squareys@googlemail.com>

