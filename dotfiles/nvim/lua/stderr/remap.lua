vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-m>", "<Plug>MarkdownPreviewToogle")
vim.keymap.set("n", "<C-c>", ":Commentary<CR>")
