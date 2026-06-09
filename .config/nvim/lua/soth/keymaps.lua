local map = require("soth.map").set
local git = require("soth.git")

local M = {}

function M.setup(runners)
    map("n", "<F2>", ":Neotree toggle<CR>", "Toggle file tree")
    map("n", "<F5>", runners.run_project, "Run project")
    map("n", "<leader>r", runners.run_project, "Run project")
    map("n", "<leader>c", git.close_diffview_and_restore_file, "Close Diffview and restore file", { nowait = true })
    map("n", "<leader>d", runners.run_game_debug_fallback, "Run LOVE debug fallback")
    map("n", "<leader>v", git.diff_current_file_with_previous_commit, "Diff file against previous commit")
    map("n", "<leader>p", runners.parse_lua, "Parse Lua files")
    map("n", "<leader>h", ":nohlsearch<CR>", "Clear search highlight")
    map("n", "<leader>x", function()
        pcall(vim.cmd, "cclose")
        pcall(vim.cmd, "lclose")
    end, "Fechar quickfix/location list")
end

return M
