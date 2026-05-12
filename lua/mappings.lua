require("nvchad.mappings")

-- add yours here

require("gitsigns").setup()

local map = vim.keymap.set

local optimized_langmap_pairs = {
    { "|", "-" },
    { "\\", "_" },
    { "[", "=" },
    { "{", "+" },
    { "p", "q" },
    { "P", "Q" },
    { "y", "w" },
    { "Y", "W" },
    { "u", "e" },
    { "U", "E" },
    { ".", "r" },
    { ">", "R" },
    { "-", "t" },
    { "_", "T" },
    { "q", "y" },
    { "Q", "Y" },
    { "m", "u" },
    { "M", "U" },
    { "c", "i" },
    { "C", "I" },
    { "d", "o" },
    { "D", "O" },
    { "z", "p" },
    { "Z", "P" },
    { "w", "[" },
    { "W", "{" },
    { "=", "]" },
    { "+", "}" },
    { "]", "\\" },
    { "}", "|" },
    { "h", "a" },
    { "H", "A" },
    { "i", "s" },
    { "I", "S" },
    { "e", "d" },
    { "E", "D" },
    { "a", "f" },
    { "A", "F" },
    { "o", "g" },
    { "O", "G" },
    { "l", "h" },
    { "L", "H" },
    { "t", "j" },
    { "T", "J" },
    { "s", "k" },
    { "S", "K" },
    { "n", "l" },
    { "N", "L" },
    { "r", ";" },
    { "R", ":" },
    { "x", "'" },
    { "X", '"' },
    { "k", "z" },
    { "K", "Z" },
    { "/", "x" },
    { "?", "X" },
    { "'", "c" },
    { '"', "C" },
    { ",", "v" },
    { "<", "V" },
    { ";", "b" },
    { ":", "B" },
    { "g", "n" },
    { "G", "N" },
    { "v", "m" },
    { "V", "M" },
    { "f", "," },
    { "F", "<" },
    { "b", "." },
    { "B", ">" },
    { "j", "/" },
    { "J", "?" },
}

local function escape_langmap_char(char)
    return char:gsub("\\", "\\\\"):gsub('[,;"|]', "\\%1")
end

local function build_langmap(pairs)
    local parts = {}
    for _, pair in ipairs(pairs) do
        parts[#parts + 1] = escape_langmap_char(pair[1]) .. escape_langmap_char(pair[2])
    end
    return table.concat(parts, ",")
end

local optimized_langmap = build_langmap(optimized_langmap_pairs)
local physical_layout_enabled = vim.g.vim_physical_layout ~= false

local function set_vim_layout(enabled)
    physical_layout_enabled = enabled
    vim.g.vim_physical_layout = physical_layout_enabled
    vim.opt.langremap = false
    vim.o.langmap = physical_layout_enabled and optimized_langmap or ""
end

local function toggle_vim_layout()
    set_vim_layout(not physical_layout_enabled)

    local msg = physical_layout_enabled and "Vim layout: optimized physical keys (LTSN for HJKL)"
        or "Vim layout: standard QWERTY keys (HJKL)"
    vim.notify(msg, vim.log.levels.INFO)
end

set_vim_layout(physical_layout_enabled)

map("n", "<leader>tk", toggle_vim_layout, { desc = "Toggle vim key layout (QWERTY/Optimized)" })
map("n", "<leader>jz", toggle_vim_layout, { desc = "Toggle vim key layout (optimized-mode alias)" })

pcall(vim.api.nvim_del_user_command, "VimLayoutToggle")
vim.api.nvim_create_user_command("VimLayoutToggle", toggle_vim_layout, { desc = "Toggle Vim key layout" })

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

-- Overseer main commands
map("n", "<leader>no", "<cmd>OverseerOpen<CR>", { desc = "UE: Open Task List" })
map("n", "<leader>nq", "<cmd>OverseerClose<CR>", { desc = "UE: Close Task List" })

-- Simpler direct task commands using OverseerRun
vim.api.nvim_create_user_command("UEBuild", "OverseerRun UE_Build", { desc = "Build Unreal project" })
vim.api.nvim_create_user_command("UELaunch", "OverseerRun UE_Editor", { desc = "Launch UE editor" })
vim.api.nvim_create_user_command("UETasks", "OverseerToggle", { desc = "Show all UE tasks" })

-- Quick access
map("n", "<leader>ub", "<cmd>OverseerRun UE_Build<CR>", { desc = "UE: Build Project" })
map("n", "<leader>uo", "<cmd>OverseerRun UE_Editor<CR>", { desc = "UE: Launch Editor" })
map("n", "<leader>ut", "<cmd>OverseerToggle<CR>", { desc = "UE: Show Task Output" })

-- Trigger the Live Coding build
vim.keymap.set("n", "<leader>ur", function()
    require("configs.unreal_livecoding").trigger_live_coding_build()
end, { desc = "UE: Trigger Live Coding Build" })

-- Trigger hot reload (requires running editor)
vim.keymap.set("n", "<leader>uh", function()
    require("configs.unreal_livecoding").trigger_hot_reload()
end, { desc = "UE: Hot Reload (Editor must be running)" })

-- Trigger Live Coding build + automatic hot reload
vim.keymap.set("n", "<leader>uR", function()
    require("configs.unreal_livecoding").trigger_live_coding_with_reload()
end, { desc = "UE: Live Coding Build + Hot Reload" })

--
--
--
--
-- Typst
map("n", "<leader>ti", "<cmd>TypstPreviewUpdate<cr>", { desc = "Typst: Install/Update binaries" })

-- 2. Preview Control
map("n", "<leader>tp", "<cmd>TypstPreview<cr>", { desc = "Typst: Start Preview" })
map("n", "<leader>ts", "<cmd>TypstPreviewStop<cr>", { desc = "Typst: Stop Preview" })
map("n", "<leader>tt", "<cmd>TypstPreviewToggle<cr>", { desc = "Typst: Toggle Preview" })

-- 3. Cursor and Scrolling Behavior
-- Toggle whether the preview follows your cursor automatically
map("n", "<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<cr>", { desc = "Typst: Toggle Follow Cursor" })

-- Manually sync the preview to your current cursor position
-- Useful if FollowCursor is turned off
map("n", "<leader>tc", "<cmd>TypstPreviewSyncCursor<cr>", { desc = "Typst: Sync Preview to Cursor" })
