local M = {}

local last_diff_source
local last_diff_cursor

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.WARN)
end

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
        notify("Arquivo atual nao esta em um repositorio git")
        return
    end

    return result[1]
end

local function has_revision(root, revision)
    vim.fn.systemlist({ "git", "-C", root, "rev-parse", "--verify", revision })

    if vim.v.shell_error ~= 0 then
        notify("Este repositorio ainda nao tem " .. revision)
        return false
    end

    return true
end

local function relative_path(root, path)
    local prefix = root

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

local function restore_last_source()
    if not last_diff_source or vim.fn.filereadable(last_diff_source) ~= 1 then
        return
    end

    vim.cmd("edit " .. vim.fn.fnameescape(last_diff_source))

    if last_diff_cursor then
        pcall(vim.api.nvim_win_set_cursor, 0, last_diff_cursor)
    end
end

function M.diff_current_file_with_previous_commit()
    local path = current_file()
    if not path then
        return
    end

    local root = git_root(path)
    if not root or not has_revision(root, "HEAD~1") then
        return
    end

    local file = relative_path(root, path)
    local command = string.format(
        "DiffviewOpen -C%s HEAD~1..HEAD -- %s",
        vim.fn.fnameescape(root),
        vim.fn.fnameescape(file)
    )

    last_diff_source = path
    last_diff_cursor = vim.api.nvim_win_get_cursor(0)

    vim.cmd(command)
    close_diffview_file_panel()
end

function M.close_diffview_and_restore_file()
    pcall(vim.cmd, "DiffviewClose")
    vim.schedule(restore_last_source)
end

return M
