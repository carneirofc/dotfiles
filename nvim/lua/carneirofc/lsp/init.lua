local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(event)
    local bufnr = event.buf
    -- if client.name == "omnisharp" then
    --     client.server_capabilities.semanticTokensProvider.legend = {
    --         tokenModifiers = { "static" },
    --         tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator", "operator",
    --             "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation", "string",
    --             "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter", "field",
    --             "enumMember", "constant", "local", "parameter", "method", "method", "property", "event", "namespace",
    --             "label", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml",
    --             "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "regexp", "regexp", "regexp", "regexp", "regexp",
    --             "regexp", "regexp", "regexp", "regexp" }
    --     }
    -- end

    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code Action' })
    vim.keymap.set('n', '<A-S-f>', function() vim.lsp.buf.format({ async = false, timeout_ms = 1000 }) end, { buffer = bufnr, desc = 'Format' })

    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
    vim.keymap.set('n', 'gr',         require('telescope.builtin').lsp_references, { buffer = bufnr, desc = 'Go to reference' })
    vim.keymap.set('n', 'gI',         vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation' })
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { buffer = bufnr, desc = 'Document Symbols' })
    vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = 'Workspace Symbols' })

    -- See `:help K` for why this keymap
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() vim.diagnostic.open_float() end, { buffer = bufnr, desc = 'Hover Documentation' })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

    -- Lesser used LSP functionality
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to Declaration' })
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Workspace Add Folder' })
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = 'Workspace Remove Folder' })
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders()))  end, { buffer = bufnr, desc = 'Workspace List Folders' })
end

local function setup_null_ls()
    require('fidget').notify("[carneirofc] setup null-ls", vim.log.levels.INFO, nil)
    local null_ls = require('null-ls')
    null_ls.setup({
        sources = {
            -- Utils
            null_ls.builtins.diagnostics.shellcheck.with { filetypes = { 'sh', 'bash' } },
            null_ls.builtins.formatting.jq,
            null_ls.builtins.formatting.shfmt.with { filetypes = { 'sh', 'bash' } },

            -- go
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.goimports,

            -- Python
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.mypy,
            -- null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.black,

            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.clang_format,
            null_ls.builtins.formatting.prettier,
        }
    })
end

--  local function setup_lsp_zero()
--      local lsp = require('lsp-zero').preset({})

--      lsp.ensure_installed({ 'clangd', 'gopls', 'pyright', 'tsserver', 'csharp_ls' })

--      --✓ pyright
--      --✓ rust-analyzer rust_analyzer
--      --✓ reorder-python-imports
--      --✓ mypy
--      --✓ flake8
--      --✓ quick-lint-js quick_lint_js
--      --✓ black
--      --✓ clangd
--      --✓ gopls
--      --✓ lua-language-server lua_ls
--      --✓ luaformatter
--      --✓ typescript-language-server tsserver

--      lsp.on_attach(on_attach)

--      lsp.format_on_save({
--          servers = {
--              ['lua_ls'] = { 'lua' },
--              ['rust_analyzer'] = { 'rust' },
--              ['null-ls'] = { 'python', 'javascript', 'typescript', 'cpp', 'c', 'go' }
--          },
--          format_opts = { async = false, timeout_ms = 1000 }
--      })
--      -- Configure language servers before lsp setup
--      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

--      lsp.setup()
--  end

local function setup_lua_ls()
    require('fidget').notify("[carneirofc] setup lua_ls", vim.log.levels.INFO, nil)
    require('lspconfig').lua_ls.setup({
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {}
      }
    })
end

local function setup_ruff_ls()
    require('lspconfig').ruff.setup({
      init_options = {
        settings = {
          -- Server settings should go here
        }
      }
    })
end

local function setup_biome()
    require('lspconfig').biome.setup({})
end

function M.setup()
    -- https://github.com/neovim/nvim-lspconfig
    require('fidget').notify("[carneirofc] creating autocmd", vim.log.levels.INFO, nil)
    vim.api.nvim_create_autocmd('LspAttach', { desc = "lsp_on_attach", callback = on_attach })

    setup_lua_ls()
    setup_ruff_ls()
    setup_biome()

    setup_null_ls()

    -- Setup completion engine after the LSP has been configured
    require('carneirofc.lsp.setup-cmp').setup()
end

return M
