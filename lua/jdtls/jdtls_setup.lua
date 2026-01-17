local M = {}

function M.setup()
    -- print("Initializing JDTLS...")
    local jdtls = require("jdtls")
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    -- Use a standard location for workspace data
    local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

    -- Resolve paths dynamically from Mason
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local jdtls_path = mason_path .. "/packages/jdtls"
    local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    if launcher_jar == "" then
        -- vim.notify("jdtls launcher jar not found in " .. jdtls_path, vim.log.levels.ERROR)
        return
    end

    local config_path = jdtls_path .. "/config_linux"

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    -- Bundles for Debugging and Testing
    local bundles = {}
    local java_debug_path = mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
    -- java-test has multiple jars
    local java_test_path = mason_path .. "/packages/java-test/extension/server/*.jar"
    
    local debug_bundles = vim.fn.glob(java_debug_path, true)
    if debug_bundles ~= "" then
        vim.list_extend(bundles, vim.split(debug_bundles, "\n"))
    end
    
    local test_bundles = vim.fn.glob(java_test_path, true)
    if test_bundles ~= "" then
        vim.list_extend(bundles, vim.split(test_bundles, "\n"))
    end

    local config = {
        cmd = {
            "/usr/lib/jvm/java-24-openjdk/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            launcher_jar,
            "-configuration",
            config_path,
            "-data",
            workspace_dir,
        },

        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

        settings = {
            java = {
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                },
                maven = {
                    downloadSources = true,
                },
                references = {
                    includeDecompiledSources = true,
                },
                format = {
                    enabled = true,
                },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
            },
        },

        init_options = {
            bundles = bundles,
            extendedClientCapabilities = extendedClientCapabilities,
        },

        on_attach = function(client, bufnr)
            local lsp_conf = require("nvchad.configs.lspconfig")
            
            -- Check if buffer is valid to prevent race conditions with transient buffers
            if vim.api.nvim_buf_is_valid(bufnr) then
                lsp_conf.on_attach(client, bufnr)
            end

            -- Setup DAP for Java
            local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
            if status_ok then
                jdtls.setup_dap({ hotcodereplace = "auto" })
                jdtls_dap.setup_dap_main_class_configs()
                -- print("JDTLS: DAP setup successful")
            else
                -- print("JDTLS: DAP setup failed or module not found")
            end

            local opts = { noremap = true, silent = true, buffer = bufnr }
            -- Java specific keybinds starting with <leader>p
            -- print("JDTLS: Setting keybinds...")
            vim.keymap.set(
                "n",
                "<leader>po",
                jdtls.organize_imports,
                vim.tbl_extend("force", opts, { desc = "Organize Imports" })
            )
            vim.keymap.set(
                "n",
                "<leader>pev",
                jdtls.extract_variable,
                vim.tbl_extend("force", opts, { desc = "Extract Variable" })
            )
            vim.keymap.set(
                "n",
                "<leader>pec",
                jdtls.extract_constant,
                vim.tbl_extend("force", opts, { desc = "Extract Constant" })
            )
            vim.keymap.set(
                "n",
                "<leader>pem",
                jdtls.extract_method,
                vim.tbl_extend("force", opts, { desc = "Extract Method" })
            )
            vim.keymap.set("n", "<leader>pt", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test Class" }))
            vim.keymap.set(
                "n",
                "<leader>pn",
                jdtls.test_nearest_method,
                vim.tbl_extend("force", opts, { desc = "Test Nearest Method" })
            )
            -- vim.keymap.set(
            --     "n",
            --     "<leader>pd",
            --     jdtls.debug_test_nearest_method,
            --     vim.tbl_extend("force", opts, { desc = "Debug Nearest Method" })
            -- )
            print("JDTLS: Keybinds set.")
        end,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
    }

    jdtls.start_or_attach(config)
end

return M

