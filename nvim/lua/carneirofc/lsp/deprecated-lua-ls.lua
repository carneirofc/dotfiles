local M = {}
function M.setup(on_attach, capabilities)
    -- Lua `sumneko_lua`
    local system_name
    if vim.fn.has("unix") == 1 then
        system_name = "Linux"
    elseif vim.fn.has('win32') == 1 then
        system_name = "Windows"
    else
        print("Unsupported system for sumneko")
    end

    HOME = vim.fn.expand('$HOME')

    local sumneko_root_path = ""
    local sumneko_binary = ""

    if vim.fn.has("unix") == 1 then
        sumneko_root_path = HOME .. "/.config/nvim/plugged/lua-language-server"
        sumneko_binary = HOME .. "/.config/nvim/plugged/lua-language-server/bin/lua-language-server"
    elseif vim.fn.has("win32") == 1 then
        sumneko_root_path = HOME .. "\\AppData\\Local\\nvim\\plugged\\lua-language-server"
        sumneko_binary = HOME .. "\\AppData\\Local\\nvim\\plugged\\lua-language-server\\bin\\lua-language-server.exe"
    else
        print("Unsupported system for sumneko")
    end


    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    local lspconfig = require('lspconfig')
    -- Setup lspconfig.
    lspconfig.lua_ls.setup({
        on_attach = on_attach,
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
    })
end
return M
