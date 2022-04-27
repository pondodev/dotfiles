" include external scripts
runtime helpers.vim

" general config, ya know how it be
syntax on
colo gruvbox

set smartcase
set confirm
set number relativenumber
set nu rnu
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set ruler
set autoindent
set mouse=a
set laststatus=2
set visualbell
set scrolloff=6

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

" load vim-plug
call VimPlugInit()

" init lsp and autocomplete stuff
luafile /Users/daniel/.config/nvim/lsp.lua

" auto commands
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd VimEnter * call Startup()

