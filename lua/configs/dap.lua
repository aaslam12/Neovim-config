local dap = require("dap")

-- Example configurations for popular languages
-- You will need to install the debuggers yourself
-- via mason.nvim or manually.

-- General keymaps for DAP
vim.keymap.set("n", "<leader>dab", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dac", dap.continue, { desc = "DAP Continue" })
vim.keymap.set("n", "<leader>dan", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<leader>dai", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<leader>dao", dap.step_out, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>dar", dap.repl.toggle, { desc = "Toggle DAP REPL" })
-- vim.keymap.set("n", "<leader>das", dap.session.toggle, { desc = "Toggle DAP Session" })

-- C/C++/Rust with cpptools (cppdbg)
dap.adapters['my-cppdbg'] = {
  type = 'executable',
  command = os.getenv("HOME") .. '/.local/share/nvim/mason/bin/OpenDebugAD7', -- Adjust path if necessary
  name = "cppdbg",
  args = { "-useDebuggeeResponseForExitCode" },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "my-cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    sourceFileMap = {
        ["."] = "${workspaceFolder}",
    },
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false
      },
    },
  },
  {
    name = "Attach to process",
    type = "my-cppdbg",
    request = "attach",
    processId = require('dap.ui.widgets').process_picker,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false
      },
    },
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Python with debugpy
dap.adapters.python = {
    type = "executable",
    command = "python", -- or `python3`
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return vim.fn.input("Path to python executable: ", os.getenv("PYTHON_EXEC") or "python")
        end,
    },
}

-- Javascript/Typescript with node-lldb
-- You'll need to install `npm install -g codelldb` or `npm install -g node-debug2`
-- dap.adapters.node = {
--     type = "executable",
--     command = "node",
--     args = {
--         os.getenv("HOME") .. "/.config/nvim/codelldb-js-debug/dist/src/bootloader.js",
--     },
-- }
-- dap.configurations.typescript = {
--     {
--         type = "node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--         runtimeArgs = { "--nolazy" },
--         sourceMaps = true,
--         protocol = "inspector",
--         port = 9229,
--         console = "integratedTerminal",
--         autoAttach = true,
--     },
-- }
-- dap.configurations.javascript = dap.configurations.typescript

-- Go with dlv
-- dap.adapters.go = {
--     type = "server",
--     port = "${port}",
--     executable = {
--         command = "dlv",
--         args = { "dap", "-l", "127.0.0.1:${port}" },
--     },
-- }
-- dap.configurations.go = {
--     {
--         type = "go",
--         name = "Launch file",
--         request = "launch",
--         program = "${file}",
--     },
-- }

-- You can add more configurations for other languages as needed.
-- Refer to nvim-dap documentation for more details.

-- General keymaps for DAP
-- vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
-- vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP Continue" })
-- vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP Step Over" })
-- vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP Step Into" })
-- vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP Step Out" })
-- vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
-- vim.keymap.set("n", "<leader>ds", dap.session.toggle, { desc = "Toggle DAP Session" })

-- To integrate with Mason for debugger installation, you can add something like:
require("mason-nvim-dap").setup({
    ensure_installed = { "cppdbg" }
})
