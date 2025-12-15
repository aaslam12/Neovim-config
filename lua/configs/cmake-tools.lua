require("cmake-tools").setup({
  cmake_dap_configuration = {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    console = "internalConsole",
    show_console = "always"
  },
})