vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname: append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

vim.cmd [[command! W :w]]
vim.cmd [[command! Q :q]]
vim.cmd [[command! WQ :wq]]
vim.cmd [[command! Wq :wq]]
