vim.g.mapleader = " "
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
-- default draft keymap
-- keymap.set("n", "<>", "", { desc = "" })

-- keymap.set("n", "<Hot Keys>", "Command", { desc = "Anything to describe" })

keymap.set("n", "<S-u>", "<cmd>redo<CR>", { desc = "Un-Undo" }) -- Redo
-- buffer navigation
vim.api.nvim_set_keymap('n', '<leader>,', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>.', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>x', '<Cmd>BufferClose<CR>', opts)
-- Neorg workspaces navigation
keymap.set("n", "<leader>nl", "<cmd>Neorg workspace life<CR>", { desc = "Go to LIFE notes" })
keymap.set("n", "<leader>nw", "<cmd>Neorg workspace work<CR>", { desc = "Go to WORK notes" })
keymap.set("n", "<leader>nn", "<cmd>Neorg workspace journal<CR>", { desc = "Get to Journal Hub" })
-- Quick note creation
keymap.set("n", "<leader>jt", "<cmd>Neorg journal today<CR>", { desc = "Make Todays note" })
keymap.set("n", "<leader>jy", "<cmd>Neorg journal yesterday<CR>", { desc = "Correct Previous note" })
keymap.set("n", "<leader>jT", "<cmd>Neorg journal tomorrow<CR>", { desc = "Plan Tommorows note" })
-- Scissors Snippets
keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
keymap.set({"n", "x"}, "<leader>sa", function() require("scissors").addNewSnippet() end)

vim.keymap.set("n", "<leader>ef", "<CMD>Oil<CR>", { desc = "Open parent directory" })

keymap.set("n", "Y", "<cmd>YoinkSave<CR>", { desc = "Save to Yoink list" })
keymap.set("n", "<leader>y", "<cmd>YoinkOpen<CR>", { desc = "Open Yoink list" })
