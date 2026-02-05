# Unreal Engine Neovim Setup

## Plugin Installed

**UnrealEngine.nvim** by mbwilding - A simpler alternative to the taku25 suite.

## Configuration

Located in: `~/.config/nvim/lua/plugins/unreal.lua`

### Settings:
- Engine Path: `/home/al/UnrealEngine`
- Platform: `Linux`
- Build Type: `Development`
- Auto-generate LSP: `false` (manual control)
- Auto-build on save: `false`

## Available Commands

### Via Keymaps (Leader key + u + letter):

- `<leader>ub` - **Build** the project
- `<leader>ug` - **Generate** LSP files (compile_commands.json and .clangd)
- `<leader>uo` - **Open** Unreal Editor
- `<leader>uc` - **Clean** project (delete generated files)
- `<leader>ur` - **Rebuild** (clean + build)

### Via Lua Functions:

```lua
:lua require("unrealengine.commands").generate_lsp()
:lua require("unrealengine.commands").build()
:lua require("unrealengine.commands").open()
:lua require("unrealengine.commands").clean()
:lua require("unrealengine.commands").rebuild()
```

## Workflow

1. **Navigate to your project root** (where .uproject is):
   ```bash
   cd ~/Documents/Unreal\ Projects/Tanks
   ```

2. **Open Neovim**:
   ```bash
   nvim
   ```

3. **Generate LSP configuration** (first time or after adding classes):
   ```
   <leader>ug
   ```
   This will:
   - Create/update compile_commands.json (for clangd LSP)
   - Create/update .clangd configuration file

4. **Edit your C++ files** - LSP should now work with autocompletion

5. **Build the project**:
   ```
   <leader>ub
   ```

6. **Launch Unreal Editor**:
   ```
   <leader>uo
   ```

## Features

✅ **Automatic LSP setup** - Generates compile_commands.json for clangd
✅ **Build integration** - Build from Neovim
✅ **Editor launching** - Start Unreal Editor from Neovim
✅ **Clean/Rebuild** - Project management commands
✅ **Auto-detect** - Finds .uproject in current directory

## Troubleshooting

### LSP not working?
1. Make sure you're in the project root directory
2. Run `<leader>ug` to regenerate LSP files
3. Restart Neovim or run `:LspRestart`

### Build failing?
- Check that UnrealBuildTool is working: 
  ```bash
  make
  ```
- Ensure you have build dependencies installed

### Editor won't launch?
- Check engine path in config: `/home/al/UnrealEngine`
- Verify UnrealEditor binary exists:
  ```bash
  ls /home/al/UnrealEngine/Engine/Binaries/Linux/UnrealEditor
  ```

## Additional Plugins Kept

You still have these useful plugins configured:

- **toggleterm.nvim** - Terminal integration (Ctrl+\)
- **project.nvim** - Project detection
- **plenary.nvim** - Lua utilities

## What Was Removed

The taku25 plugin suite (UEP.nvim, UBT.nvim, UCM.nvim, etc.) was removed because:
- Required complex Rust backend server
- Had Linux path detection issues
- Needed manual server initialization
- Was overkill for basic Unreal Engine + LSP workflow

UnrealEngine.nvim provides the essential features in a simpler package.
