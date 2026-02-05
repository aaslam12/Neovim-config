local is_open_ui = false

return {
    -- UE class and file creation helpers
    {
        "nvim-lua/plenary.nvim",
    },

    -- Terminal integration for UE commands
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = [[<C-\>]],
                direction = "horizontal",
                shade_terminals = true,
                shading_factor = 2,
            })
        end,
    },

    -- Better project detection for UE (finds .uproject)
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                patterns = { ".git", ".uproject", "*.sln", "Makefile" },
                show_hidden = false,
                silent_chdir = true,
                scope_chdir = "global",
                datapath = vim.fn.stdpath("data"),
            })
        end,
    },

    -- ============================================
    -- UnrealEngine.nvim - Simpler UE Integration
    -- ============================================

    -- Main Unreal Engine plugin
    {
        "mbwilding/UnrealEngine.nvim",
        ft = { "cpp", "c", "h", "hpp" },
        cmd = { "UnrealGenerate", "UnrealBuild", "UnrealOpen", "UnrealClean" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            -- Auto-detect .uproject file in current working directory
            local function find_uproject()
                local cwd = vim.fn.getcwd()
                local files = vim.fn.glob(cwd .. "/*.uproject", false, true)
                if #files > 0 then
                    return files[1]
                end
                return nil
            end

            require("unrealengine").setup({
                engine_path = "/home/al/UnrealEngine",
                uproject_path = find_uproject(),
                -- Auto-generate compile_commands.json on entering UE project
                auto_generate = false,
                -- Auto-build on save
                auto_build = false,
                -- Build type (Development, DebugGame, Shipping)
                build_type = "Development",
                -- Platform (Linux, Win64, Mac)
                platform = "Linux",
                -- Build with editor
                with_editor = true,
            })

            -- Keymaps using the commands module
            vim.keymap.set("n", "<leader>ub", function()
                require("unrealengine.commands").build()
            end, { desc = "[U]nreal [B]uild" })

            vim.keymap.set("n", "<leader>ug", function()
                require("unrealengine.commands").generate_lsp()
            end, { desc = "[U]nreal [G]enerate LSP" })

            vim.keymap.set("n", "<leader>uo", function()
                require("unrealengine.commands").open()
            end, { desc = "[U]nreal [O]pen Editor" })

            vim.keymap.set("n", "<leader>uc", function()
                require("unrealengine.commands").clean()
            end, { desc = "[U]nreal [C]lean" })

            vim.keymap.set("n", "<leader>ur", function()
                require("unrealengine.commands").rebuild()
            end, { desc = "[U]nreal [R]ebuild" })
        end,
    },
}
