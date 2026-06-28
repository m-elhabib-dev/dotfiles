return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    telescope = true,
                    mason = true,
                    lsp_trouble = true,
                    which_key = true,
                },
            })

            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
