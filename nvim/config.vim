"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options, keymaps, autocmds — ported verbatim from the old nvimrc so muscle
" memory is unchanged. Plugin management + LSP/completion are done in init.lua
" (lazy.nvim + native vim.lsp), which sources this file. Windows-only bits and
" coc/ctrlp bits were dropped (replaced by native LSP + Telescope in init.lua).
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

let mapleader = ","

set relativenumber

" Remember the chan id of the last terminal buffer, enter insert immediately.
augroup Terminal
  au!
  au TermOpen,BufEnter,BufWinEnter,WinEnter term://* let g:last_terminal_chan_id = b:terminal_job_id
  au TermOpen,BufEnter,BufWinEnter,WinEnter term://* startinsert!
augroup END

let $USERPROFILE = $HOME
command! SymlinkCompileCommands call chansend(g:last_terminal_chan_id, "ln -s ../compile_commands.json ./compile_commands.json<CR>")
command! RerunLastTerminalCommand call chansend(g:last_terminal_chan_id, "!!<CR>")

filetype plugin indent on

" Tabs: spaces only, 4-wide
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround

if !exists("syntax_on")
    syntax on
endif

" Vimspector (Visual Studio style F5/F9/... mappings)
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" Folding
set foldlevelstart=99

" clang-format: honour a project .clang-format
let g:clang_format#detect_style_file=1

" CamelCaseMotion: <leader>w / <leader>b / <leader>e move by camelCase parts
call camelcasemotion#CreateMotionMappings('<Leader>')

set encoding=utf-8
set laststatus=2

" quickscope highlight delay
let g:qs_delay = 200

set hidden
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

" Ctrl+P ignore list (used by Telescope find_files too)
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

" Python
au BufNewFile,BufRead *.py
    \ set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
let python_highlight_all=1

" Web
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 softtabstop=2 shiftwidth=2

" GLSL
au BufNewFile,BufRead *.frag,*.geom,*.vert,*.tess,*.glsl set ft=glsl

" doxygen
au BufNewFile,BufRead *.dox set ft=doxygen

" Update lastmod: in markdown front matter on save
au BufWrite *.md
    \ %s/lastmod:.*$/\='lastmod: ' . strftime("%Y-%m-%dT%T+02:00")/g

" ---------------------------------------------------------------------------
" Commands and Mappings
" ---------------------------------------------------------------------------
command! Vimrc tabnew $HOME/dotfiles/nvim/config.vim
command! Refrc so $MYVIMRC
command! Build RerunLastTerminalCommand

map <C-b> :Build<CR>
map <C-S> :StripWhitespace<CR>:w<CR>
map <S-F8> :NERDTree<CR>
inoremap <C-S> <ESC>:StripWhitespace<CR>:w<CR>

" Terminal window switching like in vim
tnoremap <C-w> <C-\><C-n><C-w>

" Git (fugitive)
map <leader>gc :Git commit<CR>
map <leader>gca :Git commit --amend<CR>
map <leader>ga :Git add %<CR>
map <leader>gpo :Git push origin<CR>
map <leader>gpt :Git push --tags<CR>
map <leader>gp :Git pull origin<CR>
map <leader>gpr :Git pull --rebase origin<CR>
map <leader>gb :Git checkout -b b
map <leader>gm :Git mergetool<CR>
map <leader>grh :Git reset --hard<CR>
map <leader>gg :call jobstart('git gui', {'detach': v:true})<CR>

map <leader>dc :call OpenURI('https://doc.magnum.graphics/corrade/#search')<CR>
map <leader>dm :call OpenURI('https://doc.magnum.graphics/magnum/#search')<CR>

funct! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunct!

" Linux: open a URI in the default browser (was 'explorer' on Windows)
function OpenURI(uri)
    silent call system('xdg-open ' . shellescape(a:uri))
endfunction

function OpenProject(...)
    let origins = split(Exec('Git remote -v'), '\n')[0]
    let uri = matchlist(origins, '\(https://.*\)\(\.git\) ')[1]
    execute OpenURI(uri . join(a:000))
endfunction

map <leader>gl :call OpenProject()<CR>
map <leader>glp :call OpenProject("/-/pipelines")<CR>
map <leader>glci :call OpenProject("/-/issues/new")<CR>
map <leader>gli :call OpenProject("/-/issues")<CR>
map <leader>glm :call OpenProject("/-/merge_requests")<CR>

function GitTag(...)
    let lastTag = Exec('Git describe --abbrev=0 --tags')
    let tagname = input('Tag name (last tag was "' . lastTag . '"): ')
    if tagname == ''
        echom 'input nothing'
        return
    endif
    exec 'Git tag -a ' . tagname .' -m ' . tagname
endfunction
map <leader>gt :call GitTag()<CR>

" Show invisible characters
set list
set listchars=tab:→\ ,eol:¬,space:·

" Abbreviations
iabbrev @@ squareys@googlemail.com
iabbrev <expr> copyr 'Copyright © ' . strftime('%Y') . ' Jonathan Hale <squareys@googlemail.com>'
