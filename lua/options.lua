require("nvchad.options")

local o = vim.o

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto"
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.autoread = true

vim.opt.splitright = true
vim.opt.list = true
vim.opt.listchars = {
    tab = "▸ ",
    trail = "·",
    extends = "❯",
    precedes = "❮",
}

vim.opt.colorcolumn = "151"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

o.cursorlineopt = "both" -- to enable cursorline!

-- Build Configuration
-- Use the project's build.py script for :make
vim.opt.makeprg = "python3 build.py"
-- Standard error format for GCC/Clang/Ninja
vim.opt.errorformat = "%f:%l:%c: %m"

-- vim.o.scrolloff = 50
-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])

vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})
