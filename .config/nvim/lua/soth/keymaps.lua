local map = require("soth.map").set

local M = {}

function M.setup(runners)
    map("n", "<F2>", ":Neotree toggle<CR>", "Toggle file tree")
    map("n", "<F5>", runners.run_project, "Run project")
    map("n", "<leader>r", runners.run_project, "Run project")
    map("n", "<leader>d", runners.run_game_debug_fallback, "Run LOVE debug fallback")
    map("n", "<leader>p", runners.parse_lua, "Parse Lua files")
    map("n", "<leader>h", ":nohlsearch<CR>", "Clear search highlight")
    map("n", "<leader>x", function()
        pcall(vim.cmd, "cclose")
        pcall(vim.cmd, "lclose")
    end, "Fechar quickfix/location list")
end

return M
