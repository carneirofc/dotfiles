local M = {}
function M.setup()
    -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp:
    local lspkind = require('lspkind')

    -- Setup nvim-cmp, completion engine
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
        completion = {
            completeopt = "menu,menuone,noinsert",
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = {
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-d>'] = cmp.mapping.close(),
            -- Change choice nodes for luasnip
            ['<C-j>'] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<C-k>'] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<CR>'] = function(fallback)
                if cmp.visible() then
                    cmp.confirm()
                else
                    fallback()
                end
            end,
            ['<Up>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end),
            ['<Down>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' })
        },
        sources = {
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "buffer",  keyword_length = 4 },
            { name = "luasnip" }
        },
        experimental = {
            ghost_text = true
        },
        formatting = {
            format = lspkind.cmp_format({
                with_text = true, -- do not show text alongside icons
                menu = {
                    buffer = "[buff]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[nvim]",
                    path = "[path]",
                    luasnip = "[luasnip]",
                }
            })
        }
    })
end

return M
