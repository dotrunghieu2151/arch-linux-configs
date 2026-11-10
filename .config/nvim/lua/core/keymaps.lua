vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk"})

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights"})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number"})
keymap.set("n", "<leader>-", "<C-x>", { desc = "decrement number"})

-- custom start/end line in insert mode
keymap.set("i", "<C-a>", "<C-o>0", { noremap = false})
keymap.set("i", "<C-e>", "<C-o>$", { noremap = false})

-- custom start/end line in normal mode
vim.keymap.set("n", "<C-a>", "0", { noremap = true })
vim.keymap.set("n", "<C-e>", "$", { noremap = true })

-- custom start/end line in normal mode
vim.keymap.set("v", "<C-a>", "0", { noremap = true })
vim.keymap.set("v", "<C-e>", "$", { noremap = true })

vim.keymap.set("n", "<A-a>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-s>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-w>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-d>", "<Right>", { noremap = true, silent = true })
-- custom move key in insert mode
vim.keymap.set("i", "<A-a>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-s>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-w>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-d>", "<Right>", { noremap = true, silent = true })
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically"})
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally"})
keymap.set("n", "<leader>se", "<C-w>==", { desc = "Make split equal size"})
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split"})

-- tab
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab"})
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab"})
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab"})
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab"})
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab"})
