local M = {}
function M.setup()
    -- Reselect visual selection after indenting
    vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

    -- Buffer handling
    vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<cr>',   { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>ba', ':bufdo bd<cr>',  { silent = false }) -- Close all the buffers
    vim.api.nvim_set_keymap('n', '<leader>l',  ':bnext<cr>',     { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>h',  ':bprevious<cr>', { silent = false })

    -- Smart way to move between windows
    vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', { silent = false })
    vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { silent = false })
    vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { silent = false })
    vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { silent = false })

    -- Useful mappings for managing tabs
    vim.api.nvim_set_keymap('n', '<leader>tn',         ':tabnew<cr>',   { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>to',         ':tabonly<cr>',  { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>tc',         ':tabclose<cr>', { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>tm',         ':tabmove',      { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>t<leader>',  ':tabnext',      { silent = false })
    vim.api.nvim_set_keymap('n', '<leader>te',        [[:tabedit <C-r>=expand("%:p:h")<cr>]], { silent = false }) -- Opens a new tab with the current buffer's path
    vim.cmd([[
        let g:lasttab = 1
        nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
        au TabLeave * let g:lasttab = tabpagenr()
    ]]) --- Let 'tl' toggle between this and the last accessed tab

    -- Exit terminal emulator remap
    vim.api.nvim_set_keymap('t', '<leader>q', [[<C-\><C-n>]], { silent = false })

    -- Switch CWD to the directory of the open buffer
    vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', { silent = false })

    -- Vertical Split Current Buffer
    vim.api.nvim_set_keymap('n', '<leader>vs', ':vs %<cr>', { silent = false })

    -- Horizontal Split Current Buffer
    vim.api.nvim_set_keymap('n', '<leader>sv', ':sv %<cr>', { silent = false })

    --- Switch CWD to the directory of the open buffer
    vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', { silent = false })

end
return M
