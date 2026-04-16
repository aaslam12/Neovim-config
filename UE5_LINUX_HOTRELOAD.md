# UE5 Hot Reload on Linux - Proper Workflow

## The Problem

When you click "Live Reload" or "Compile" in UE5 on Linux, you may get:
```
Warning: RebindPackages not possible (no packages specified)
```

This is because **UE5's Live Coding hot reload has limited support on Linux**. The UI button doesn't properly detect which packages to rebind.

## The Solution: Editor Reload Workflow

Since the Live Reload button doesn't work well on Linux, use this workflow instead:

### Step 1: Build from Neovim
```
Press <leader>uR
```
This builds your code with Live Coding support enabled.

### Step 2: Manually Reload in Editor
In Unreal Engine, go to:
```
Tools → Compile → Recompile [Project] Module
```

Or simply:
- Press **Ctrl+Shift+R** (Recompile Module shortcut)
- Click **Compile** in the toolbar

### Step 3: If Manual Reload Doesn't Work
Close and reopen the editor:
```
1. Close the Unreal Editor
2. Press <leader>uR again from Neovim (builds with Live Coding)
3. Press <leader>uo to relaunch the editor
```

## Why This Happens

- **Live Reload button** relies on HotReloadModule detecting packages via `RebindPackages()`
- On Linux, the editor doesn't automatically populate the package list
- The build IS successful, the DLLs ARE updated
- The editor just needs to be told to reload them manually

## Best Practice for Linux

Since full hot reload doesn't work reliably:

1. **Use Neovim for fast iteration**: `<leader>uR` (builds in 2-4 seconds)
2. **Check editor manually**: Use Compile button or restart editor
3. **Consider Windows/Mac** for seamless hot reload if you need it frequently

## Alternative: Command-Line Reload

If you want complete automation, you could:
1. Build with `<leader>uR`
2. Close the editor
3. Reopen the editor from Neovim with `<leader>uo`

This is the most reliable approach on Linux.
