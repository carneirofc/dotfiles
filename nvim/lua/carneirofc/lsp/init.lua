local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<A-S-f>', vim.lsp.buf.format, '[A-S-f]ormat')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
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
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.jq,
        }
    })
end

local function setup_lsp_zero()
    local lsp = require('lsp-zero').preset({})

    lsp.ensure_installed({ 'clangd', 'gopls', 'pyright', 'rust_analyzer', 'tsserver', 'csharp_ls' })

    lsp.on_attach(on_attach)

    lsp.format_on_save({
        servers = {
            ['lua_ls'] = { 'lua' },
            ['rust_analyzer'] = { 'rust' },
            ['null-ls'] = { 'python', 'javascript', 'typescript', 'cpp', 'c' }
        }
    })
    -- vim.lsp.buf.format()

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
