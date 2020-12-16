if has('nvim')
    " Download Plug if needed
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
    endif

    " Begin Plug block
    call plug#begin('~/.config/nvim/plugged')
else
    " Download Plug if needed
    if empty(glob('~/.vim/plugged'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
    endif

    " Begin Plug block
    call plug#begin('~/.vim/plugged')
endif
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ervandew/supertab'
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'let-def/vimbufsync'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/a.vim'
Plug 'bohlender/vim-z3-smt2'
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go'
Plug 'ARM9/arm-syntax-vim'
Plug 'jparise/vim-graphql'
Plug 'rhysd/rust-doc.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'CraneStation/cranelift.vim'
Plug 'neomake/neomake'
Plug 'whonore/Coqtail'
call plug#end()

filetype plugin on
filetype indent on
syntax enable

set noerrorbells visualbell t_vb= "dont beep

" Use F12 to toggle paste mode
set pastetoggle=<F12>

" Refresh when changed
set autoread

" Map single-quote to color to avoid shift
map ' :

" Completion settings
set omnifunc=syntaxcomplete#Complete
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"

" Strip trailing whitespace on write
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Command bar height
set cmdheight=2

" Remove complete buffers automatically
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Show position in status line
set ruler

" Fix backspace
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Searching files
set hlsearch
set incsearch

" Expand tabs
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
autocmd FileType ocaml set tabstop=2|set shiftwidth=2|set expandtab


" Use tabs in Makefiles
autocmd FileType make setlocal tabstop=4|set shiftwidth=4|set noexpandtab

" Use 4 spaces in some languages
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType rust set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType javascript set tabstop=4|set shiftwidth=4|set expandtab

" Auto indent and smart indent
set ai
set si

" Fix line wrapping
set wrap

" Line numbers
set number

" Save backup files to /tmp
set backupdir=/tmp

" Enable mouse
set mouse=a

" Colorscheme
colorscheme newdefault

" Status bar
set laststatus=2


let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
\ }

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" NerdTree
autocmd StdinReadPre * let s:std_in=1
if argc() == 0 && !exists("s:std_in")
    autocmd VimEnter * NERDTree
endif
map <C-f> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

au BufRead,BufNewFile *.why,*.mlw set filetype=why3

" Merlin (OCaml)
if executable('opam')
    au BufRead,BufNewFile *.ml,*.mli compiler ocaml
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
    map <Leader>d :MerlinLocate<CR>
endif

" Jedi (Python)
let g:jedi#popup_on_dot = 0

" Neoformat
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:neoformat_enabled_javascript = []

" ale
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {'c': ['clang', 'clang-tidy'], 'cpp': [ 'clang', 'clang-tidy'], 'ocaml': ['merlin']}
let g:ale_fixers = {'c': ['clang-format'], 'cpp': ['clang-format'], 'ocaml': ['ocamlformat'], 'rust': ['rustfmt']}
let g:ale_asm_gcc_executable = ""

let g:ale_c_gcc_options = '-Wall -O2 -std=c11'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++17'

let g:ale_c_clang_options = '-Wall -O2 -std=c11'
let g:ale_cpp_clang_options = '-Wall -O2 -std=c++17'

let g:ale_cpp_clangtidy_options = '-Wall -std=c++17 -x c++'
let g:ale_cpp_clangcheck_options = '-- -Wall -std=c++17 -x c++'

let g:go_version_warning = 0

au BufRead,BufNewFile *.fountain set filetype=fountain
autocmd BufNewFile,BufRead *.md set ft=markdown spell
autocmd BufNewFile,BufRead *.fountain set ft=fountain spell

set hidden

autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.local/bin/rust-analyzer'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'cpp': ['clangd', '-background-index', '--', '-std=c++17'],
    \ 'c': ['clangd', '-background-index', '--', '-std=c11'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

command -nargs=+ HalideBuild call HalideBuild(<f-args>)
function HalideBuild(...)
  execute "!halide build " . a:1 . " %:p"
endfunction

command -nargs=+ HalideBuildGen call HalideBuildGen(<f-args>)
function HalideBuildGen(...)
  execute "!halide build -g " . a:1 . " %:p " . (a:0 > 1 ? a:2 : "")
endfunction

command -nargs=+ HalideRun call HalideRun(<f-args>)
function HalideRun(...)
  execute "!halide run %:p -- " . join(a:000, ' ')
endfunction

command -nargs=+ HalideGen call HalideGen(<f-args>)
function HalideGen(...)
  execute "!halide run -g %:p -- " . join(a:000, ' ')
endfunction

command -nargs=1 Show call Show(<f-args>)
function Show(name)
  execute "!$IMAGE_EDITOR " . a:name
endfunction

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
