# Gemini Project Context: Neovim Configuration (NvChad)

This workspace is a **Neovim configuration** based on **NvChad v2.5**. It is designed to act as a complete Integrated Development Environment (IDE) with pre-configured support for C/C++, Go, Python, Odin, and Haskell.

## Project Overview

*   **Base Framework:** [NvChad v2.5](https://nvchad.com/)
*   **Package Manager:** `lazy.nvim`
*   **Tool Management:** `mason.nvim` (LSPs, DAPs, Linters, Formatters)
*   **Theme:** `carbonfox`
*   **Key Feature:** Extensive language support with automated formatting and linting.

## Directory Structure

*   `init.lua`: The main entry point. Bootstraps `lazy.nvim` and loads NvChad.
*   `lua/chadrc.lua`: NvChad-specific configuration overrides (UI, theme).
*   `lua/options.lua`: General Neovim options (indentation, UI settings).
*   `lua/mappings.lua`: Custom keybindings.
*   `lua/plugins/init.lua`: Definition of all custom plugins and their lazy-loading strategies.
*   `lua/configs/`: detailed configuration files for complex plugins:
    *   `lspconfig.lua`, `mason-lspconfig.lua`: Language Server Protocol setup.
    *   `conform.lua`, `mason-conform.lua`: Formatting setup.
    *   `lint.lua`, `mason-lint.lua`: Linting setup.
    *   `dap.lua`, `dapui.lua`: Debug Adapter Protocol setup.
    *   `cmake-tools.lua`: C/C++ CMake integration.

## Key Configurations & Customizations

### Visuals & Editor
*   **Indentation:** Globally set to **4 spaces** (overriding NvChad's default 2 spaces).
*   **Line Numbers:** Relative line numbers enabled (`vim.opt.relativenumber = true`).
*   **Theme:** `carbonfox`.

### Key Plugins
*   **AI:** `CopilotChat.nvim` (toggle with `<leader>cc`) and `copilot.lua` (accept suggestions with `Alt+l`).
*   **Debugging:** `nvim-dap` and `nvim-dap-ui` for visual debugging.
*   **Build:** `cmake-tools.nvim` for C/C++ projects.
*   **Git:** `gitsigns.nvim` for git integration.

### Important Keybindings
| Key | Action |
| :--- | :--- |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>cc` | Toggle Copilot Chat |
| `<C-n>` | Toggle File Explorer (NvimTree) |
| `<leader>db` | Toggle Debug Breakpoint |
| `<leader>dr` | Continue Debugging |
| `<leader>td` | Toggle all diagnostics |
| `<leader>tv` | Toggle virtual text diagnostics |
| `zF` | Fold a `{}` code block |

## Development & Extension

### Adding a New Language
The project follows a strict pattern for adding language support, detailed in `README.md`:
1.  **LSP:** Add server to `lspconfig.lua` and `mason-lspconfig.lua`.
2.  **Formatting:** Add formatter to `conform.lua` (`formatters_by_ft`).
3.  **Linting:** Add linter to `lint.lua` (`linters_by_ft`).
4.  **Treesitter:** Add language to `configs/treesitter.lua`.
5.  **DAP (Optional):** Configure in `dap.lua` or language-specific DAP config (e.g., `dap-python.lua`).

### Formatting
*   Managed by `conform.nvim`.
*   **Format on Save** is enabled for most languages (configured in `lua/configs/conform.lua`).
*   **C/C++:** Uses `clang-format` with a custom style enforcing 4-space indentation.

### Usage Notes
*   **Updates:** Use `:Lazy sync` to update plugins and `:Mason` to manage external tools.
*   **Health Check:** Use `:checkhealth` to verify configurations.
