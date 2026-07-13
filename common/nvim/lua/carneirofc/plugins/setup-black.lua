local M = {}
function M.setup()
    vim.cmd([[autocmd BufWritePre *.py execute ':Black']])
end
return M
