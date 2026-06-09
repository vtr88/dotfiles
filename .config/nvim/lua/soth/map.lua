local M = {}

function M.set(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc

    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
