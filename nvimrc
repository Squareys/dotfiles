"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My vimrc
"
" Primarily used on windows with gvim 8.0, but should work on unix systems aswell.
" Mostly C++11, glsl, javascript, python.
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

" remember the chan id (buffer id) of the last terminal buffer
augroup Terminal
  au!
  " Save last terminal when opened and when entered
  au TermOpen,BufEnter,BufWinEnter,WinEnter term://* let g:last_terminal_chan_id = b:terminal_job_id
  " Enter insert mode immediately, like in vim
  au TermOpen,BufEnter,BufWinEnter,WinEnter term://* startinsert!
augroup END

let $VCVARSALL = $VS160COMCOMNTOOLS . '..\..\VC\Auxiliary\Build\vcvarsall.bat'
if trim(system('hostname')) == 'DESKTOP-G51IO25'
  command! Emsdk call chansend(g:last_terminal_chan_id, "D:\\GitHub\\emsdk\\emsdk_env.bat<CR>")
else
  command! Emsdk call chansend(g:last_terminal_chan_id, "C:\\Repos\\emsdk\\emsdk_env.bat<CR>")
endif

command! Vcvarsall call chansend(g:last_terminal_chan_id, "\"%VCVARSALL%\" x64<CR>")
command! YcmSymlink call chansend(g:last_terminal_chan_id, "mklink ../compile_commands.json ./compile_commands.json<CR>")
command! RerunLastTerminalCommand call chansend(g:last_terminal_chan_id, "!!<CR>")

" ---------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------
if has("win32")
else
    let $USERPROFILE = '~'
end

let $PATH=$PATH.";".$LOCALAPPDATA."/coc/extensions/coc-clangd-data/install/10.0.0/clangd_10.0.0/bin"

if empty(glob($LOCALAPPDATA.'/nvim-data/site/autoload/plug.vim'))
  silent !curl -fLo "C:/Users/Squareys/AppData/Local/nvim-data/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
if empty(glob($USERPROFILE.'/vimfiles/autoload/plug.vim'))
  !powershell -command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"C:/Users/Squareys/vimfiles/autoload/plug.vim\" -Force"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($USERPROFILE.'/vimfiles/plugged')
" Whitespace errors
Plug 'ntpeters/vim-better-whitespace'

" Git integration
Plug 'tpope/vim-fugitive'

" Toggles between relative and absolute line numbers depending on active
" buffer
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language pack
Plug 'sheerun/vim-polyglot'

" File Browser
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'

" Efficiency
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'zef/vim-cycle'
" TODO: Needs operator
"Plug 'kana/vim-operator-replace'
" Collides with autocomplete Plug 'jiangmiao/auto-pairs'
Plug 'unblevable/quick-scope'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Movement
Plug 'bkad/CamelCaseMotion'

" File browsing
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'

" Themes
Plug 'tomasr/molokai'

" C++
Plug 'vim-scripts/a.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'Squareys/vim-cmake'
" Plug 'rhysd/vim-clang-format'

" Snippets
Plug 'neoclide/coc-snippets'
Plug 'honza/vim-snippets'
Plug 'rbonvall/snipmate-snippets-bib'

" Python
Plug 'vim-scripts/indentpython.vim'

call plug#end()

" All of your Plugins must be added before the following line
filetype plugin indent on    " required

" ---------------------------------------------------------------------------
" Tabs (spaces only, tabs expanded to 4 spaces)
" ---------------------------------------------------------------------------
set expandtab           " use spaces, not tabs
set shiftwidth=4        " indents of 4, e.g. < commands use this
set softtabstop=4
set tabstop=4
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
if has("win32")
    set guifont=Consolas\ for\ Powerline\ FixedD:h11
else
    set guifont=Consolas\ 11
endif

if exists('g:GuiLoaded')
    silent! colorscheme molokai
    if has("gui_gtk2") || has("gui_gtk3")
        set laststatus=2
        let g:airline#extensions#tabline#enabled = 1
    elseif has("win32")
        set guifont=Consolas\ for\ Powerline\ FixedD:h11
        set lines=40 columns=120
        set diffexpr=MyDiff()
        " Set to fullscreen
        if !exists("s:vimrc_loaded")
            au GUIEnter * simalt ~x
            let s:vimrc_loaded=1
        endif
    endif
    set guioptions-=m   " remove menubar
    set guioptions-=T	" remove icons
    set guioptions-=r   " remove right scrollbar
    set guioptions-=L   " remove left scrollbar

elseif &t_Co == 256
    " If we have 256 colors in the current terminal, set some nice theme
    silent! colorscheme molokai
