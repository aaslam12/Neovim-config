-- Generic, project-agnostic Live Coding trigger for Unreal Engine.
-- NOTE: Live Coding on Linux has limited support. This triggers a hot-reload build
-- that recompiles changed code. Full live code reloading while the editor runs
-- is primarily a Windows/Mac feature. On Linux, you may need to restart the editor.
local M = {}

-- REQUIRED: Your Unreal Engine installation path.
M.engine_path = os.getenv("HOME") .. "/UnrealEngine"

-- Finds the .uproject file by searching upwards from the current buffer's directory.
-- Returns the project name and the full path to the .uproject file.
local function find_unreal_project()
    -- First try current working directory
    local cwd = vim.fn.getcwd()
    local uproject_files = vim.fn.glob(cwd .. "/*.uproject", false, true)
    if not vim.tbl_isempty(uproject_files) then
        local uproject_path = uproject_files[1]
        local project_name = vim.fn.fnamemodify(uproject_path, ":t:r")
        return project_name, uproject_path
    end

    -- Then try from current buffer's directory
    local current_file_path = vim.api.nvim_buf_get_name(0)
    if current_file_path == "" or current_file_path:match("^term://") then
        return nil, nil
    end

    local current_dir = vim.fn.fnamemodify(current_file_path, ":h")
    local root_dir_check = vim.fn.fnamemodify(current_dir, ":h")

    while current_dir ~= "/" and current_dir ~= root_dir_check do
        local files = vim.fn.glob(current_dir .. "/*.uproject", false, true)
        if not vim.tbl_isempty(files) then
            local uproject_path = files[1]
            local project_name = vim.fn.fnamemodify(uproject_path, ":t:r")
            return project_name, uproject_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
        root_dir_check = vim.fn.fnamemodify(current_dir, ":h")
    end

    return nil, nil
end

-- Detect if UnrealEditor is running
local function is_editor_running()
    local handle = io.popen("pgrep -f 'UnrealEditor' | wc -l")
    local result = handle:read("*a")
    handle:close()
    return tonumber(result) > 0
end

-- Trigger hot reload in the running Unreal Editor
function M.trigger_hot_reload()
    if not is_editor_running() then
        vim.notify("Error: Unreal Editor is not running.", vim.log.levels.ERROR)
        return
    end

    vim.notify("🔄 Hot reload initiated. Complete these steps in UE5:", vim.log.levels.WARN)
    vim.notify("  1. Go to: Tools → Compile → Recompile [Project] Module", vim.log.levels.INFO)
    vim.notify("  2. Or press: Ctrl+Shift+R", vim.log.levels.INFO)
    vim.notify("  3. If that doesn't work, close editor and use <leader>uo to reopen", vim.log.levels.INFO)
end

-- Triggers the Live Coding build.
function M.trigger_live_coding_build()
    local project_name, uproject_path = find_unreal_project()

    if not project_name then
        vim.notify("Error: Could not find a .uproject file.", vim.log.levels.ERROR)
        return
    end

    if not M.engine_path or M.engine_path == "" then
        vim.notify("Error: Unreal Engine path (M.engine_path) is not configured.", vim.log.levels.ERROR)
        return
    end

    local build_script = M.engine_path .. "/Engine/Build/BatchFiles/Linux/Build.sh"

    if vim.fn.filereadable(build_script) == 0 then
        vim.notify(
            "Error: Build.sh not found at: " .. build_script .. ". Check M.engine_path.",
            vim.log.levels.ERROR
        )
        return
    end

    local args = {
        project_name .. "Editor",
        "Linux",
        "Development",
        "-Project=" .. uproject_path,
        "-LiveCoding",
    }

    vim.notify("🔨 Building with Live Coding: " .. project_name, vim.log.levels.INFO)

    vim.fn.jobstart({ build_script, unpack(args) }, {
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" and not line:match("^%s*$") then
                        vim.schedule(function()
                            vim.notify(line, vim.log.levels.INFO)
                        end)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" and not line:match("^%s*$") then
                        vim.schedule(function()
                            vim.notify(line, vim.log.levels.WARN)
                        end)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                if code == 0 then
                    vim.notify("✓ Live Coding build succeeded.", vim.log.levels.INFO)
                else
                    vim.notify("✗ Live Coding build failed. (Exit code: " .. code .. ")", vim.log.levels.ERROR)
                end
            end)
        end,
    })
end

-- Triggers Live Coding build followed by hot reload
function M.trigger_live_coding_with_reload()
    local project_name, uproject_path = find_unreal_project()

    if not project_name then
        vim.notify("Error: Could not find a .uproject file.", vim.log.levels.ERROR)
        return
    end

    if not M.engine_path or M.engine_path == "" then
        vim.notify("Error: Unreal Engine path (M.engine_path) is not configured.", vim.log.levels.ERROR)
        return
    end

    local build_script = M.engine_path .. "/Engine/Build/BatchFiles/Linux/Build.sh"

    if vim.fn.filereadable(build_script) == 0 then
        vim.notify(
            "Error: Build.sh not found at: " .. build_script .. ". Check M.engine_path.",
            vim.log.levels.ERROR
        )
        return
    end

    local args = {
        project_name .. "Editor",
        "Linux",
        "Development",
        "-Project=" .. uproject_path,
        "-LiveCoding",
    }

    vim.notify("🔨 Building + Hot Reload: " .. project_name, vim.log.levels.INFO)

    vim.fn.jobstart({ build_script, unpack(args) }, {
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" and not line:match("^%s*$") then
                        vim.schedule(function()
                            if line:match("Result: Succeeded") then
                                -- Will trigger reload after exit
                            end
                        end)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                if code == 0 then
                    vim.notify("✓ Build succeeded!", vim.log.levels.INFO)
                    vim.notify("⚠️  On Linux, you must manually reload:", vim.log.levels.WARN)
                    vim.notify("  • In UE5: Tools → Compile → Recompile [Project] Module", vim.log.levels.INFO)
                    vim.notify("  • Or press: Ctrl+Shift+R in the editor", vim.log.levels.INFO)
                    -- Slight pause before hot reload instructions
                    vim.defer_fn(function()
                        M.trigger_hot_reload()
                    end, 1000)
                else
                    vim.notify("✗ Build failed. (Exit code: " .. code .. ")", vim.log.levels.ERROR)
                end
            end)
        end,
    })
end

return M
