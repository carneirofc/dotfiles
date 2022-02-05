-- This tiny plugin adds vscode-like pictograms to neovim built-in lsp:
local lspkind = require('lspkind')

-- Setup nvim-cmp, completion engine
local cmp = require('cmp')

local defaults = {
  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  snippet = {
    expand = function(args)
       require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<C-b>']       = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>']       = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>']   = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>']       = cmp.config.disable,
    ['<C-e>']       = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>']   = cmp.mapping.confirm({ select = true }),
    ['<CR>']    = cmp.mapping.confirm({ select = true }),
  },
  sources = {
      { name = "nvim_lua" },

      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" , keyword_length = 4 },
      { name = "luasnip" }
   },

   experimental = {
      native_menu = false,
      ghost_text = true
   },

   formatting = {
     format = lspkind.cmp_format({
       with_text = false, -- do not show text alongside icons
       menu = {
           buffer = "[buff]",
           nvim_lsp = "[LSP]",
           nvim_lua = "[nvim]",
           path = "[path]",
           luasnip = "[luasnip]",
       }
     })
   }

}

cmp.setup(defaults)