end
"
" Startup
augroup Startup
  autocmd VimEnter * GuiPopupmenu 0
  "autocmd VimEnter * NERDTree
  "autocmd VimEnter * vert terminal
  "autocmd VimEnter * wincmd L | startinsert | let g:last_terminal_chan_id=b:terminal_job_id | Vcvarsall
augroup END

" ---------------------------------------------------------------------------
" Folding
" ---------------------------------------------------------------------------

set foldlevelstart=99

" ---------------------------------------------------------------------------
" Plugin settings
" ---------------------------------------------------------------------------
" clang-format
let g:clang_format#detect_style_file=1

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

" YouCompleteMe

let g:ycm_confirm_extra_conf = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion=1
map <F3> :YcmCompleter GoTo<CR>
map <S-F1> :YcmCompleter FixIt<CR>
map <F2> :YcmCompleter RefactorRename ""<Left>

map <C-?> <C-\>
map <C-W> <C-W>

" coc completion
let g:coc_global_extensions = [ 'coc-clangd', 'coc-css', 'coc-tsserver', 'coc-json', 'coc-eslint']
set updatetime=300

set hidden

set nobackup
set nowritebackup

set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

nmap <silent><nowait> <C-,> :CocList -I symbols<cr>

" Use <S-space> for trigger snippet expand.
imap <S-space> <Plug>(coc-snippets-expand)

" Use <up> for select text for visual placeholder of snippet.
vmap <S-Backspace> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<S-Enter>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<S-Backspace>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <Right> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x <Plug>(coc-convert-snippet)
"
" Ctrl+P
"

set wildignore+=*/output/*
set wildignore+=*/build*/*
set wildignore+=*.obj
set wildignore+=*.lib
set wildignore+=*.pdb
set wildignore+=*.vcxproj
set wildignore+=*/node_modules/*
set wildignore+=*/bower_components/*
set wildignore+=*/deploy/*
set wildignore+=*/m.css/*
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
au FileType cpp.ue4 set noexpandtab

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

" Web
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
" GLSL
au BufNewFile,BufRead *.frag, *.geom, *.vert, *.tess, *.glsl
    \ set filetype=glsl

au BufWrite *.md
    \ %s/lastmod:.*$/\='lastmod: ' . strftime("%Y-%m-%dT%T+02:00")/g

" ---------------------------------------------------------------------------
" Commands and Mappings
" ---------------------------------------------------------------------------

" Commands
command! Vimrc tabnew $USERPROFILE/dotfiles/nvimrc
command! Refrc so $MYVIMRC

command! Build RerunLastTerminalCommand

" Maps
map <C-b> :Build<CR>
map <C-S> :StripWhitespace<CR>:w<CR>
map <S-F8> :NERDTree<CR>
noremap <F5> :Build<CR>
inoremap <C-S> <ESC>:StripWhitespace<CR>:w<CR>

" In insert mode it is useful to have convenient arrow keys, e.g. selection
" of C-p results.
inoremap <C-j> <UP>
inoremap <C-k> <DOWN>
inoremap <C-l> <RIGHT>
inoremap <C-h> <LEFT>

" Window switching in the terminal like in vim
tnoremap <C-w> <C-\><C-n><C-w>

tnoremap <C-w> <C-\><C-n><C-w>

map <leader>gc :Git commit<CR>
map <leader>ga :Git add %<CR>
map <leader>gpo :Git push origin<CR>
map <leader>gp :Git pull origin<CR>
map <leader>gpr :Git pull --rebase origin<CR>
map <leader>gb :Git checkout -b b
map <leader>gm :Git mergetool<CR>
map <leader>grh :Git reset --hard<CR>
map <leader>gg :Git gui<CR>

funct! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunct!

function OpenProject(...)
    let origins = split(Exec('Git remote -v'), '\n')[0]
    let uri = matchlist(origins, '\(https://.*\)\(\.git\) ')[1]
    execute system("explorer " . uri . join(a:000))
endfunction
map <leader>gl :call OpenProject()<CR>
map <leader>glp :call OpenProject("/-/pipelines")<CR>
map <leader>glci :call OpenProject("/-/issues/new")<CR>
map <leader>gli :call OpenProject("/-/issues")<CR>
map <leader>glm :call OpenProject("/-/merge_requests")<CR>

" ---------------------------------------------------------------------------
" Show invisible characters
" ---------------------------------------------------------------------------
set list
set listchars=tab:→\ ,eol:¬,space:·

" Abbreviations
iabbrev @@ squareys@googlemail.com
iabbrev copyr Copyright © 2020 Jonathan Hale <squareys@googlemail.com>
