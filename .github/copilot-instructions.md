# Neovim Configuration - Copilot Instructions

A NvChad v2.5-based Neovim IDE configuration with support for multiple programming languages (C/C++, Go, Python, Java, Odin, Haskell, Lua).

## Architecture Overview

This is a **plugin-based Neovim IDE configuration** structured around three core management systems:

### Plugin Management (lazy.nvim)
- **Plugin definition**: `lua/plugins/init.lua` - lists all plugins with their lazy-loading strategies
- **Individual plugin configs**: `lua/plugins/*.lua` - detailed setup for single plugins (e.g., `ubt.lua`, `dap.lua`)
- **Bootstrap**: `init.lua` - loads lazy.nvim and orchestrates plugin initialization

### Tool Management (mason.nvim)
Mason automatically installs external tools (LSPs, formatters, linters, debuggers):
- **LSPs**: `lua/configs/mason-lspconfig.lua` - builds install list from `lspconfig.servers`
- **Formatters**: `lua/configs/mason-conform.lua` - builds install list from `conform.formatters_by_ft`
- **Linters**: `lua/configs/mason-lint.lua` - builds install list from `lint.linters_by_ft`
- **Debuggers**: `lua/configs/mason-dap.lua` - DAP adapters (Python debugpy, C++ lldb, etc.)

### Configuration Hub (lua/configs/)
Each complex plugin has its own config file that defines how the tool behaves:
- **`lspconfig.lua`**: Language Server Protocol setup - add new servers to `lspconfig.servers` and optionally to `default_servers`
- **`conform.lua`**: Formatting rules - define formatters per filetype in `formatters_by_ft` and tool-specific args in `formatters`
- **`lint.lua`**: Linting rules - define linters per filetype in `linters_by_ft` and tool-specific args
- **`treesitter.lua`**: Syntax highlighting - list language parsers in `ensure_installed`
- **`dap.lua`**, **`dapui.lua`**: Debugging setup - DAP configuration and UI keybindings

### User-Facing Customization
- **`lua/options.lua`**: Editor settings (indentation, line numbers, colorcolumn, etc.)
- **`lua/mappings.lua`**: Custom keybindings (LSP commands, git operations, diagnostics toggles)
- **`.stylua.toml`**: Lua formatter configuration (indentation, line width)

## Adding Language Support

Follow this **5-step pattern** (essential for consistency):

1. **LSP**: Add server name to `lspconfig.servers` in `lua/configs/lspconfig.lua`
   - Optionally add to `default_servers` if it needs minimal custom config
   - Add custom `vim.lsp.config()` call if special setup is needed (disable formatting, custom settings, etc.)

2. **Formatter**: Add filetype → formatters mapping in `lua/configs/conform.lua`
   - Example: `python = { "isort", "black" }`
   - Add tool-specific args in the `formatters` table (e.g., black line length, isort profile)

3. **Linter**: Add filetype → linters mapping in `lua/configs/lint.lua`
   - Example: `python = { "flake8" }`
   - Modify linter args if needed (e.g., luacheck global variables)

4. **Syntax Highlighting**: Add language name to `ensure_installed` in `lua/configs/treesitter.lua`
   - Language name is typically the treesitter parser name (e.g., "python", "cpp", "go")

5. **Debugging (Optional)**: Add DAP adapter config in `lua/configs/dap.lua` or create language-specific file
   - Example: `dap-python.lua` configures Python debugging with debugpy path

**Mason automatically installs tools** - no manual mason configuration needed once you define formatters/linters/LSPs.

## Key Conventions

### Indentation & Style
- **Global indent**: 4 spaces (configured in `lua/options.lua`)
- **Lua code**: Follow `.stylua.toml` (4-space indent, 120 column width)
- **Line length**: 150 characters (colorcolumn indicator at column 151)
- **Relative line numbers**: Enabled by default

### Keybinding Patterns
All custom keybindings in `lua/mappings.lua` follow these prefixes:
- `<leader>c` - Code/LSP operations (rename, definition, references, etc.)
- `<leader>f` - File/Telescope operations (find files, grep, buffers)
- `<leader>g` - Git operations (stage, reset, blame, diff via gitsigns)
- `<leader>d` - Debugging (breakpoints, UI, continue)
- `<leader>t` - Toggles (diagnostics on/off, virtual text on/off)
- `<leader>m` - Make/Build (build system via `:make`)
- `<leader>n` - Unreal Build Tool operations (UBT.nvim - build, run, gen headers, etc.)
- `<leader>cc` - Copilot Chat (AI assistant)

