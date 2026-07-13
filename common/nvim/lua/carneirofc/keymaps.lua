local M = {}
function M.setup()
    -- Reselect visual selection after indenting
    vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

    -- Buffer handling
    vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<cr>', { silent = false, desc = "delete buffer" })
    vim.api.nvim_set_keymap('n', '<leader>ba', ':bufdo bd<cr>', { silent = false, desc = "delete all buffers" }) -- Close all the buffers
    vim.api.nvim_set_keymap('n', '<leader>l', ':bnext<cr>', { silent = false, desc = "next buffer" })
    vim.api.nvim_set_keymap('n', '<leader>h', ':bprevious<cr>', { silent = false, desc = "previous buffer" })

    -- Smart way to move between windows
    vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', { silent = false, desc = "move down window" })
    vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { silent = false, desc = "move up window" })
    vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { silent = false, desc = "move left window" })
    vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { silent = false, desc = "move right window" })
    vim.api.nvim_set_keymap('n', '<leader>wc', ':close<cr>', { silent = false, desc = "close window" })

    -- Useful mappings for managing tabs
    vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<cr>', { silent = false, desc = "new tab" })
    vim.api.nvim_set_keymap('n', '<leader>to', ':tabonly<cr>', { silent = false, desc = "close other tabs" })
    vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<cr>', { silent = false, desc = "close tab" })
    vim.api.nvim_set_keymap('n', '<leader>tm', ':tabmove', { silent = false, desc = "move tab" })
    vim.api.nvim_set_keymap('n', '<leader>t<leader>', ':tabnext', { silent = false, desc = "next tab" })
    vim.api.nvim_set_keymap('n', '<leader>te', [[:tabedit <C-r>=expand("%:p:h")<cr>]],
        { silent = false, desc = "new tab with current buffer's path" }) -- Opens a new tab with the current buffer's path
    vim.cmd([[
        let g:lasttab = 1
        nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
        au TabLeave * let g:lasttab = tabpagenr()
    ]]) --- Let 'tl' toggle between this and the last accessed tab

    -- Exit terminal emulator remap
    vim.api.nvim_set_keymap('t', '<leader>q', [[<C-\><C-n>]], { silent = false })

    -- Switch CWD to the directory of the open buffer
    vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>',
        { silent = false, desc = "chdir to the directory of the open buffer" })

    -- Vertical Split Current Buffer
    vim.api.nvim_set_keymap('n', '<leader>sv', ':vertical split<cr>', { silent = false, desc = "vertial split" })

    -- Horizontal Split Current Buffer
    vim.api.nvim_set_keymap('n', '<leader>sh', ':horizontal split<cr>', { silent = false, desc = "horizontal split" })
end

return M
