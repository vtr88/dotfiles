local M = {}

function M.setup(root)
    local hugo_preview = {}

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

    local function run_hugo_preview()
        if vim.fn.executable("hugo") ~= 1 then
            vim.notify("hugo nao encontrado no PATH", vim.log.levels.ERROR)
            return
        end

        if hugo_preview.job and vim.fn.jobwait({ hugo_preview.job }, 0)[1] == -1 then
            vim.notify("Preview ja esta rodando em http://127.0.0.1:1313", vim.log.levels.INFO)
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
        vim.notify("Preview rodando em http://127.0.0.1:1313", vim.log.levels.INFO)
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
            vim.notify("Nenhum runner conhecido para este projeto", vim.log.levels.WARN)
        end
    end

    local function parse_lua()
        vim.cmd("write")
        vim.cmd("make")
        vim.cmd("copen")
    end

    return {
        parse_lua = parse_lua,
        run_game = run_game,
        run_game_debug_fallback = run_game_debug_fallback,
        run_hugo_preview = run_hugo_preview,
        run_project = run_project,
    }
end

return M
