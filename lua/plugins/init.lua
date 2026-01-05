return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        tag = "v0.1.8",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        tag = "v1.30.0",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = { "jay-babu/mason-nvim-dap.nvim" },
        config = function()
            require("configs.dap")
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("configs.dapui")
        end,
    },

    -- Required for nvim-dap-ui
    { "nvim-neotest/nvim-nio" },

    {
        "Civitasv/cmake-tools.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("configs.cmake-tools")
        end,
    },
}
