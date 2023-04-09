local M = {}
function M.setup(on_attach, capabilities)
    local lspconfig = require('lspconfig')

    -- C++/C `clangd`.
    lspconfig.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "clangd", "--background-index", "--clang-tidy" },
        filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp", "hh" },
        single_file_support = true
    }
end
return M
