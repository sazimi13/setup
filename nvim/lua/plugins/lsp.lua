return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Debug setup
      -- Add this to see LSP logs for troubleshooting
      vim.lsp.set_log_level("debug")
      
      -- Set up common keymaps for all language servers
      local on_attach = function(client, bufnr)
        -- Keymaps for navigating to definitions, references, etc.
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        
        -- Print info about client capabilities for debugging
        print("LSP client attached: " .. client.name)
      end

      -- Ensure Mason is set up
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",            -- C/C++
          "pyright",           -- Python
          "jedi_language_server" -- Alternative Python server
        },
        automatic_installation = true,
      })

      -- Set up C++ language server
      require("lspconfig").clangd.setup({
        on_attach = on_attach,
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
          fallbackFlags = { "-std=c++17" }
        }
      })
      
      -- Set up Python language server (Pyright) with enhanced settings
      require("lspconfig").pyright.setup({
        on_attach = on_attach,
        filetypes = { "python" },
        root_dir = require("lspconfig.util").root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          ".git",
          -- Add any other project markers you might use
          "pyrightconfig.json"
        ),
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
              stubPath = vim.fn.stdpath("data") .. "/stubs",
              extraPaths = {},  -- Add custom paths if needed
              diagnosticSeverityOverrides = {
                reportMissingImports = "none",  -- Suppress import errors
                reportMissingModuleSource = "none"
              }
            }
          }
        },
        -- Explicitly set capabilities
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        flags = {
          debounce_text_changes = 150,
        }
      })
      
      -- Set up alternative Python language server (Jedi) with optimized settings
      require("lspconfig").jedi_language_server.setup({
        on_attach = on_attach,
        filetypes = { "python" },
        init_options = {
          diagnostics = {
            enable = true,
          },
          completion = {
            disableSnippets = false,
          },
          -- This disables auto-import optimization to ensure goto definition works properly
          jediSettings = {
            autoImportModules = {},  -- Empty this to enable goto definition
            caseInsensitiveCompletion = true
          }
        },
        capabilities = vim.lsp.protocol.make_client_capabilities()
      })
    end,
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
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'buffer', priority = 500 },
        }
      })
    end,
  }
}
