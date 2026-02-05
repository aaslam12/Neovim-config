# Neovim for Unreal Engine 5 Development

Your Neovim setup is now optimized for UE5 development with minimal memory overhead (MB range vs GB range with IDEs).

## Quick Reference

### Build & Project Management
| Command | Keybind | Description |
|---------|---------|-------------|
| `:UEBuild` | `<leader>nr` | Build project |
| `:UEClean` | `<leader>nc` | Clean build |
| `:UEGenerate` | `<leader>nh` | Regenerate project files |
| `:UELaunch` | `<leader>nl` | Launch UE5 Editor |
| `:UEDiagnostics` | `<leader>nd` | Show build output |
| `:UETasks` | `<leader>nB` | Show all available tasks |

### C++ Development (via clangd LSP)
| Keybind | Action |
|---------|--------|
| `gd` | Go to definition |
| `<leader>cD` | Jump to definition |
| `<leader>cd` | Jump to declaration |
| `<leader>cR` | Find all references |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code actions |
| `K` | Hover info |

### Git Integration
| Keybind | Action |
|---------|--------|
| `]c` | Next diff hunk |
| `[c` | Previous diff hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gd` | Diff this |

## Getting Started

### 1. Set up your UE5 project
```bash
cd /path/to/your/UE5Project
nvim .
```

### 2. Generate project files if needed
Press `<leader>nh` or run `:UEGenerate`

### 3. Generate compile_commands.json for LSP
Press `<leader>nb` → Select "UE_CompileDB" or run `:UECompileDB`

This enables full C++ IntelliSense via clangd.

### 4. Start building
- Quick build: `<leader>nr`
- Clean build: `<leader>nc`
- See output: `<leader>nB` (toggle task panel)

### 5. Launch editor
Press `<leader>nl` or run `:UELaunch` to open the Unreal Engine editor

## Creating C++ Classes Manually

Since there's no CLI tool for UE5 class creation with proper reflection macros, create files manually:

### Create Header (.h)
```cpp
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Pawn.h"
#include "MyCharacter.generated.h"

UCLASS()
class YOURPROJECT_API AMyCharacter : public APawn
{
    GENERATED_BODY()

public:
    AMyCharacter();

    virtual void BeginPlay() override;
    virtual void Tick(float DeltaTime) override;
};
```

### Create Source (.cpp)
```cpp
#include "MyCharacter.h"

AMyCharacter::AMyCharacter()
{
    PrimaryActorTick.bCanEverTick = true;
}

void AMyCharacter::BeginPlay()
{
    Super::BeginPlay();
}

void AMyCharacter::Tick(float DeltaTime)
{
    Super::Tick(DeltaTime);
}
```

Place files in `Source/YourProject/Public/` and `Source/YourProject/Private/`

Then regenerate project files: `<leader>nh`

## LSP Features

### Full IntelliSense
Once you have `compile_commands.json`, clangd provides:
- Code completion (Ctrl+Space)
- Go to definition/declaration
- Find references
- Rename symbols
- Diagnostics with fixes
- Hover documentation

### If IntelliSense isn't working
1. Ensure `compile_commands.json` was generated
2. Check it exists: `:!ls compile_commands.json`
3. Regenerate: `:UECompileDB`
4. Reload Neovim

## Project Structure Reference

```
YourProject/
├── Binaries/          # Compiled binaries
├── Intermediate/      # Build artifacts
├── Source/
│   └── YourProject/
│       ├── Public/    # Header files (.h)
│       └── Private/   # Implementation (.cpp)
├── Content/           # Assets (handled by editor)
├── Saved/             # Runtime saves
├── YourProject.uproject
├── GenerateProjectFiles.sh
├── Makefile
└── compile_commands.json (generated)
```

## Advanced: Custom Build Tasks

Edit `~/.config/nvim/lua/configs/overseer-tasks.lua` to add custom tasks.

Example - Custom shader compilation:
```lua
{
    name = "UE_CompileShaders",
    desc = "Compile custom shaders",
    builder = function()
        return {
            cmd = "bash",
            args = { "-c", "./Shaders/compile.sh" },
            cwd = vim.fn.getcwd(),
            components = { "on_complete_notify", "on_exit_set_status" },
        }
    end,
    tags = { "unreal", "shaders" },
}
```

Then access it: `:OverseerRun UE_CompileShaders`

## Terminal Access

Press `<C-\>` to toggle a terminal pane for quick shell commands.

## Troubleshooting

### clangd not working
- Missing `compile_commands.json`: Run `:UECompileDB`
- Bear not installed: `sudo apt install bear`
- Wrong path: Ensure you're in project root (`:pwd`)

### Build command fails
- Check Makefile exists: `:!ls Makefile`
- Check project structure: `:!ls *.uproject`
- Try manual build: `:!make -j$(nproc)`

### Tasks not showing
- Restart Neovim
- Check overseer: `:OverseerListTags`
- Run `:UETasks` to see all available

### Memory issues with neovim
Very unlikely! Neovim LSP + clangd ≈ 50-100MB vs Rider ≈ 5.6GB

### Editor not launching
- Check UE4Editor in PATH: `:!which UE4Editor`
- Ensure project files generated: `:UEGenerate`
- Try manual: `:!UE4Editor YourProject.uproject`

## Performance Tips

1. **Disable unused diagnostics**: `<leader>td` to toggle all diagnostics
2. **Focus mode**: Use `:only` to maximize editor window
3. **Async compilation**: Build runs in background, use `<leader>nB` to toggle output
4. **Suspend LSP for large files**: clangd auto-disables for files >2MB

## Why This Setup Over Rider?

- **Memory**: Rider ≈ 5.6GB vs Neovim ≈ 50-100MB
- **Speed**: Lightweight terminal editor vs heavy IDE
- **Control**: Full customization via Lua
- **Integration**: Works seamlessly with git, shell tools
- **Cost**: Free vs Rider license
- **Philosophy**: You already use Neovim for everything!

## Resources

- [overseer.nvim docs](https://github.com/stevearc/overseer.nvim)
- [clangd LSP docs](https://clangd.llvm.org/)
- [UE5 Linux Development](https://docs.unrealengine.com/5.0/en-US/linux-development-requirements-for-unreal-engine/)
- [Neovim LSP Config](https://neovim.io/doc/user/lsp.html)

---

**Your Neovim config is ready for UE5 development!** 🚀

All the functionality Rider provided for UE5, without the memory overhead.
