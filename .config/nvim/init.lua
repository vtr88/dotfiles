-- ============================================================================
-- Neovim pessoal
-- ============================================================================
-- Tudo fica neste arquivo de propósito: é mais fácil abrir, ler e ajustar sem
-- pular entre módulos pequenos demais.

vim.g.mapleader = ","
vim.g.maplocalleader = ","

local root = vim.fn.getcwd()
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Instala o lazy.nvim automaticamente se ele ainda não existir.
if not vim.uv.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    })
end

vim.opt.rtp:prepend(lazy_path)

-- ============================================================================
-- Opções básicas
-- ============================================================================

local opt = vim.opt

local boolean_options = {
    "number",
    "relativenumber",
    "wildmenu",
    "expandtab",
    "smartindent",
    "autoindent",
    "showmatch",
    "incsearch",
    "hlsearch",
    "ignorecase",
    "smartcase",
    "autoread",
    "cursorline",
    "wrap",
    "linebreak",
    "termguicolors",
}

for _, name in ipairs(boolean_options) do
    opt[name] = true
end

local value_options = {
    tabstop = 4,
    shiftwidth = 4,
    background = "dark",
    clipboard = "unnamedplus",
    colorcolumn = "100",
    signcolumn = "yes",
    updatetime = 250,
    makeprg = "luac -p main.lua global.lua conf.lua src/state/*.lua src/entity/*.lua src/data/*.lua src/lib/*.lua",
    errorformat = "%f:%l: %m",
}

for name, value in pairs(value_options) do
    opt[name] = value
end

opt.compatible = false
opt.swapfile = false
opt.path:append("**")

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- ============================================================================
-- Helpers pequenos
-- ============================================================================

local function map(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc

    vim.keymap.set(mode, lhs, rhs, opts)
end

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.WARN)
end

local function has_file(...)
    for _, path in ipairs({ ... }) do
        if vim.uv.fs_stat(root .. "/" .. path) then
            return true
        end
    end

    return false
end

local function open_terminal(cmd, title)
    vim.cmd("botright 12split")
    vim.cmd("terminal " .. cmd)

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(bufnr, title .. " " .. bufnr)
    vim.cmd("startinsert")
end

-- ============================================================================
-- Runners de projeto
-- ============================================================================

local hugo_preview = {}

local function run_hugo_preview()
    if vim.fn.executable("hugo") ~= 1 then
        notify("hugo não encontrado no PATH", vim.log.levels.ERROR)
        return
    end

    if hugo_preview.job and vim.fn.jobwait({ hugo_preview.job }, 0)[1] == -1 then
        notify("Preview já está rodando em http://127.0.0.1:1313", vim.log.levels.INFO)
        return
    end

    local current_win = vim.api.nvim_get_current_win()

    vim.cmd("botright 12split")

    hugo_preview.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, hugo_preview.buf)
    vim.bo[hugo_preview.buf].bufhidden = "hide"
    vim.bo[hugo_preview.buf].filetype = "terminal"

    hugo_preview.job = vim.fn.termopen({
        "hugo",
        "server",
        "--bind",
        "127.0.0.1",
        "--port",
        "1313",
        "--buildDrafts",
        "--disableFastRender",
        "--navigateToChanged",
    })

    vim.api.nvim_set_current_win(current_win)
    notify("Preview rodando em http://127.0.0.1:1313", vim.log.levels.INFO)
end

local function run_game()
    open_terminal("love .", "LOVE run")
end

local function run_game_debug_fallback()
    open_terminal("love . debug", "LOVE debug")
end

local function run_project()
    if has_file("hugo.yaml", "hugo.yml", "config.toml") then
        run_hugo_preview()
    elseif has_file("main.lua", "conf.lua") then
        run_game()
    else
        notify("Nenhum runner conhecido para este projeto", vim.log.levels.WARN)
    end
end

local function parse_lua()
    vim.cmd("write")
    vim.cmd("make")
    vim.cmd("copen")
end

-- ============================================================================
-- Diff do arquivo atual contra o commit anterior
-- ============================================================================

local last_diff_source
local last_diff_cursor

local function current_file()
    local path = vim.api.nvim_buf_get_name(0)

    if path == "" then
        notify("Nenhum arquivo aberto para diff")
        return
    end

    return vim.fn.fnamemodify(path, ":p")
end

