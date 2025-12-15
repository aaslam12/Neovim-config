local dapui = require("dapui")
local dap = require("dap")

dapui.setup({
    elements = {
        -- elements will be created in order.
        -- the order of the key/value pairs is not guaranteed.
        scopes = {},
        breakpoints = {},
        stacks = {},
        watches = {},
        repl = {},
        expressions = {},
        -- You can specify your own layout.
        -- For example, with a two-column layout:
        -- layouts = {
        --     {
        --         elements = {
        --             { id = "scopes", size = 0.3 },
        --             { id = "breakpoints", size = 0.3 },
        --             { id = "stacks", size = 0.4 },
        --         },
        --         size = 0.4,
        --         position = "left",
        --     },
        --     {
        --         elements = {
        --             { id = "watches", size = 0.5 },
        --             { id = "repl", size = 0.5 },
        --         },
        --         size = 0.6,
        --         position = "bottom",
        --     },
        -- },
    },
    -- controls = {
    --   element_closed = "⊞",
    --   element_opened = "⊟",
    --   opened = "",
    --   closed = "",
    --   collapsed = "",
    --   expanded = "Down",
    -- },
    -- custom_layouts = {
    --   {
    --     size = 80,
    --     elements = {
    --       {
    --         size = 0.25,
    --         elements = {
    --           {
    --             size = 0.5,
    --             elements = {
    --               "scopes",
    --               "watches",
    --             },
    --           },
    --           {
    --             size = 0.5,
    --             elements = {
    --               "breakpoints",
    --               "stacks",
    --             },
    --           },
    --         },
    --       },
    --       {
    --         size = 0.75,
    --         elements = {
    --           "repl",
    --           "expressions",
    --         },
    --       },
    --     },
    --   },
    -- },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
