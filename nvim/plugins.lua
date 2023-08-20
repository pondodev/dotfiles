-- loading vim-plug and whatever plugins we want
local Plug = vim.fn["plug#"]

local plugged_path = vim.call("stdpath", "data") .. "/plugged"

vim.call("plug#begin", plugged_path)

-- ==== plugins ====

-- TODO: reorganise my plugins my god

-- theme
Plug("pondodev/zephyr-nvim")
Plug("nvim-treesitter/nvim-treesitter")

-- airline
Plug("vim-airline/vim-airline")
Plug("vim-airline/vim-airline-themes")

-- autocomplete/error checking
Plug("neovim/nvim-lsp")
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim", { ["do"] = ":MasonUpdate" })
Plug("williamboman/mason-lspconfig.nvim")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("saadparwaiz1/cmp_luasnip")
Plug("L3MON4D3/LuaSnip")
Plug("folke/trouble.nvim")

-- misc useful
Plug("preservim/nerdtree")
Plug("tpope/vim-commentary")
Plug("tpope/vim-fugitive")
Plug("pondodev/vim-dispatch")
Plug("nvim-lua/plenary.nvim")
Plug("BurntSushi/ripgrep")
Plug("nvim-telescope/telescope.nvim")

-- language support
Plug("ziglang/zig.vim")
Plug("Tetralux/odin.vim")

vim.call("plug#end")
