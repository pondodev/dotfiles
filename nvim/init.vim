runtime plugins.vim
runtime helpers.vim

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
set splitbelow
set splitright
set nowrap

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline_powerline_fonts = 1

" these just ensure that :make and :Make (+ other :Dispatch related commands)
" don't have any ansi colour codes in their output
let g:dispatch_pipe = "2>&1 | sed -e $'s/\x1b\[[0-9;]*m//g'"
let &shellpipe = g:dispatch_pipe . " | tee %s"

call VimPlugInit()

" init lsp and autocomplete stuff
luafile /Users/daniel/.config/nvim/lsp.lua

" open a terminal without line numbers
autocmd TermOpen * setlocal nonumber norelativenumber

" scons related files should be read as python files (because, you know, they
" are)
autocmd BufNewFile,BufRead SConstruct set syntax=python
autocmd BufNewFile,BufRead SConscript set syntax=python

