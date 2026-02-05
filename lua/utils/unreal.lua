-- Unreal Engine utilities for Neovim
local M = {}

-- Get the current project's .uproject file
function M.get_uproject()
    local uproject = vim.fn.glob("*.uproject")
    if uproject == "" then
        vim.notify("No .uproject file found in current directory", vim.log.levels.ERROR)
        return nil
    end
    return uproject
end

-- Get the project name from .uproject
function M.get_project_name()
    local uproject = M.get_uproject()
    if not uproject then
        return nil
    end
    return string.gsub(uproject, "%.uproject$", "")
end

-- Quick build shortcut using new_task API
function M.build()
    local project_name = M.get_project_name()
    if not project_name then
        return
    end

    local overseer = require("overseer")
    local task = overseer.new_task({
        cmd = "make",
        args = { project_name .. "Editor-Linux-Development" },
        name = "UE Build: " .. project_name,
        components = { "on_complete_notify", "on_exit_set_status", "default" },
    })
    task:start()
    vim.cmd("OverseerOpen")
end

-- Quick clean build
function M.clean_build()
    local overseer = require("overseer")
    local task = overseer.new_task({
        cmd = "make",
        args = { "clean" },
        name = "UE Clean",
        components = { "on_complete_notify", "on_exit_set_status" },
    })
    task:start()
    vim.cmd("OverseerOpen")
end

-- Generate project files
function M.generate_files()
    local uproject = M.get_uproject()
    if not uproject then
        return
    end

    local gen_script = vim.fn.expand("$HOME/UnrealEngine/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh")
    local project_path = vim.fn.getcwd() .. "/" .. uproject

    local overseer = require("overseer")
    local task = overseer.new_task({
        cmd = gen_script,
        args = { "-project=" .. project_path, "-makefile" },
        name = "UE Generate Project Files",
        components = { "on_complete_notify", "on_exit_set_status", "default" },
    })
    task:start()
    vim.cmd("OverseerOpen")
end

-- Launch UE editor
function M.launch_editor()
    local uproject = M.get_uproject()
    if not uproject then
        return
    end

    local project_path = vim.fn.getcwd() .. "/" .. uproject
    local editor_path = vim.fn.expand("$HOME/UnrealEngine/Engine/Binaries/Linux/UnrealEditor")

    local overseer = require("overseer")
    local task = overseer.new_task({
        cmd = editor_path,
        args = { project_path },
        name = "UE Editor",
        components = { "on_complete_notify", "default" },
    })
    task:start()
    vim.notify("Launching Unreal Engine Editor...", vim.log.levels.INFO)
end

-- Generate compile_commands.json for LSP
function M.generate_compile_db()
    local project_name = M.get_project_name()
    if not project_name then
        return
    end

    local overseer = require("overseer")
    local task = overseer.new_task({
        cmd = "bash",
        args = { "-c", "bear -- make " .. project_name .. "Editor-Linux-Development" },
        name = "UE Generate compile_commands.json",
        components = { "on_complete_notify", "on_exit_set_status", "default" },
    })
    task:start()
    vim.cmd("OverseerOpen")
    vim.notify("Generating compile_commands.json for clangd...", vim.log.levels.INFO)
end

-- List all available tasks
function M.list_tasks()
    vim.cmd("OverseerToggle")
end

return M
