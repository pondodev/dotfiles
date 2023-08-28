-- custom binds for various functionality

-- git
vim.keymap.set("n", "<C-g>a", "<cmd>Git add %<cr>")
vim.keymap.set("n", "<C-g>c", "<cmd>Git commit<cr>")
vim.keymap.set("n", "<C-g>b", "<cmd>Git blame<cr>")
vim.keymap.set("n", "<C-g>l", "<cmd>Git log<cr>")
vim.keymap.set("n", "<C-g>d", "<cmd>Git diff %<cr>")
vim.keymap.set("n", "<C-g>s", "<cmd>Git status<cr>")

-- nerdtree
vim.keymap.set("", "<C-e>", "<cmd>NERDTreeToggle<cr>")
vim.keymap.set("!", "<C-e>", "<cmd>NERDTreeToggle<cr>")

-- folds
vim.keymap.set("", "<Space>", "za", { noremap = true })
vim.keymap.set("", "<CR>", "zA", { noremap = true })

-- telescope binds
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true })

-- workspace binds
vim.keymap.set("n", "<leader>wa", "<cmd>AbortDispatch<cr>", { noremap = true })
vim.keymap.set("n", "<leader>we", "<cmd>lua Workspace.open_commands_popup()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ww", "<cmd>lua Workspace.run_last_command()<cr>", { noremap = true })

-- misc
vim.keymap.set("c", "qq", "qa")

