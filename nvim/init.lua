vim.opt.syntax          = "on"
vim.opt.ignorecase      = true
vim.opt.confirm         = true
vim.opt.number          = true
vim.opt.relativenumber  = true
local indent_level      = 4
vim.opt.tabstop         = indent_level
vim.opt.softtabstop     = indent_level
vim.opt.shiftwidth      = indent_level
vim.opt.expandtab       = true
vim.opt.ruler           = true
vim.opt.autoindent      = true
vim.opt.mouse           = "a"
vim.opt.laststatus      = 2
vim.opt.visualbell      = true
vim.opt.scrolloff       = 6
vim.opt.splitbelow      = true
vim.opt.splitright      = true
vim.opt.wrap            = false
vim.opt.cursorline      = true
vim.opt.spell           = true
vim.opt.spelllang       = "en_gb"
vim.opt.spelloptions    = "camel,noplainbuffer"
vim.opt.foldenable      = true
vim.opt.foldlevelstart  = 999
vim.opt.foldmethod      = "syntax"
vim.opt.list            = true
vim.opt.listchars       = "tab:>·,trail:-"

-- set shell to zsh, with bash as a fallback
local shell = vim.fn.system({"which", "zsh"})
local nullsToCull = 1
vim.opt.shell = string.sub(shell, 1, string.len(shell) - nullsToCull)
if vim.opt.shell == "" or vim.opt.shell == nil then
    shell = vim.fn.system({"which", "bash"})
    vim.opt.shell = string.sub(shell, 1, string.len(shell) - nullsToCull)
end

vim.g.mapleader = "\\"

vim.g["airline_theme"]                              = "base16_spacemacs"
vim.g["airline#extensions#tabline#enabled"]         = 1
vim.g["airline#extensions#tabline#left_sep"]        = ' '
vim.g["airline#extensions#tabline#left_alt_sep"]    = '|'
vim.g["airline#extensions#tabline#formatter"]       = 'unique_tail'
vim.g["airline#extensions#fugitiveline#enabled"]    = 1
vim.g["airline_powerline_fonts"]                    = 1

-- these just ensure that :make and :Make (+ other :Dispatch related commands)
-- don't have any ansi colour codes in their output
vim.g.dispatch_pipe = "2>&1 | sed -e $'s/\\x1b\\[[0-9;]*m//g'"
vim.opt.shellpipe = vim.g.dispatch_pipe .. " | tee %s"

require("consts")
require("helpers")          -- helper functions, stored in the `Helpers` map
require("plugins")          -- load plugins
require("zephyr")           -- set colour theme
require("lsp")              -- configure lsp
require("workspaces")       -- workspace functionality
require("binds")            -- configure binds
if Helpers.file_exists(Consts.WORK_CONFIG_FILE) then
    require("work_config")  -- top secret config for work stuff (shh!)
end

-- open terminal/quickfix without line numbers
local function remove_line_numbers()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
end

vim.api.nvim_create_autocmd({ "TermOpen" },
    {
        pattern = "*",
        callback = remove_line_numbers,
    })
vim.api.nvim_create_autocmd({ "BufNew", "BufRead" },
    {
        pattern = "Quickfix",
        callback = remove_line_numbers,
    })

-- scons related files should be read as python files (because, you know, they
-- are)
local function set_python_syntax()
    vim.opt_local.syntax = "python"
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
    {
        pattern = "SConstruct",
        callback = set_python_syntax,
    })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
    {
        pattern = "SConscript",
        callback = set_python_syntax,
    })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
    {
        pattern = "*.md",
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.textwidth = 120
        end,
    })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
    {
        pattern = "*.gmi",
        callback = function()
            vim.opt_local.wrap = true
        end,
    })

