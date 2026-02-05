-- Overseer task templates for Unreal Engine on Linux

return {
    {
        name = "UE_Build",
        desc = "Build Unreal Engine project",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found in current directory", vim.log.levels.ERROR)
                return nil
            end

            local project_name = string.gsub(uproject, "%.uproject$", "")

            return {
                cmd = "make",
                args = { project_name .. "Editor-Linux-Development" },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
                metadata = {
                    desc = "Build " .. project_name .. " editor",
                },
            }
        end,
        tags = { "unreal", "build" },
    },

    {
        name = "UE_Clean",
        desc = "Clean project build artifacts only",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            return {
                cmd = "bash",
                args = {
                    "-c",
                    "rm -rf Binaries Intermediate && echo 'Cleaned Binaries/ and Intermediate/ directories'",
                },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
            }
        end,
        tags = { "unreal", "build" },
    },

    {
        name = "UE_GenerateProjectFiles",
        desc = "Regenerate Unreal Engine project files",
        builder = function()
            local gen_script = vim.fn.expand("$HOME/UnrealEngine/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh")
            local uproject = vim.fn.glob("*.uproject")

            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            local project_path = vim.fn.getcwd() .. "/" .. uproject

            return {
                cmd = gen_script,
                args = { "-project=" .. project_path, "-makefile" },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
            }
        end,
        tags = { "unreal", "project" },
    },

    {
        name = "UE_Editor",
        desc = "Launch Unreal Engine Editor",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            local project_path = vim.fn.getcwd() .. "/" .. uproject
            local editor_path = vim.fn.expand("$HOME/UnrealEngine/Engine/Binaries/Linux/UnrealEditor")

            return {
                cmd = editor_path,
                args = { project_path },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "default" },
            }
        end,
        tags = { "unreal", "editor" },
    },

    {
        name = "UE_CompileDB",
        desc = "Filter compile_commands.json to project only (fast!)",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            local project_name = string.gsub(uproject, "%.uproject$", "")
            local project_path = vim.fn.getcwd()
            local engine_db = vim.fn.expand("$HOME/UnrealEngine/compile_commands.json")

            return {
                cmd = "bash",
                args = {
                    "-c",
                    "python3 << 'PYEOF'\nimport json\nwith open('" .. engine_db .. "') as f:\n    data = json.load(f)\nproject_files = [e for e in data if '" .. project_path .. "' in e.get('file', '')]\nwith open('compile_commands.json', 'w') as f:\n    json.dump(project_files, f, indent=2)\nprint(f'Filtered to {len(project_files)} " .. project_name .. " files (from {len(data)} total)')\nPYEOF",
                },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
            }
        end,
        tags = { "unreal", "lsp" },
    },

    {
        name = "UE_BuildAndLaunch",
        desc = "Build editor and launch",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            local project_name = string.gsub(uproject, "%.uproject$", "")
            local project_path = vim.fn.getcwd() .. "/" .. uproject
            local editor_path = vim.fn.expand("$HOME/UnrealEngine/Engine/Binaries/Linux/UnrealEditor")

            return {
                cmd = "bash",
                args = {
                    "-c",
                    "make " .. project_name .. "Editor-Linux-Development && " .. editor_path .. " " .. project_path,
                },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
            }
        end,
        tags = { "unreal", "editor", "build" },
    },

    {
        name = "UE_Rebuild",
        desc = "Clean and rebuild project",
        builder = function()
            local uproject = vim.fn.glob("*.uproject")
            if uproject == "" then
                vim.notify("No .uproject file found", vim.log.levels.ERROR)
                return nil
            end

            local project_name = string.gsub(uproject, "%.uproject$", "")

            return {
                cmd = "bash",
                args = {
                    "-c",
                    "rm -rf Binaries Intermediate && make " .. project_name .. "Editor-Linux-Development",
                },
                cwd = vim.fn.getcwd(),
                components = { "on_complete_notify", "on_exit_set_status", "default" },
            }
        end,
        tags = { "unreal", "build" },
    },
}
