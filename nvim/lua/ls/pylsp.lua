-- [[
--  pip install -U \
--      python-lsp-server[all] \
--      pyls-flake8 \
--      pylsp-mypy \
--      pyls-isort \
--      python-lsp-black \
--      pylsp-rope \
--      rope
-- ]]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require'lspconfig'.pylsp.setup{
    capabilities = capabilities
}
