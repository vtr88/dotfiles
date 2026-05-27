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
