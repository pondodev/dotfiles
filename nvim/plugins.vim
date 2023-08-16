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

    " TODO: reorganise my plugins my god

    " airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " autocomplete/error checking
    Plug 'neovim/nvim-lsp'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'folke/trouble.nvim'

    " misc useful
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'pondodev/vim-dispatch'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'BurntSushi/ripgrep'
    Plug 'nvim-telescope/telescope.nvim'

    " language support
    Plug 'ziglang/zig.vim'
    Plug 'Tetralux/odin.vim'

    call plug#end()
endfunction

