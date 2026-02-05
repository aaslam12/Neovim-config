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
map("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "View all code symbols in current buffer" })
map(
    "n",
    "<leader>cS",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
    { desc = "View all code symbols in all buffer" }
)

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

-- Define the original scrollback value
local scroll_value = 10000

-- Function to clear the terminal buffer
local function clear_terminal()
    vim.opt_local.scrollback = 200
    vim.api.nvim_command("startinsert")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("clear<CR>", true, false, true), "t", true)

    -- Delay restoring scrollback to ensure the buffer is cleared
    vim.defer_fn(function()
        vim.opt_local.scrollback = scroll_value
    end, 100)
end

vim.keymap.set("t", "<C-l>", function()
    clear_terminal()
end, { desc = "Clear terminal buffer" })

--
--
--
-- DIAGNOSTICS KEYBINDS
-- toggle all diagnostics on/off
local function toggle_all_diags()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

-- toggle virtual text (inline messages)
local function toggle_virtual_text()
    local cfg = vim.diagnostic.config()
    vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
end

-- toggle all diagnostics
vim.keymap.set("n", "<leader>td", toggle_all_diags, { desc = "Toggle all diagnostics" })

-- toggle inline virtual text
vim.keymap.set("n", "<leader>tv", toggle_virtual_text, { desc = "Toggle inline virtual text" })

-- Build System (uses makeprg = ./build.py)
map("n", "<leader>mm", "<cmd>make<CR>", { desc = "Run Build Script (Default)" })
map("n", "<leader>mt", "<cmd>make --no-tests<CR>", { desc = "Run Build Script (No Tests)" })
map("n", "<leader>mc", "<cmd>make --clean<CR>", { desc = "Clean Build Directory" })
map("n", "<leader>mf", "<cmd>copen<CR>", { desc = "Open Quickfix List (Build Errors)" })

-- Build tasks
map("n", "<leader>nb", "<cmd>OverseerRun<CR>", { desc = "UE: Run Task" })
map("n", "<leader>nB", "<cmd>OverseerToggle<CR>", { desc = "UE: Toggle Task List" })

-- Editor tasks
map("n", "<leader>nh", "<cmd>OverseerRun UE_GenerateProjectFiles<CR>", { desc = "UE: Generate Project Files" })
map("n", "<leader>nH", "<cmd>OverseerToggle<CR>", { desc = "UE: Show Tasks" })

-- Quick access
map("n", "<leader>nr", "<cmd>OverseerRun UE_Build<CR>", { desc = "UE: Build Project" })
map("n", "<leader>nc", "<cmd>OverseerRun UE_Clean<CR>", { desc = "UE: Clean Build" })
map("n", "<leader>nl", "<cmd>OverseerRun UE_Editor<CR>", { desc = "UE: Launch Editor" })
map("n", "<leader>nd", "<cmd>OverseerRun UE_Diagnostics<CR>", { desc = "UE: Show Task Output" })

-- Overseer main commands
map("n", "<leader>no", "<cmd>OverseerOpen<CR>", { desc = "UE: Open Task List" })
map("n", "<leader>nq", "<cmd>OverseerClose<CR>", { desc = "UE: Close Task List" })

-- Simpler direct task commands using OverseerRun
vim.api.nvim_create_user_command("UEBuild", "OverseerRun UE_Build", { desc = "Build Unreal project" })
vim.api.nvim_create_user_command("UEClean", "OverseerRun UE_Clean", { desc = "Clean build" })
vim.api.nvim_create_user_command("UEGenerate", "OverseerRun UE_GenerateProjectFiles", { desc = "Generate project files" })
vim.api.nvim_create_user_command("UELaunch", "OverseerRun UE_Editor", { desc = "Launch UE editor" })
vim.api.nvim_create_user_command("UECompileDB", "OverseerRun UE_CompileDB", { desc = "Generate compile_commands.json" })
vim.api.nvim_create_user_command("UETasks", "OverseerToggle", { desc = "Show all UE tasks" })
