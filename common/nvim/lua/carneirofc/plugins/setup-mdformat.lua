local M = {}
-- Markdown format plugin integration.
-- mdformat is a python tool. mdformat python package is required.
-- Install dependencies using:
--   pip install --user -U mdformat mdformat-gfm
function M.FormatMarkdown()
    local pos = vim.fn.getpos(".")
    -- Filter the whole buffer through mdformat (stdin -> stdout).
    vim.cmd('%!mdformat -')
    vim.fn.setpos(".", pos)
end

function M.setup()
    vim.api.nvim_create_user_command('FormatMarkdown', M.FormatMarkdown,
        { desc = 'Format the current buffer with mdformat' })
end

return M
