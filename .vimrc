"
" vim config file
" this is just the example from the vim wiki, works fine enough for
" me so i dont mind it
"
" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.
 
set nocompatible
filetype indent plugin on
syntax on

set hidden
set wildmenu
set showcmd
set hlsearch
 
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
 
set shiftwidth=4
set softtabstop=4
set expandtab
 
map Y y$
nnoremap <C-L> :nohl<CR><C-L>
