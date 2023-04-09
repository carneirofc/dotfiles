local M = {}
function M.setup()
    require('nvim-tree').setup({
        git = {
            enable = false
        }
    })
    vim.api.nvim_set_keymap('n', '<leader>n', [[:NvimTreeToggle<cr>]], { silent = true })
end
return M
