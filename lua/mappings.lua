require("nvchad.mappings")

-- add yours here

require("gitsigns").setup()

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- unbound because i have already mapped caps lock to escape
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Restore <C-n> to toggle the file explorer (NvimTree)
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

local builtin = require("telescope.builtin")

map("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })

map("n", "<leader>ft", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope All Diagnostics in open buffers" })
map("n", "<leader>cv", vim.diagnostic.open_float, { desc = "View Code Diagnostics" })

-- Keybinding for switching between open buffers
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope Find Buffers" })

map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "See code generation options" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename variable" })
map("n", "<leader>cR", vim.lsp.buf.references, { desc = "List all references" })
map("n", "<leader>cd", vim.lsp.buf.declaration, { desc = "Jump to declaration" })
map("n", "<leader>cD", vim.lsp.buf.definition, { desc = "Jump to definition" })
map("n", "<leader>cu", vim.lsp.buf.type_definition, { desc = "See definition of the type under cursor" })
map("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "Lists all the implementations for the symbol" })
-- map("n", "K", vim.lsp.buf.hover, { desc = "Open " }) -- it is already a default keybinding

map("i", "<C-BS>", "<C-w>", { desc = "Ctrl+Backspace deletes a word left of the cursor" })

map("n", "<C-4>", "^", { desc = "Go to the first non-whitespace character" })
-- map("n", "zF", "<cmd>zf a{<CR>", { noremap = true, desc = "Folds/Collapses a {} code block" })
-- simulate the exact normal-mode sequence "zfa{"
map("n", "zF", function()
    vim.cmd("normal! zfa{")
end, { noremap = true, desc = "Fold a {} block zfa{" })

-- GIT DIFFING COMMANDS
local gitsigns = require("gitsigns")

-- Navigation
map("n", "]c", function()
    if vim.wo.diff then
        return "]c"
    end
    vim.schedule(function()
        gitsigns.next_hunk()
    end)
    return "<Ignore>"
end, { expr = true })

map("n", "[c", function()
    if vim.wo.diff then
        return "[c"
    end
    vim.schedule(function()
        gitsigns.prev_hunk()
    end)
    return "<Ignore>"
end, { expr = true })

-- Actions
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stages the file to be committed" })
map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Restores entire code block from the diff" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preiew the change in a floating window" })
map("n", "<leader>gb", function()
    gitsigns.blame_line({ full = true }, { desc = "See who is to blame for this code" })
end)
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Opens a side by side diff" })

map("n", "<C-1>", "^", { desc = "Go to the first non-whitespace character" })
map("n", "<C-2>", "$", { desc = "Go to the end of the line" })
