" Set the clang path for clang_complete
if (match(system('uname -s'), 'Darwin') >= 0)
    let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
elseif !empty($CLANG_PATH)
    let g:clang_library_path=$CLANG_PATH
else
    let g:clang_library_path=system('echo -n `llvm-config --prefix`/lib')
endif

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
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ervandew/supertab'
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'let-def/vimbufsync'
Plug 'Rip-Rip/clang_complete'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/a.vim'
Plug 'davidhalter/jedi-vim'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'bohlender/vim-z3-smt2'
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go'
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
set shiftwidth=4
set tabstop=4
autocmd FileType ocaml set tabstop=2|set shiftwidth=2|set expandtab


" Use tabs in Makefiles
autocmd FileType make setlocal noexpandtab

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

map <C-m> :SyntasticToggleMode<CR>
map <C-k> :SyntasticCheck<CR>
nmap <F8> :TagbarToggle<CR>

" Merlin (OCaml)
if executable('opam')
    au BufRead,BufNewFile *.ml,*.mli compiler ocaml
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
    execute "set rtp+=" . g:opamshare . "/merlin/vim"
    let g:syntastic_ocaml_checkers = ['merlin']
    map <Leader>d :MerlinLocate<CR>
endif
set rtp^="/home/zach/.opam/4.07.0/share/ocp-indent/vim"

" Jedi (Python)
let g:jedi#popup_on_dot = 0

" Neoformat
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" ale
let g:aloe_completion_enabled = 1
let g:ale_linters = {'c': ['clang'], 'c++': ['clang'], 'ocaml': ['merlin']}
let g:ale_linters = {'c': ['clang-format'], 'ocaml': ['ocp-indent', 'ocamlformat']}
let g:ale_c_clang_options = '-std=c11 -Wall -I/usr/local/include -I~/devel/halide/include -I~/devel/halide/tools'
