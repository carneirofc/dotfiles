local M = {}

function M.setup()
    local telescope = require("telescope")

    local default = {
      initial_mode = "insert",
      defaults = {
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
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
    -- nnoremap <C-f> <cmd>lua require('telescope.builtin').find_files()<cr>
    vim.cmd([[ nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({ hidden = true })<cr> ]])
    vim.cmd([[ nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep({ follow = true })<cr> ]])
    vim.cmd([[ nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr> ]])
    vim.cmd([[ nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr> ]])

end

return M
