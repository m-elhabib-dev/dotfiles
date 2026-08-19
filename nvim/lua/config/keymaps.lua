local keymap = vim.keymap.set

keymap("n", "<leader>w", "<cmd>w<cr>")
keymap("n", "<leader>q", "<cmd>q<cr>")
keymap("n", "<Esc>", "<cmd>noh<cr>")
keymap("n", "<S-l>", ":bnext<CR>", { silent = true })
keymap("n", "<S-h>", ":bprevious<CR>", { silent = true })
keymap("n", "<leader>e", vim.diagnostic.open_float)
keymap("n", "gd", vim.lsp.buf.definition, {
    desc = "Go to definition",
})
keymap("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
end, {
    desc = "Code Action",
})

keymap("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")
keymap("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")


keymap("n", "<leader>sv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
keymap("n", "<leader>sx", "<Cmd>close<CR>", { desc = "Close split" })
