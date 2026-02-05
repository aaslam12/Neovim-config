# Fixing clangd Diagnostics for Unreal Engine

## The Problem

You're seeing errors in Neovim that don't appear when building the project.

This happens because:
1. clangd uses different warning flags than UE's build system
2. UE uses many compiler-specific extensions and pragmas
3. clangd doesn't understand UE's custom macros and reflection system

## The Solution

Created `.clangd` config file in your project root that:
- Suppresses common false-positive warnings
- Removes problematic compiler flags
- Configures clangd for UE compatibility

## Setup

1. **The config is already created** in your Tanks directory
2. **Restart LSP** to apply it:
   ```
   :LspRestart
   ```

## What Errors Are Normal

Even with the config, you might still see:

### Expected False Positives (can be ignored):

1. **"Unknown type name" for UE macros**
   - `UCLASS()`, `UPROPERTY()`, `UFUNCTION()`
   - These are processed by Unreal Header Tool, not clangd
   - Your code WILL compile fine

2. **"No member named" in generated.h files**
   - Files like `MyClass.generated.h`
   - These are generated during build
   - clangd can't see them until first build

3. **"Use of undeclared identifier" for engine types**
   - Sometimes clangd can't find engine headers
   - Build will still work

### Real Errors (should fix):

1. **Syntax errors** - missing semicolons, brackets, etc.
2. **Type mismatches** - wrong function arguments
3. **Undefined symbols** you actually use in code
4. **Include errors** for files you created

## How to Tell Real vs False Errors

**Rule of thumb**: If it builds successfully (`:UEBuild`), the errors are false positives.

**Test**: 
1. See error in Neovim
2. Run `:UEBuild`
3. If build succeeds → false positive, ignore it
4. If build fails → real error, fix it

## The .clangd Config File

Located at: `~/Documents/Unreal Projects/Tanks/.clangd`

Key settings:
```yaml
CompileFlags:
  Remove: 
    - -Werror      # Don't treat warnings as errors
    - -Wall        # Reduce warning noise
  Add:
    - -Wno-unknown-pragmas         # Ignore UE pragmas
    - -Wno-unused-variable         # UE often has intentional unused vars
    - -ferror-limit=0              # Show all errors

Diagnostics:
  Suppress:
    - unused-variable              # Common in UE
    - deprecated-declarations      # UE deprecates gradually
  UnusedIncludes: None             # Don't warn about includes
```

## Tuning the Config

If you still see too many false errors, edit `.clangd` and add more suppressions:

```yaml
Diagnostics:
  Suppress:
    - <error-name-here>
```

Get the error name by hovering over it in Neovim.

## Alternative: Disable Diagnostics Entirely

If false positives are too annoying:

1. **Disable for current buffer**:
   ```
   <leader>td
   ```

2. **Disable inline virtual text**:
   ```
   <leader>tv
   ```

3. **Keep only real errors**:
   Add to `.clangd`:
   ```yaml
   Diagnostics:
     Suppress: '*'
   ```
   This disables ALL diagnostics, only syntax errors remain.

## Best Practice

For UE development with clangd:
1. Use diagnostics as **hints**, not absolute truth
2. Trust the **build output** (`make`) as source of truth
3. Focus on **code completion** (which works great!)
4. Ignore macro-related errors (UCLASS, UPROPERTY, etc.)

## Why Not Just Use Build Errors?

Because clangd provides:
- ✅ Instant code completion
- ✅ Go to definition
- ✅ Symbol search
- ✅ Quick documentation
- ✅ Real-time syntax checking (mostly accurate)

The false positives are a small price for these features!

## Summary

- ✅ Created `.clangd` config to reduce false positives
- ✅ Restart LSP: `:LspRestart`
- ✅ Ignore macro-related errors (UCLASS, etc)
- ✅ Trust build output for real errors
- ✅ Enjoy code completion and navigation!

---

**clangd + UE = Good enough! Not perfect, but much better than nothing.** 🎉
