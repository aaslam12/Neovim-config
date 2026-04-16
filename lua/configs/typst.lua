require("typst-preview").setup({
    debug = false,
    open_cmd = nil,
    port = 0,
    host = "127.0.0.1",

    -- Setting this to 'always' will invert black and white in the preview
    -- Setting this to 'auto' will invert depending if the browser has enable
    -- dark mode
    -- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
    -- your choice of color inversion to images and everything else
    -- separately.
    invert_colors = "never",

    -- Whether the preview will follow the cursor in the source file
    follow_cursor = true,

    -- This function will be called to determine the root of the typst project
    get_root = function(path_of_main_file)
        local root = os.getenv("TYPST_ROOT")
        if root then
            return root
        end

        -- Look for a project marker so imports from parent dirs stay inside root
        local main_dir = vim.fs.dirname(vim.fn.fnamemodify(path_of_main_file, ":p"))
        local found = vim.fs.find({ "typst.toml", ".git" }, { path = main_dir, upward = true })
        if #found > 0 then
            return vim.fs.dirname(found[1])
        end

        return main_dir
    end,

    -- This function will be called to determine the main file of the typst
    -- project.
    get_main_file = function(path_of_buffer)
        return path_of_buffer
    end,
})
