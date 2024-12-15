local M = {}
function M.setup()
    -- Setup mason so it can manage external tooling
    require('carneirofc.plugins.setup-mason').setup()

    -- Setup plugin that displays aditional information related to the LSP
    require('carneirofc.plugins.setup-fidget').setup()

    require('carneirofc.plugins.setup-galaxyline').setup()
    require('carneirofc.plugins.setup-mdformat').setup()
    require('carneirofc.plugins.setup-nvim-tree').setup()
    require('carneirofc.plugins.setup-telescope').setup()
    require('carneirofc.plugins.setup-treesitter').setup()
    require('carneirofc.plugins.setup-gitgutter').setup()
    require('carneirofc.plugins.setup-markdownpreview').setup()
    require('carneirofc.plugins.setup-dap').setup()
end

return M
