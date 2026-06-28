return {
--          {
--          "nvim-treesitter/nvim-treesitter",
--          branch = "main",
--          build = ":TSUpdate",
--          config = function()
--              require("nvim-treesitter.configs").setup({
--                  ensure_installed = {
--                      "rust",
--                      "lua",
--                      "bash",
--                      "toml",
--                      "json",
--                  },
--                  highlight = {
--                      enable = true,
--                  },
--              })
--          end,
--      },


    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup()
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    },
}
