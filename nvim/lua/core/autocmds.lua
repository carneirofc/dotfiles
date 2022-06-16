local M = {}
function M.setup()
    --- Return to last edit position when opening files (You want this!)
    vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
end
return M

