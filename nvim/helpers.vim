" loading vim-plug and whatever plugins we want 
function VimPlugInit()
    " check if vim-plug is installed, and install it if it isn't
    let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    if empty(glob(data_dir . '/autoload/plug.vim'))
      silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
    " -- plugins --

    " airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " autocomplete/error checking
    Plug 'dense-analysis/ale'
    Plug 'neovim/nvim-lsp'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'L3MON4D3/LuaSnip'

    " misc useful
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-commentary'

    call plug#end()
endfunction

" anything that needs to be run on startup goes here
function Startup()
    NERDTree
    wincmd l
endfunction

" :qa is awkward and i hate it
cmap qq qa

