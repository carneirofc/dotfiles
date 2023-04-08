local M = {}

local options = {
--  backup          = true,
--  backupdir       = "C:\\Users\\claud\\AppData\\Local\\Temp\\nvim",
    laststatus      = 3,                        -- Single status bar
    autoindent      = true,                     -- Auto indent
    belloff         = "all",                    -- turn it off
    clipboard       = "unnamed,unnamedplus",    -- Send yank to system's clipboard
    cmdheight       = 1,                        -- Height of the command bar
    completeopt     = "menu,menuone,noselect",  -- Better autocompletion
    confirm         = true,                     -- Confirm dialog when executing commands
    cursorline      = false,                    -- Highlight cursor line
    encoding        = "utf-8",                  -- The encoding displayed
    errorbells      = false,                    -- Disables sound effect for errors
    expandtab       = true,                     -- Use spaces instead of tabs
    fileencoding    = "utf-8",                  -- The encoding written to file
    guifont         = "JetBrainsMono Nerd Font:h16",
    ignorecase      = true,                     -- Ingore case on searchs
    linebreak       = true,                     -- Vim will wrap long lines at a character in 'breakat'
    list            = true,                     -- Display invisible chart such as spaces, linebreaks and tabs
    listchars       = {eol='↲',tab ='▸ ',trail='·'}, -- Remap invisible chars
    mouse           = "a",                      -- Enable mouse interactions
    number          = true,                     -- Line number
    pumheight       = 10,                       -- Maximum number of items to show in the popup menu
    redrawtime      = 10000,                    -- Time in milliseconds for redrawing the display in ms
    relativenumber  = true,                     -- Relative line numbers
    shiftwidth      = 4,                        -- Tab size
    showcmd         = true,
    showmatch       = true,                     -- show matching brackets when text indicator is over them
    showtabline     = 2,                        -- When the line with tab page labels will be displayed
    signcolumn      = "yes",                    -- Always display sign column
    smartcase       = true,                     -- Only ignore case if not uppercase is present on serachs
    smartindent     = true,                     -- Smart indent
    smarttab        = true,                     -- Be smart when using tabs ;)
    splitbelow      = true,                     -- Horizontal splits will automatically be to the bottom
    splitright      = true,                     -- Vertical splits will automatically be to the right
    swapfile        = false,                    -- Swap not needed
    switchbuf       = "useopen,usetab,newtab",  -- This option controls the behavior when switching between buffers.
    tabstop         = 4,                        -- 1 tab == 4 spaces
    termguicolors   = true,                     -- Enables 24-bit RGB color
    textwidth       = 500,                      -- Maximum width of text that is being
    title           = true,                     -- Window title
    updatetime      = 300,                      -- Reduce time for highlighting other references in ms
    wildignore      = "*node_modules/**",       -- Don't search inside Node.js modules (works for gutentag)
    wrap            = true,                     -- Wrap lines
}

function SetOptions()
    for k, v in pairs(options) do
        vim.opt[k] = v
    end
end

function SetColors()
    vim.cmd([[colorscheme dracula]])

    vim.cmd([[ hi NonText   guifg=#494949 ]])
    vim.cmd([[ hi SignColum guibg=#000000 ]])
    vim.cmd([[ hi Visual    guibg=#575757 ]])
    vim.cmd([[ hi VerSplit  guibg=#575757 guifg=#000000 ]])
end

function M.setup()
    SetOptions()
    SetColors()

    vim.g.python_host_prog = ''
    vim.g.python3_host_prog = '/usr/bin/python3'

    if vim.fn.has('wsl') then
        vim.cmd([[
            let g:clipboard = {
              \   'name': 'WslClipboard',
              \   'copy': {
              \      '+': 'clip.exe',
              \      '*': 'clip.exe',
              \    },
              \   'paste': {
              \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              \   },
              \   'cache_enabled': 0,
              \ }
        ]])
    end


    vim.cmd([[
    if has("nvim")
      command! W w !sudo --non-interactive tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
      map <leader>w :new<cr>:term sudo true<cr>
    else
      command! W w !sudo tee % > /dev/null
    end
    ]]) --- Temporary workaround for: https://github.com/neovim/neovim/issues/1716

    --- Paste Yanked Text into vim command line
    --- https://stackoverflow.com/questions/3997078/how-to-paste-yanked-text-into-the-vim-command-line !!!!!!!
end

return M
