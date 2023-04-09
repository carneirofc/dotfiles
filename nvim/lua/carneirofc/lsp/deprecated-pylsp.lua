local M = {}
function M.setup(on_attach, capabilities)
    local lspconfig = require('lspconfig')
    -- Python:
    -- pip install -U 
    -- python-lsp-server[all] 
    -- pyls-flake8
    -- pylsp-mypy
    -- pyls-isort
    -- python-lsp-black
    -- pylsp-rope rope
    lspconfig.pylsp.setup{
        on_attach = on_attach,
        capabilities = capabilities
    }
end
return M