local function git_root(path)
    local dir = vim.fn.fnamemodify(path, ":h")
    local result = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })

    if vim.v.shell_error ~= 0 or not result[1] or result[1] == "" then
        notify("Arquivo atual não está em um repositório git")
        return
    end

    return result[1]
end

local function has_revision(repo_root, revision)
    vim.fn.systemlist({ "git", "-C", repo_root, "rev-parse", "--verify", revision })

    if vim.v.shell_error ~= 0 then
        notify("Este repositório ainda não tem " .. revision)
        return false
    end

    return true
end

local function relative_path(repo_root, path)
    local prefix = repo_root

    if prefix:sub(-1) ~= "/" then
        prefix = prefix .. "/"
    end

    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
end

local function close_diffview_file_panel()
    vim.schedule(function()
        local ok, lib = pcall(require, "diffview.lib")
        if not ok then
            return
        end

        local view = lib.get_current_view()
        if not view or not view.panel or not view.panel:is_open() then
            return
        end

        view.panel:close()

        if view.cur_layout then
            local win = view.cur_layout:get_main_win()
            if win and win.id and vim.api.nvim_win_is_valid(win.id) then
                vim.api.nvim_set_current_win(win.id)
            end
        end
    end)
end

local function restore_last_diff_source()
    if not last_diff_source or vim.fn.filereadable(last_diff_source) ~= 1 then
        return
    end

    vim.cmd("edit " .. vim.fn.fnameescape(last_diff_source))

    if last_diff_cursor then
        pcall(vim.api.nvim_win_set_cursor, 0, last_diff_cursor)
    end
end

local function diff_current_file_with_previous_commit(depth)
    depth = tonumber(depth) or vim.v.count1
    if depth < 1 then
        depth = 1
    end

    local path = current_file()
    if not path then
        return
    end

    local repo_root = git_root(path)
    local revision = "HEAD~" .. depth

    if not repo_root or not has_revision(repo_root, revision) then
        return
    end

    local file = relative_path(repo_root, path)
    local command = string.format(
        "DiffviewOpen -C%s %s..HEAD -- %s",
        vim.fn.fnameescape(repo_root),
        revision,
        vim.fn.fnameescape(file)
    )

    last_diff_source = path
    last_diff_cursor = vim.api.nvim_win_get_cursor(0)

    vim.cmd(command)
    close_diffview_file_panel()
end

local function close_diffview_and_restore_file()
    pcall(vim.cmd, "DiffviewClose")
    vim.schedule(restore_last_diff_source)
end

-- ============================================================================
-- Plugins
-- ============================================================================

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
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewFileHistory",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewToggleFiles",
        },
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
                        size = 48,
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
                    run_game_debug_fallback()
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

-- ============================================================================
-- Atalhos globais
-- ============================================================================

map("n", "<F2>", ":Neotree toggle<CR>", "Toggle file tree")
map("n", "<F5>", run_project, "Run project")
map("n", "<leader>r", run_project, "Run project")
map("n", "<leader>c", close_diffview_and_restore_file, "Close Diffview and restore file", { nowait = true })
map("n", "<leader>d", run_game_debug_fallback, "Run LOVE debug fallback")
map("n", "<leader>v", diff_current_file_with_previous_commit, "Diff file against previous commit")
for depth = 2, 99 do
    map("n", "<leader>" .. depth .. "v", function()
        diff_current_file_with_previous_commit(depth)
    end, "Diff file against " .. depth .. " previous commits")
end
map("n", "<leader>p", parse_lua, "Parse Lua files")
map("n", "<leader>h", ":nohlsearch<CR>", "Clear search highlight")
map("n", "<leader>x", function()
    pcall(vim.cmd, "cclose")
    pcall(vim.cmd, "lclose")
end, "Fechar quickfix/location list")

-- ============================================================================
-- Comandos manuais
-- ============================================================================

local commands = {
    HugoPreview = run_hugo_preview,
    LoveDebug = run_game_debug_fallback,
    LoveRun = run_game,
    LuaParse = parse_lua,
    ProjectRun = run_project,
}

for name, fn in pairs(commands) do
    vim.api.nvim_create_user_command(name, fn, {})
end

vim.api.nvim_create_user_command("DiffHeadFile", function(args)
    diff_current_file_with_previous_commit(args.args)
end, { nargs = "?" })
