-- Leader key (optional but standard)
vim.g.mapleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.compatible = false
vim.cmd("syntax enable")
vim.cmd("filetype plugin on")

vim.opt.path:append("**")
vim.opt.wildmenu = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- UI / behavior
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.colorcolumn = "100"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

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
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate'
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
                },
                window = {
                    width = 25, -- 👈 smaller sidebar (default ~40)
                },
            })

            -- F2 toggle
            vim.keymap.set("n", "<F2>", ":Neotree toggle<CR>")
        end,
    },
})
