vim.g.mapleader = ","
vim.g.maplocalleader = ","

local root = vim.fn.getcwd()

require("soth.lazy")
require("soth.options")

local runners = require("soth.runners").setup(root)

require("soth.plugins").setup(root, runners)
require("soth.keymaps").setup(runners)
require("soth.commands").setup(runners)
