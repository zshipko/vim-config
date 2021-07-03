" Download Plug if needed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Begin Plug block
call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/edge'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'let-def/vimbufsync'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/a.vim'
Plug 'bohlender/vim-z3-smt2'
Plug 'ARM9/arm-syntax-vim'
Plug 'jparise/vim-graphql'
Plug 'rhysd/rust-doc.vim'
Plug 'CraneStation/cranelift.vim'
Plug 'neomake/neomake'
Plug 'whonore/Coqtail'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'rhysd/vim-llvm'
" dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" telescope
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

filetype plugin on
filetype indent on
syntax enable

set noerrorbells visualbell t_vb= "dont beep

" Use F12 to toggle paste mode
set pastetoggle=<F12>

" Refresh when changed
set autoread

" Map to avoid shift
map ; :

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

function! s:edge_custom() abort
  let l:palette = edge#get_palette('default')
  highlight! link TSSymbol Blue
  highlight! link TSConstant Blue
  highlight! link TSParameter White
  highlight! link TSParameterReference White
  highlight! link TSVariable White
  highlight! link TSField White
  highlight! link TSProperty White
  highlight! link TSNamespace White
endfunction

augroup EdgeCustom
  autocmd!
  autocmd ColorScheme edge call s:edge_custom()
augroup END


let g:edge_disable_italic_comment = 1
let g:edge_diagnostic_line_highlight = 1
let g:edge_diagnostic_virtual_text = 'colored'
colorscheme edge

" Status bar
set laststatus=2


let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
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

au BufRead,BufNewFile *.fountain set filetype=fountain
autocmd BufNewFile,BufRead *.md set ft=markdown spell
autocmd BufNewFile,BufRead *.fountain set ft=fountain spell

set hidden

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
set ttimeoutlen=2

" lspconfig
lua << EOF
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.ocamllsp.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.zls.setup{}
require'lspconfig'.gopls.setup{}
EOF

" compe
lua << EOF
-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 2;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader> F    <cmd>lua vim.lsp.buf.formatting()<CR>
autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {  }, -- List of parsers to ignore installing
  highlight = {
    enable = true,  -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
}
EOF

map <Space> <Leader>
