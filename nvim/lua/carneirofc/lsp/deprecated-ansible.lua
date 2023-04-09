local M = {}
function M.setup(on_attach, capabilities)
    local lspconfig = require('lspconfig')
    -- Ansible:  npm i -g ansible-language-server
    lspconfig.ansiblels.setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end
return M
