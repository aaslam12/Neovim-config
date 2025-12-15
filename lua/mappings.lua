require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- unbound because i already mapped caps lock to escape
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Restore <C-n> to toggle the file explorer (NvimTree)
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Define the Telescope builtins module
local builtin = require("telescope.builtin")

-- Keybinding for finding files (fuzzy search for file names)
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find Files" })

-- Keybinding for searching content across all project files (live grep)
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })

-- Keybinding for switching between open buffers
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope Find Buffers" })
