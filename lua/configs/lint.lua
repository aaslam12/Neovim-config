local lint = require("lint")

lint.linters_by_ft = {
    -- lua = { "luacheck" },
    -- haskell = { "hlint" },
    -- python = { "flake8" },
}

-- Commenting these out prevents Neovim from trying to configure a linter
-- that doesn't exist or isn't installed.
-- lint.linters.luacheck.args = {
--     "--globals",
--     "love",
--     "vim",
--     "--formatter",
--     "plain",
--     "--codes",
--     "--ranges",
--     "-",
-- }

-- lint.linters.luacheck.cmd = os.getenv("HOME") .. "/.local/bin/luacheck"

-- Disable the autocommand so Neovim doesn't try to lint on every save
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--     callback = function()
--         lint.try_lint()
--     end,
-- })
