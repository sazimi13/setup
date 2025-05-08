return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Set up Python language server (Pyright)
      require("lspconfig").pyright.setup({
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = require("lspconfig.util").root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          ".git"
        ),
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic"
            }
          }
        }
      })
      
      -- You can also set up Jedi as an alternative Python language server
      -- Jedi often has better goto definition capabilities for standard library
      require("lspconfig").jedi_language_server.setup({
        filetypes = { "python" },
        root_dir = require("lspconfig.util").root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          ".git"
        )
      })
      
      -- Key mappings for LSP functionality (same as cpp.lua)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
    end,
  },
  
  -- Mason for installing Python language servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { 
        "pyright", 
        "jedi_language_server",
        "black",     -- Python formatter
        "ruff"       -- Python linter
      }
    },
  },
  
  -- Basic autocompletion (same as cpp.lua)
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