Use `Alt+l` to accept Copilot inline suggestions.

### Build System Integration
- **Default build**: `vim.opt.makeprg = "python3 build.py"` in `lua/options.lua`
- **Invoked by**: `<leader>mm` (`:make`), `<leader>mt` (`:make --no-tests`), `<leader>mc` (`:make --clean`)
- **Quickfix list**: `<leader>mf` opens `:copen` to view build errors
- **Error format**: Configured for GCC/Clang/Ninja in `errorformat`

### Plugin Organization
- **Eager-loaded plugins**: NvChad base, Treesitter, LSPConfig (needed immediately)
- **VeryLazy plugins**: Mason variants, DAP, Linting (loaded on-demand to speed up startup)
- **Lazy plugins**: Telescope, Gitsigns, other utilities (loaded only when first used)
- **Plugin dependencies**: Always explicitly declared (e.g., mason-lspconfig depends on nvim-lspconfig)

## File Organization Reference

```
lua/
├── options.lua              # Editor settings (indentation, UI, build system)
├── mappings.lua             # All keybindings organized by prefix
├── plugins/
│   ├── init.lua             # Main plugin definition list
│   ├── ubt.lua              # Unreal Build Tool plugin + keybindings
│   └── (other single-plugin configs)
└── configs/
    ├── lazy.lua             # Lazy.nvim options
    ├── lspconfig.lua        # LSP server definitions & custom setups
    ├── mason-lspconfig.lua  # Auto-install LSP servers
    ├── conform.lua          # Formatters by filetype & tool args
    ├── mason-conform.lua    # Auto-install formatters
    ├── lint.lua             # Linters by filetype & tool args
    ├── mason-lint.lua       # Auto-install linters
    ├── treesitter.lua       # Syntax highlighting languages
    ├── dap.lua              # Debugging setup & keybindings
    ├── dapui.lua            # Debug UI setup
    └── mason-dap.lua        # Auto-install DAP adapters
```

## Common Operations

### Installing/Updating Tools
```vim
:Lazy sync          " Update all plugins
:Mason              " Interactive tool manager (LSPs, formatters, linters, DAPs)
:checkhealth        " Verify all systems are working
```

### Checking Configuration
```vim
:lua print(require"nvim-treesitter.parsers".get_buf_lang())  " Current treesitter language
:set filetype?                                               " Current file's detected type
:echo &makeprg                                               " Current build command
```

### Formatting & Linting
- Format on save is enabled (triggered by `BufWritePre` event)
- Linting runs on `BufEnter`, `BufWritePost`, `InsertLeave`
- Diagnostics toggled with `<leader>td` (all) or `<leader>tv` (virtual text only)

### Java-Specific
- Uses `jdtls` (external plugin) instead of standard LSP
- Automatically loaded when opening `.java` files via autocmd in `lspconfig.lua`

## Troubleshooting Patterns

### Plugin not loading
1. Check if plugin is defined in `lua/plugins/init.lua`
2. Check `lazy` loading condition (event, ft, dependencies)
3. Run `:Lazy show <plugin-name>` to inspect status

### LSP/Formatter/Linter not working
1. Verify tool name in `lspconfig.servers`, `conform.formatters_by_ft`, or `lint.linters_by_ft`
2. Run `:Mason` and ensure tool is installed
3. Check `:checkhealth` for configuration issues
4. Verify filetype detection: `:set filetype?`

### Adding new language - checklist
- [ ] Add LSP to `lspconfig.servers`
- [ ] Add formatter(s) to `conform.formatters_by_ft` 
- [ ] Add linter(s) to `lint.linters_by_ft`
- [ ] Add treesitter parser to `treesitter.lua`
- [ ] (Optional) Add DAP adapter if debugging needed
- [ ] Run `:Lazy sync` to install plugin updates
- [ ] Run `:Mason` to install external tools
- [ ] Test: `:checkhealth`
