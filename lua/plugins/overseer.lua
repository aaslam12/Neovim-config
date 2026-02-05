return {
    "stevearc/overseer.nvim",
    cmd = {
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerRun",
    },
    opts = {
        task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
        },
        actions_use_nvim_notify = true,
        templates = { "builtin" },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        -- Load custom UE task templates from file
        local task_templates = require("configs.overseer-tasks")
        for _, template in ipairs(task_templates) do
            overseer.register_template(template)
        end

        -- Keybindings for Unreal Engine tasks on Linux
        local map = vim.keymap.set

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
    end,
}
