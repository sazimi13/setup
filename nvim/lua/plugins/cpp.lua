return {
    {
      "neovim/nvim-lspconfig",
      config = function()
        -- Set up C++ language server
        require("lspconfig").clangd.setup({
        cmd = { 
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          root_dir = require("lspconfig.util").root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".git"
          ),
          init_options = {
            compilationDatabasePath = "build",
            fallbackFlags = { "-std=c++17" }  -- Adjust to your C++ standard
          }
        })
      end,
    },
    -- Mason for installing LSP servers
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = { "clangd" }
      },
    },
    -- Basic autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
          }
        })
      end,
    }
}
