local M = {}
function M.setup()
    vim.g.airline_theme = 'deus'
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_detect_modified = 1
    vim.g.airline_detect_paste = 1
    vim.g.airline_detect_crypt = 1
    vim.g.airline_detect_spell = 1
    --- vim.g.airline_skip_empty_sections = 1 " Consider adding this back if tmux requires
    vim.g.airline.extensions.tabline.enabled = 1
    vim.g.airline.extensions.tabline.left_sep = ' '
    vim.g.airline.extensions.tabline.left_alt_sep = ' '
    vim.opt.showmode = false
end
return M
