local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- go = { "gofumpt", "goimports-reviser", "golines" },
        -- haskell = { "fourmolu", "stylish-haskell" },
        python = { "isort", "black" },
    },

    formatters = {
        -- -- C & C++
        -- Commented because it interferes with project specific files
        -- ["clang-format"] = {
        --    prepend_args = {
        --        "-style={ \
        --                  IndentWidth: 4, \
        --                  TabWidth: 4, \
        --                  UseTab: Never, \
        --                  AccessModifierOffset: 0, \
        --                  IndentAccessModifiers: true, \
        --                 PackConstructorInitializers: Never}",
        --    },
        --},
        -- -- Golang
        -- ["goimports-reviser"] = {
        --     prepend_args = { "-rm-unused" },
        -- },
        -- golines = {
        --     prepend_args = { "--max-len=150" },
        -- },
        -- -- Lua
        -- stylua = {
        --     prepend_args = {
        --         "--column-width", "150",
        --         "--line-endings", "Unix",
        --         "--indent-type", "Spaces",
        --         "--indent-width", "4",
        --         "--quote-style", "AutoPreferDouble",
        --     },
        -- },
        -- Python
        black = {
            prepend_args = {
                "--fast",
            },
        },
        isort = {
            prepend_args = {
                "--profile",
                "black",
            },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
