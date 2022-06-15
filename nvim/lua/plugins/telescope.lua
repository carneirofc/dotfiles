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
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
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


    -- Using Lua functions
     vim.api.nvim_set_keymap('n', '<leader>ff', [[:lua require('telescope.builtin').find_files({ hidden = true })<cr>]], { silent = true })
     vim.api.nvim_set_keymap('n', '<leader>fg', [[:lua require('telescope.builtin').live_grep({ follow = true })<cr>]], { silent = true })
     vim.api.nvim_set_keymap('n', '<leader>fb', [[:lua require('telescope.builtin').buffers()<cr>]], { silent = true })
     vim.api.nvim_set_keymap('n', '<leader>fh', [[:lua require('telescope.builtin').help_tags()<cr>]], { silent = true })

end

return M
