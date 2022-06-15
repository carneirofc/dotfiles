local M = {}

-- pip install --user -U mdformat mdformat-gfm
function M.FormatMarkdown()
    local pos = vim.fn.getpos(".")
    vim.cmd('!mdformat -')
    vim.fn.setpos(".", pos)
end

function M.setup()
    vim.cmd([[ command FormatMarkdown lua require('plugins.mdformat').FormatMarkdown() ]])
end

return M
