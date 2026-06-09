local git = require("soth.git")

local M = {}

function M.setup(runners)
    local commands = {
        DiffHeadFile = git.diff_current_file_with_previous_commit,
        HugoPreview = runners.run_hugo_preview,
        LoveDebug = runners.run_game_debug_fallback,
        LoveRun = runners.run_game,
        LuaParse = runners.parse_lua,
        ProjectRun = runners.run_project,
    }

    for name, fn in pairs(commands) do
        vim.api.nvim_create_user_command(name, fn, {})
    end
end

return M
