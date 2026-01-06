## Neovim Config for Restricted Linux Servers (No Sudo)

This configuration is for C++ and neovim development on restricted Linux environments running Neovim 0.10.4.

It addresses common issues such as:
* **No Sudo/Root Access:** All tools are installed locally to `~/.local/bin`.
* **Outdated System Libraries:** Uses static binaries to bypass `libtinfo` and `libc` version errors.
* **Neovim Version Gap:** Pins plugins to versions compatible with Neovim 0.10 to prevent crashes caused by 0.11+ requirements.
* **Limited Disk Quota:** Avoids large Mason installations by using manual, lightweight binaries.

---

## Prerequisites

Because `mason.nvim` cannot function properly without `pip`, `npm`, or `venv` on these servers, you must manually install the toolchain.

### 1. Prepare local bin directories

Run:

```bash
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/lua
```

### 2. Install the toolchain

Run the following commands to install Lua, clangd, clang-format, and stylua without root privileges.

#### A. Lua 5.4.6 (compiled from source)

Since the system Lua is often missing or outdated, compile a local version. This is required for Neovim formatting scripts.

```bash
cd ~
wget https://www.lua.org/ftp/lua-5.4.6.tar.gz
tar -zxf lua-5.4.6.tar.gz
cd lua-5.4.6
make linux
cp src/lua ~/.local/bin/
cp src/luac ~/.local/bin/
cd ~
rm -rf lua-5.4.6 lua-5.4.6.tar.gz
```

#### B. clangd (LSP for C++)

Downloads a standalone binary for IntelliSense.

```bash
cd ~
wget https://github.com/clangd/clangd/releases/download/18.1.3/clangd-linux-18.1.3.zip
unzip clangd-linux-18.1.3.zip
mv clangd_18.1.3/bin/clangd ~/.local/bin/
rm -rf clangd_18.1.3 clangd-linux-18.1.3.zip
chmod +x ~/.local/bin/clangd
```

#### C. clang-format (static binary)

Use a fully static build to avoid `libtinfo.so.5` errors common on older enterprise Linux distros. Adjust the URL to the static build you prefer; put the binary into `~/.local/bin/` and mark executable.

```bash
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/clang+llvm-18.1.8-x86_64-linux-gnu-ubuntu-18.04.tar.xz

<extract /bin/clang-format from the tar ball>

cp clang+llvm-18.1.8-x86_64-linux-gnu-ubuntu-18.04/bin/clang-format ~/.local/bin/
chmod +x ~/.local/bin/clang-format
rm clang+llvm-18.1.8-x86_64-linux-gnu-ubuntu-18.04.tar.xz
```

#### D. StyLua (Lua formatter)

```bash
cd ~
wget https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip
unzip stylua-linux-x86_64.zip -d ~/.local/bin
rm stylua-linux-x86_64.zip
chmod +x ~/.local/bin/stylua
```

### 3. Update your shell PATH

Add the following to `~/.bashrc` (or your shell profile) and source it:

```bash
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/bin:$LD_LIBRARY_PATH"
export LUA_PATH="$HOME/.local/share/lua/?.lua;$HOME/.local/share/lua/?/init.lua;;"

# Apply changes
source ~/.bashrc
```

---

## Installation

1. **Backup existing config**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

2. **Clone this repository**

```bash
git clone https://github.com/aaslam12/Neovim-config.git ~/.config/nvim
```

3. **Switch branch (if applicable)**

Ensure you are on the `general-server` branch if that contains the server-specific fixes:

```bash
cd ~/.config/nvim
git checkout general-server
```

### Post-installation

If you previously tried to run Neovim and encountered errors (like "nil value" or "module not found"), clear the plugin cache before opening Neovim for the first time:

```bash
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy
```

Additionally, if you use ssh to use this server, you will need to increase your timeout time for clang-format in `conform.lua`. Check this branch's `conform.lua` to see.

---

## Features & fixes included

This configuration includes server-specific patches and workarounds:

* **Plugin pinning:** `nvim-lspconfig` pinned to `v0.1.8` and `mason-lspconfig` to `v1.30.0` to avoid crashes caused by plugins expecting Neovim 0.11 features.
* **Static linking:** Formatting uses `conform.nvim` pointing to absolute paths in `~/.local/bin`, bypassing the broken Mason registry.
* **Linting disabled:** `nvim-lint` and `luacheck` are disabled to avoid dependency hell with `LuaFileSystem` and C libraries.
* **Treesitter fallback:** Includes a `pcall` fix to handle module location changes in newer Treesitter versions.

---

## Verifying setup

1. Open Neovim:

```bash
nvim
```

2. Wait for `lazy.nvim` to finish cloning all plugins.
3. Open a C++ file:

```bash
nvim test.cpp
```

4. Run `:LspInfo` — it should show the `clangd` client attached.
5. Run `:Format` — it should format using your static `clang-format`.
