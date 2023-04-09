local M = {}
function M.setup()
    vim.g.clang_format_path = "clang-format"
    vim.g.clang_format_fallback_style = "llvm"
    function Format()
        vim.cmd([[
            py3f ~/.config/nvim/scripts/clang-format.py
        ]])
    end
    vim.fn.ClangFormat = Format
    vim.api.nvim_create_augroup("ClangFormat", {clear = true})
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = Format,
        pattern = { "*.hh", "*.hpp", "*.h", "*.cc", "*.cpp"}
    })

    vim.api.nvim_set_keymap('n', '<leader>k', ':call ClangFormat()', { noremap = true, silent = true })
end
return M
