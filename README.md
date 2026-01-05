## Fix Neovim config compatibility for restricted environment and Neovim 0.10

This branch stabilizes the Neovim configuration for use on a restricted system
without administrative privileges and with an older Neovim version (0.10.4).

1. Toolchain & Binary Resolution
   - Replaced broken system clang-format with a statically compiled x86_64 binary
     that does not depend on missing shared libraries such as libtinfo.so.5.
   - Compiled Lua 5.4.6 from source into ~/.local/bin to provide a usable
     Lua interpreter where the system had none.
   - Disabled Luacheck and nvim-lint entirely due to incompatible C dependencies
     (argparse, lfs) in this restricted environment.

2. Neovim Plugin Compatibility
   - Pinned critical plugins to versions compatible with Neovim 0.10:
       • nvim-lspconfig → tag v0.1.8
       • mason-lspconfig.nvim → tag v1.30.0
   - Disabled NvChad’s default LSP configuration (nvchad.configs.lspconfig.defaults())
     which assumes Neovim 0.11 APIs.
   - Updated Treesitter config with a pcall fallback to handle structural changes
     in newer plugin versions.
   - Updated mason-lspconfig setup to disable automatic installation and avoid
     calls to non-existent 0.11 APIs.

3. Compatibility Shim for mason-lspconfig
   - Added a local shim that defines a no-op vim.lsp.enable function when missing,
     preventing crashes in mason-lspconfig’s automatic_enable feature on Neovim 0.10.

4. Configuration Cleanup
   - Removed Copilot plugin references as they require Neovim 0.11.
   - Disabled all linting plugins to avoid background errors.
   - Configured conform.nvim to use absolute paths to local manually built binaries.

5. Maintenance Procedures
   - Established a clean sync routine:
       • Delete plugin cache (~/.local/share/nvim/lazy and ~/.local/state/nvim/lazy)
         to force clean re-clones of pinned plugin versions.
       • Restart Neovim after changes.

6. Resolved Errors
   - Library errors due to missing libtinfo.so.5 fixed via static binaries.
   - “command not found: lua” resolved by local Lua build.
   - Disabled tools with incompatible C modules (luacheck, nvim-lint).
   - Patched or bypassed plugin code that assumed Neovim 0.11-only APIs.

### Usage Notes:
- After checking out this branch:
    1. Run the clean sync procedure (remove lazy cache and restart Neovim).
    2. Verify that clangd, lua_ls, and formatters work using binaries in ~/.local/bin.
    3. Do not re-enable plugins that require native C modules or Neovim 0.11 features.
- This branch targets stability on restricted systems; a future upgrade to Neovim 0.11+
  should revisit pinned plugin versions and remove compatibility shims.

### This branch should be used when:
- Running on systems without administrative privileges or required shared libraries.
- Using Neovim 0.10.x where many plugins assume 0.11+ APIs.
- Avoiding external C dependencies and tools that cannot be built here.

### To use:
1. Checkout this branch.
2. Run a clean lazy.nvim sync (remove ~/.local/share/nvim/lazy and ~/.local/state/nvim/lazy).
3. Restart Neovim.
4. Verify LSP and formatting using the manually installed binaries in ~/.local/bin.
