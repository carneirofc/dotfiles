-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
HOME = vim.fn.expand('$HOME')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("unix") == 1 then
    sumneko_root_path = HOME .. "/.config/nvim/plugged/lua-language-server"
    sumneko_binary = HOME .. "/.config/nvim/plugged/lua-language-server/bin/Linux/lua-language-server"
else
    print("Unsupported system for sumneko")
end


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.sumneko_lua.setup {
    capabilities = capabilities,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
        }
    }
}
