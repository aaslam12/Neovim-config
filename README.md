## Fix Neovim config compatibility for restricted environment and Neovim `0.10`

### To use:
1. Checkout this branch.
2. Run a clean lazy.nvim sync (remove `~/.local/share/nvim/lazy` and `~/.local/state/nvim/lazy`).
3. Restart Neovim.
4. Verify LSP and formatting using the manually installed binaries in `~/.local/bin`.

#### Put this into your `~/.bashrc`
```
export PATH="$HOME/.local/bin:$PATH"`
export LD_LIBRARY_PATH="$HOME/.local/bin:$LD_LIBRARY_PATH"
export LUA_PATH="$HOME/.local/share/lua/?.lua;$HOME/.local/share/lua/?/init.lua;;"
```
use `source ~/.bashrc` to apply these changes

### The process
This branch stabilizes the Neovim configuration for use on a restricted system
without administrative privileges and with an older Neovim version (`0.10.4`).

1. Toolchain & Binary Resolution
   - Replaced broken system clang-format with a statically compiled `x86_64` binary
     that does not depend on missing shared libraries such as `libtinfo.so.5`.
   - Compiled Lua `5.4.6` from source into `~/.local/bin` to provide a usable
     Lua interpreter where the system had none.
   - Disabled Luacheck and nvim-lint entirely due to incompatible C dependencies
     (`argparse`, `lfs`) in this restricted environment.

2. Neovim Plugin Compatibility
   - Pinned critical plugins to versions compatible with Neovim 0.10:
       •` nvim-lspconfig` → `tag v0.1.8`
       • `mason-lspconfig.nvim` → `tag v1.30.0`
   - Disabled NvChad’s default LSP configuration (`nvchad.configs.lspconfig.defaults()`)
     which assumes Neovim 0.11 APIs.
   - Updated Treesitter config with a pcall fallback to handle structural changes
     in newer plugin versions.
   - Updated mason-lspconfig setup to disable automatic installation and avoid
     calls to non-existent 0.11 APIs.

3. Compatibility Shim for mason-lspconfig
   - Added a local shim that defines a no-op `vim.lsp.enable` function when missing,
     preventing crashes in `mason-lspconfig`’s automatic_enable feature on Neovim `0.10`.

4. Configuration Cleanup
   - Removed Copilot plugin references as they require Neovim 0.11.
   - Disabled all linting plugins to avoid background errors.
   - Configured conform.nvim to use absolute paths to local manually built binaries.

5. Maintenance Procedures
   - Established a clean sync routine:
       • Delete plugin cache (`~/.local/share/nvim/lazy` and `~/.local/state/nvim/lazy`)
         to force clean re-clones of pinned plugin versions.
       • Restart Neovim after changes.

6. Resolved Errors
   - Library errors due to missing `libtinfo.so.5` fixed via static binaries.
   - “command not found: lua” resolved by local Lua build.
   - Disabled tools with incompatible C modules (luacheck, nvim-lint).
   - Patched or bypassed plugin code that assumed Neovim 0.11-only APIs.

### Usage Notes:
- After checking out this branch:
    1. Run the clean sync procedure (remove lazy cache and restart Neovim).
    2. Verify that `clangd`, `lua_ls`, and formatters work using binaries in `~/.local/bin`.
    3. Do not re-enable plugins that require native C modules or Neovim 0.11 features.
- This branch targets stability on restricted systems; a future upgrade to Neovim 0.11+
  should revisit pinned plugin versions and remove compatibility shims.

### This branch should be used when:
- Running on systems without administrative privileges or required shared libraries.
- Using Neovim 0.10.x where many plugins assume 0.11+ APIs.
- Avoiding external C dependencies and tools that cannot be built here.

## Phase 1: Setting up Static Binaries
These commands worked because they use standalone versions of tools that don't depend on the school's restricted system libraries.

Note: If unzipping the entire clangd binary is too big, only extract what we need.
### Install Static Clang-Format:
```
mkdir -p ~/.local/bin
wget https://github.com/muttleyxd/clang-tools-static-binaries/releases/latest/download/clang-format-18_linux-amd64 -O ~/.local/bin/clang-format
chmod +x ~/.local/bin/clang-format
```

### Install Static StyLua:
```
wget https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.2/stylua-linux-x86_64.zip
unzip stylua-linux-x86_64.zip -d ~/.local/bin
chmod +x ~/.local/bin/stylua
rm stylua-linux-x86_64.zip
```

### Install Standalone Clangd (LSP):
```
wget https://github.com/clangd/clangd/releases/download/18.1.3/clangd-linux-18.1.3.zip
unzip clangd-linux-18.1.3.zip
mv clangd_18.1.3/bin/clangd ~/.local/bin/
chmod +x ~/.local/bin/clangd
rm -rf clangd_18.1.3 clangd-linux-18.1.3.zip
```

## Phase 2: Building Lua from Source
Since the system lacked a compatible Lua interpreter for your custom scripts, we built one locally.

### Compile and Move Lua:
```
wget https://www.lua.org/ftp/lua-5.4.6.tar.gz
tar -zxf lua-5.4.6.tar.gz
cd lua-5.4.6
make linux
cp src/lua ~/.local/bin/
cp src/luac ~/.local/bin/
chmod +x ~/.local/bin/lua ~/.local/bin/luac
cd ~
rm -rf lua-5.4.6 lua-5.4.6.tar.gz
```

## Phase 3: Fixing Neovim Version Crashes
Pin Plugin Versions (`lua/plugins/init.lua`): Modify plugin list to include specific tags for compatibility with Neovim `0.10.4`:
```
neovim/nvim-lspconfig → tag = "v0.1.8"
williamboman/mason-lspconfig.nvim → tag = "v1.30.0"
```

### Bypass Crashing Defaults: 
In lua/plugins/init.lua, you commented out the crashing NvChad internal defaults:
```-- require("nvchad.configs.lspconfig").defaults()```

Correct Mason Setup (`lua/configs/mason-lspconfig.lua`): You replaced the syntax that caused the attempt to call global `ensure_installed` error:
```
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd" },
    automatic_installation = false,
    handlers = {}, -- Fixed the 'automatic_enable.lua' nil error
})
````

## Phase 4: Final Environment Activation
To make these tools active, you updated your shell and cleared the corrupted plugin state.

### Update `.bashrc`:
```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

The "Nuclear" Plugin Reset: This resolved the module `nvim-treesitter.configs` not found and persistent nil value crashes by forcing a fresh download of the correct pinned versions.
```
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy
```
