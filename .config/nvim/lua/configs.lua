local opt = vim.opt

vim.g.mapleader = " "

vim.env.PATH = vim.fn.expand("~/.npm-global/bin") .. ":" .. vim.env.PATH

opt.guicursor = "i:block"
opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.ignorecase = true
opt.swapfile = false
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true

