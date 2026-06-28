return {
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                server = {

                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            check = {
                                command = "clippy",
                            },
                        },
                    },
                        on_attach = function(client, bufnr)
                        vim.lsp.inlay_hint.enable(true, {
                        bufnr = bufnr,
                        })
                        end,
                },
            }

            vim.keymap.set("n", "<leader>rh", function()
                vim.cmd.RustLsp("hover", "actions")
            end)

            vim.keymap.set("n", "<leader>rr", function()
                vim.cmd.RustLsp("runnables")
            end)
        end,
    },
}
