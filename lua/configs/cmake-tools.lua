local map = vim.keymap.set
require("cmake-tools").setup({
    cmake_dap_configuration = {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        console = "internalConsole",
        show_console = "always",
    },
})

map("n", "<leader>dad", "<cmd>CMakeDebug<cr>", { desc = "CMake: Debug" })
map("n", "<leader>dav", "<cmd>CMakeDebug<cr>", { desc = "CMake: Debug" })
map("n", "<leader>dal", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "CMake: Select Launch Target" })

