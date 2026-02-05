# ✅ Include Sorting Disabled for Unreal Projects

## The Problem

clangd was automatically sorting includes alphabetically, which breaks Unreal Engine builds because:
- UE requires `.generated.h` to be the **last** include
- Sorting moves it elsewhere
- Build fails with missing symbols

## The Solution

Created two config files that disable include sorting:

### 1. `.clangd` (LSP config)
```yaml
Formatting:
  SortIncludes: Never
```

### 2. `.clang-format` (Formatting config)
```yaml
SortIncludes: Never
SortUsingDeclarations: false
```

## Files Created

Both files are in your Tanks project directory:
- `~/.config/nvim/lua/configs/overseer-tasks.lua` → Created .clangd config
- `~/.config/nvim/lua/configs/overseer-tasks.lua` → Created .clang-format config

Actually located at:
- `~/Documents/Unreal Projects/Tanks/.clangd`
- `~/Documents/Unreal Projects/Tanks/.clang-format`

## What This Means

### Before (BROKEN)
```cpp
#include "Engine/Core.h"
#include "MyClass.generated.h"    // ← moved by sorting!
#include "MyClass.h"
```

Build error! `.generated.h` should be last.

### After (WORKS)
```cpp
#include "MyClass.h"
#include "Engine/Core.h"
#include "MyClass.generated.h"    // ← stays last!
```

Perfect! Build succeeds.

## Setup

No action needed! The files are already created.

Just:
1. Restart LSP if you haven't already:
   ```
   :LspRestart
   ```

2. Verify it works:
   - Open a .cpp file
   - Try to format it (clangd won't reorder includes now)

## Formatting Behavior

With these configs:
- ✅ No include sorting
- ✅ `#include "MyFile.generated.h"` stays at bottom
- ✅ Builds work correctly
- ❌ Lose automatic include organization (acceptable for UE)

## For Other UE Projects

If you create another UE project, copy these files:
```bash
cp ~/Documents/Unreal\ Projects/Tanks/.clangd <new-project>/
cp ~/Documents/Unreal\ Projects/Tanks/.clang-format <new-project>/
```

Or just remember to create them with `SortIncludes: Never`.

## Why Both Files?

- `.clangd` → Controls clangd LSP behavior
- `.clang-format` → Controls actual formatting tools

Having both ensures it works everywhere:
- In Neovim LSP
- In any editor using clang-format
- Via command-line formatting tools

---

**Include sorting is now disabled for your UE project!** ✅
