local map = require("soth.map").set

local M = {}

function M.setup(root, runners)
    require("lazy").setup({
        "koryschneider/vim-trim",

        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("gruvbox")
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                local ok, configs = pcall(require, "nvim-treesitter.configs")
                if not ok then
                    return
                end

                configs.setup({
                    ensure_installed = {
                        "lua",
                        "vim",
                        "vimdoc",
                        "json",
                        "yaml",
                        "markdown",
                        "markdown_inline",
                        "html",
                        "css",
                        "scss",
                        "javascript",
                    },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },

        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("neo-tree").setup({
                    filesystem = {
                        follow_current_file = { enabled = true },
                        filtered_items = {
                            visible = true,
                            hide_dotfiles = false,
                            hide_gitignored = false,
                        },
                    },
                    window = { width = 28 },
                })
            end,
        },

        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local builtin = require("telescope.builtin")

                require("telescope").setup({
                    defaults = {
                        layout_strategy = "horizontal",
                        layout_config = {
                            prompt_position = "top",
                            width = 0.90,
                            height = 0.85,
                        },
                        sorting_strategy = "ascending",
                        file_ignore_patterns = { "%.git/" },
                    },
                    pickers = {
                        find_files = { hidden = true },
                    },
                })

                map("n", "<leader>f", builtin.find_files, "Buscar arquivo")
                map("n", "<leader>g", builtin.live_grep, "Buscar texto")
                map("n", "<leader>b", builtin.buffers, "Buscar buffer")
                map("n", "<leader>k", builtin.keymaps, "Buscar atalhos")
            end,
        },

        {
            "neovim/nvim-lspconfig",
            config = function()
                vim.lsp.config("lua_ls", {
                    cmd = { "lua-language-server" },
                    capabilities = vim.lsp.protocol.make_client_capabilities(),
                    root_markers = { ".git", "main.lua" },
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                                path = {
                                    "?.lua",
                                    "?/init.lua",
                                    "src/?.lua",
                                    "src/?/init.lua",
                                },
                            },
                            diagnostics = {
                                globals = { "love", "arg" },
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = { vim.env.VIMRUNTIME, root },
                            },
                            telemetry = { enable = false },
                        },
                    },
                })

                vim.lsp.enable("lua_ls")

                map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                map("n", "gr", vim.lsp.buf.references, "References")
                map("n", "K", vim.lsp.buf.hover, "Hover")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")
            end,
        },

        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "nvim-neotest/nvim-nio",
            },
            config = function()
                local dap = require("dap")
                local dapui = require("dapui")

                dapui.setup({
                    layouts = {
                        {
                            position = "left",
                            size = 58,
                            elements = {
                                { id = "repl", size = 1.0 },
                            },
                        },
                    },
                    controls = { enabled = false },
                })

                local function repl_win()
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local name = vim.api.nvim_buf_get_name(buf)

                        if vim.bo[buf].filetype == "dap-repl" or name:match("DAP REPL") then
                            return win
                        end
                    end
                end

                local function focus_repl()
                    dapui.open()

                    local win = repl_win()
                    if win then
                        vim.api.nvim_set_current_win(win)
                        vim.cmd("startinsert")
                    end
                end

                local function close_debug()
                    dapui.close()

                    local win = repl_win()
                    if win then
                        pcall(vim.api.nvim_win_close, win, true)
                    end
                end

                local function delete_debug_buffers()
                    pcall(dap.repl.close)

                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        local name = vim.api.nvim_buf_get_name(buf)

                        if name:match("%[dap%-repl") or vim.bo[buf].filetype == "dap-repl" then
                            pcall(vim.api.nvim_buf_delete, buf, { force = true })
                        end
                    end
                end

                local adapter_path
                local extension_path
                local adapter_candidates = {
                    vim.fn.expand("~/.config/.vscode-insiders/extensions/tomblind.local-lua-debugger-vscode-0.3.3"),
                    vim.fn.expand("~/.vscode/extensions/tomblind.local-lua-debugger-vscode-0.3.3"),
                    vim.fn.expand("~/.config/Code/User/globalStorage/tomblind.local-lua-debugger-vscode"),
                }

                for _, dir in ipairs(adapter_candidates) do
                    local path = dir .. "/extension/debugAdapter.js"
                    if vim.uv.fs_stat(path) then
                        adapter_path = path
                        extension_path = dir
                        break
                    end
                end

                if adapter_path then
                    dap.adapters["lua-local"] = {
                        type = "executable",
                        command = "node",
                        args = { adapter_path },
                    }

                    dap.configurations.lua = {
                        {
                            name = "Debug LOVE",
                            type = "lua-local",
                            request = "launch",
                            extensionPath = extension_path,
                            cwd = root,
                            program = { command = "love" },
                            args = { ".", "debug" },
                            scriptRoots = { root },
                            scriptFiles = { root .. "/**/*.lua" },
                            stopOnEntry = false,
                        },
                    }
                end

                dap.listeners.after.event_initialized["dapui_config"] = dapui.open
                dap.listeners.before.event_terminated["dapui_config"] = close_debug
                dap.listeners.before.event_exited["dapui_config"] = close_debug

                map("n", "<F4>", function()
                    dap.terminate()
                    close_debug()
                    delete_debug_buffers()
                end, "Terminate debug session")

                map("n", "<F6>", function()
                    if adapter_path then
                        dap.terminate()
                        close_debug()
                        delete_debug_buffers()
                        dap.run(dap.configurations.lua[1])
                    else
                        runners.run_game_debug_fallback()
                    end
                end, "Debug LOVE")

                local debug_maps = {
                    ["<F8>"] = focus_repl,
                    ["<F9>"] = dap.toggle_breakpoint,
                    ["<F10>"] = dap.step_over,
                    ["<F11>"] = dap.step_into,
                    ["<F12>"] = dap.step_out,
                    ["<leader>dc"] = dap.continue,
                    ["<leader>dr"] = focus_repl,
                    ["<leader>du"] = dapui.toggle,
                }

                for lhs, rhs in pairs(debug_maps) do
                    map("n", lhs, rhs, "Debug")
                end
            end,
        },
    })
end

return M
