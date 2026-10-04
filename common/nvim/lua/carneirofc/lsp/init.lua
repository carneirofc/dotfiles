local M = {}

-- Language servers installed and enabled through mason / mason-lspconfig.
-- mason-lspconfig calls `vim.lsp.enable()` for every server it has installed
-- (automatic_enable = true), so nothing else is needed for these.
local mason_servers = { 'lua_ls', 'ruff', 'ts_ls', 'biome' }

-- Language servers expected to come from the system package manager. They are
-- only enabled when their binary is on PATH so a missing one never produces a
-- "Spawning language server ... failed" error.
local system_servers = { 'clangd', 'gopls' }

-- Formatters / linters consumed by none-ls. Installed through the mason
-- registry on first start; mason prepends its bin dir to PATH.
local mason_tools = { 'shfmt', 'goimports', 'mypy', 'prettier' }

-- Buffer-local keymaps, applied on every LspAttach.
local on_attach = function(event)
    local bufnr = event.buf

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = '[lsp] rename' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[lsp] code action' })
    vim.keymap.set('n', '<A-S-f>', function()
            require('fidget').notify("[carneirofc] vim.lsp.buf.format", vim.log.levels.INFO, nil)
            vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        end,
        { buffer = bufnr, desc = '[lsp] format buffer' })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = '[lsp] go to definition' })
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
        { buffer = bufnr, desc = '[lsp] go to reference' })
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[lsp] go to implementation' })
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
        { buffer = bufnr, desc = '[lsp] document symbols' })
    vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        { buffer = bufnr, desc = '[lsp] workspace symbols' })

    -- See `:help K` for why this keymap
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = '[lsp] hover documentation' })
    -- Signature help: Neovim ships <C-s> in insert mode (see :help lsp-defaults).
    -- <C-k> is reserved for window navigation (keymaps.lua), so the diagnostic
    -- float lives on <leader>e.
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = bufnr, desc = '[lsp] line diagnostics' })

    -- Lesser used LSP functionality
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to Declaration' })
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Workspace Add Folder' })
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
        { buffer = bufnr, desc = 'Workspace Remove Folder' })
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        { buffer = bufnr, desc = 'Workspace List Folders' })
end

local function setup_null_ls()
    require('fidget').notify("[carneirofc] setup null-ls", vim.log.levels.INFO, nil)
    local null_ls = require('null-ls')
    null_ls.setup({
        sources = {
            -- Utils
            -- null_ls.builtins.diagnostics.shellcheck.with { filetypes = { 'sh', 'bash' } },
            -- null_ls.builtins.formatting.jq,
            null_ls.builtins.formatting.shfmt.with { filetypes = { 'sh', 'bash' } },

            -- go
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.goimports,

            -- Python
            -- null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.mypy,
            -- null_ls.builtins.formatting.isort,
            -- null_ls.builtins.formatting.black,

            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.clang_format,
            null_ls.builtins.formatting.prettier,
        }
    })
end

-- Install any missing none-ls tool through the mason registry (async, no-op
-- when everything is already present).
local function ensure_mason_tools()
    local registry = require('mason-registry')
    registry.refresh(function()
        for _, name in ipairs(mason_tools) do
            local ok, pkg = pcall(registry.get_package, name)
            if ok and not pkg:is_installed() then
                require('fidget').notify("[carneirofc] mason: installing " .. name, vim.log.levels.INFO, nil)
                pkg:install()
            end
        end
    end)
end

-- Per-server overrides. Server definitions themselves come from
-- nvim-lspconfig's `lsp/` directory (see :help lspconfig-nvim-0.11).
local function configure_servers()
    -- lua_ls: lazydev injects the Neovim runtime / plugin paths into the
    -- workspace library lazily, replacing the old on_init settings hack.
    require('lazydev').setup({})

    vim.lsp.config('ts_ls', {
        on_attach = function(client)
            -- Biome owns formatting for JS/TS.
            client.server_capabilities.documentFormattingProvider = false
            require('fidget').notify("[carneirofc] ts_ls attached", vim.log.levels.INFO, nil)
        end
    })
    vim.lsp.config('biome', {
        on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
            require('fidget').notify("[carneirofc] biome attached", vim.log.levels.INFO, nil)
        end
    })
end

local function enable_servers()
    require('mason-lspconfig').setup({
        ensure_installed = mason_servers,
        automatic_enable = true,
    })

    for _, name in ipairs(system_servers) do
        local cfg = vim.lsp.config[name]
        local cmd = cfg and cfg.cmd
        if type(cmd) == 'table' and vim.fn.executable(cmd[1]) == 1 then
            vim.lsp.enable(name)
        end
    end
end

function M.setup()
    require('fidget').notify("[carneirofc] creating autocmd", vim.log.levels.INFO, nil)
    vim.api.nvim_create_autocmd('LspAttach', { desc = "lsp_on_attach", callback = on_attach })

    configure_servers()
    enable_servers()

    setup_null_ls()
    ensure_mason_tools()

    -- Setup completion engine after the LSP has been configured
    require('carneirofc.lsp.setup-cmp').setup()
end

return M
