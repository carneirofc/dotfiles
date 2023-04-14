local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
    nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    nmap('<A-S-f>',
        function()
            vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        end, 'Format')

    nmap('gd', vim.lsp.buf.definition, 'Go to definition')
    nmap('gr', require('telescope.builtin').lsp_references, 'Go to reference')
    nmap('gI', vim.lsp.buf.implementation, 'Go to implementation')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, 'Go to Declaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
    nmap('<leader>wl',
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'Workspace List Folders')
end

local function setup_null_ls()
    local null_ls = require('null-ls')
    null_ls.setup({
        sources = {
            -- Replace these with the tools you have installed
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.mypy,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.clang_format,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.jq,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.shellcheck.with {
                filetypes = { 'sh', 'bash' },
            },
            null_ls.builtins.formatting.shfmt.with {
                filetypes = { 'sh', 'bash' },
            },
        }
    })
end

local function setup_lsp_zero()
    local lsp = require('lsp-zero').preset({})

    lsp.ensure_installed({ 'clangd', 'gopls', 'pyright', 'tsserver', 'csharp_ls' })

    lsp.on_attach(on_attach)

    lsp.format_on_save({
        servers = {
            ['lua_ls'] = { 'lua' },
            ['rust_analyzer'] = { 'rust' },
            ['null-ls'] = { 'python', 'javascript', 'typescript', 'cpp', 'c' }
        },
        format_opts = { async = false, timeout_ms = 1000 }
    })
    -- Configure language servers before lsp setup
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()
end

function M.setup()
    -- Setup plugin that displays aditional information related to the LSP
    require('carneirofc.plugins.setup-fidget').setup()

    -- Setup mason so it can manage external tooling
    require('carneirofc.plugins.setup-mason').setup()

    setup_lsp_zero()

    setup_null_ls()

    -- Setup completion engine after the LSP has been configured
    require('carneirofc.plugins.setup-cmp').setup()
end

return M
