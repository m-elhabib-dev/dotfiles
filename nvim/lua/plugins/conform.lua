return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    rust = { "rustfmt" },
                    lua = { "stylua" },
                },

                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>cf", function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end, {
                desc = "Format file",
            })
        end,
    },
}
