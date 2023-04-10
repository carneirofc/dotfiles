local M = {}

function M.setup()
    local telescope = require("telescope")

    local default = {
        defaults = {
            initial_mode = "insert",
            set_env = { ["COLORTERM"] = "truecolor" },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden"
            }
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            }
        }
    }

    -- You dont need to set any of these options. These are the default ones. Only
    -- the loading is important
    telescope.setup(default)

    local extensions = { "fzf" }

    pcall(function()
        for _, ext in ipairs(extensions) do
            telescope.load_extension(ext)
        end
    end)

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ hidden = true }) end, { desc = "[f]ind [f]iles" })
    vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({ follow = true }) end, { desc = "[f]ind [g]rep" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "[f]ind [b]uffers" })
    vim.keymap.set('n', '<leader>fG', builtin.git_files, { desc = "[f]ind [G]it" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "[f]ind [h]elp" })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "[f]ind [d]diagnostics" })
end

return M
