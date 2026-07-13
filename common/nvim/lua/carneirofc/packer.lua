local M = {}
function M.setup()
    -- Automatically install packer
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if not vim.loop.fs_stat(install_path) then
        PACKER_BOOTSTRAP = vim.fn.system({
            'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
        })
        print("Installing packer close and reopen Neovim...")
    end

    -- Use a protected call so we don't error out on first use
    local status_ok, packer = pcall(require, "packer")
    if not status_ok then
        print("Failed to import packer, check if the dependency was correctly installed...")
        return
    end

    -- Install your plugins here
    return packer.startup(function(use)
        -- DAP
        use({ 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'}})
        use({ 'theHamsta/nvim-dap-virtual-text' })
        -- Packer can manage itself
        use({ 'wbthomason/packer.nvim' })

        -- Git related plugins
        use({ 'tpope/vim-fugitive' })

        -- Visuals
        use({ 'onsails/lspkind-nvim' })               -- vscode-like pictograms to neovim
        use({ 'kyazdani42/nvim-web-devicons' })       -- lua fork of vim-devicons
        use({ 'rose-pine/neovim', as = 'rose-pine' }) -- colorscheme

        use({ 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } })

        -- file tree explorer
        use({ 'kyazdani42/nvim-tree.lua' })

        -- Markdown preview on the web...  MarkdownPreview ...
        use({ 'iamcco/markdown-preview.nvim', run = 'cd app && npm install' })
        use({ 'glepnir/galaxyline.nvim', branch = 'main' })

        -- use({ 'ap/vim-css-color' }) -- { 'for': ['css', 'vim'] } -- Color previews for CSS

        -- Tree-Sitter
        -- "  parsers should be installed, use the command :TSInstall <language> or :TSInstallInfo
        -- "  usage:   :TSUpdate so we keep parsers fresh
        -- "           :TSInstall bash cmake cpp css dockerfile http javascript json5 latex lua python tsx typescript vim
        -- "   see :h nvim-treesitter-modules or "Available modules" below for a list of modules and their options.
        use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

        -- Useful status updates for LSP
        use({ 'j-hui/fidget.nvim', tag = "v1.4.5" })

        use({ 'nvimtools/none-ls.nvim' })

        -- LSP Support
        use({ 'neovim/nvim-lspconfig' })
        use({ 'williamboman/mason.nvim' })
        use({ 'williamboman/mason-lspconfig.nvim' })
        use({ 'neovim/nvim-lspconfig' })
        use({ 'folke/lazydev.nvim' })

        -- Autocompletion
        use({ 'hrsh7th/nvim-cmp' })
        use({ 'hrsh7th/cmp-buffer' })
        use({ 'hrsh7th/cmp-path' })
        use({ 'saadparwaiz1/cmp_luasnip' })
        use({ 'hrsh7th/cmp-nvim-lsp' })
        use({ 'hrsh7th/cmp-nvim-lua' })

        -- Snippets
        use({ 'L3MON4D3/LuaSnip' })
        use({ 'rafamadriz/friendly-snippets' })

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if PACKER_BOOTSTRAP then
            require('packer').sync()
        end
    end)
end

return M
