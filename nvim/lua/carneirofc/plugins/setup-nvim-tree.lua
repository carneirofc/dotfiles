local M = {}
function M.setup()
    local status, nvim_tree = pcall(require, 'nvim-tree')
    if not status then
        return
    end

    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvim_tree.setup({
        git = {
            enable = false
        }
    })
    vim.api.nvim_set_keymap('n', '<leader>n', [[:NvimTreeToggle<cr>]], { silent = true })
end

return M
