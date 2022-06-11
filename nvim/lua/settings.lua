local options = {
--  backup          = true,
--  backupdir       = "C:\\Users\\claud\\AppData\\Local\\Temp\\nvim",
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
    tabstop         = 4,                        -- 1 tab == 4 spaces
    termguicolors   = true,                     -- Enables 24-bit RGB color
    textwidth       = 500,                      -- Maximum width of text that is being
    title           = true,                     -- Window title
    updatetime      = 300,                      -- Reduce time for highlighting other references in ms
    wildignore      = "*node_modules/**",       -- Don't search inside Node.js modules (works for gutentag)
    wrap            = true,                     -- Wrap lines
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
