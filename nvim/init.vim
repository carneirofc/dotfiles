lua require('settings').setup()
lua require('keymaps').setup()

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switch CWD to the directory of the open buffer
" map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let g:python_host_prog = '~/miniconda3/envs/py27/bin/python'
let g:python3_host_prog = '~/miniconda3/bin/python'

" Temporary workaround for: https://github.com/neovim/neovim/issues/1716
if has("nvim")
  command! W w !sudo --non-interactive tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
  map <leader>w :new<cr>:term sudo true<cr>
else
  command! W w !sudo tee % > /dev/null
end

" https://stackoverflow.com/questions/3997078/how-to-paste-yanked-text-into-the-vim-command-line


" ------------------------------------
" Scripts
"
if has('win32')
  source ~/AppData/Local/nvim/vimrcs/clang-format.vim
  source ~/AppData/Local/nvim/vimrcs/cmake-format.vim
  source ~/AppData/Local/nvim/vimrcs/virtualenv.vim
endif

if has('unix')
  source ~/.config/nvim/vimrcs/clang-format.vim
  source ~/.config/nvim/vimrcs/cmake-format.vim
  source ~/.config/nvim/vimrcs/virtualenv.vim
endif


" ------------------------------------
" Plugins
if has('win32')
    call plug#begin('~/AppData/Local/nvim/plugged')
endif
if has('unix')
    call plug#begin('~/.config/nvim/plugged')
endif

Plug 'neovim/nvim-lspconfig' "  common configuration for various LSP servers
Plug 'hrsh7th/nvim-cmp',     { 'branch': 'main'}  " A completion engine plugin
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main'}  " source for neovim builtin LSP client
Plug 'hrsh7th/cmp-buffer',   { 'branch': 'main'}
Plug 'hrsh7th/cmp-path',     { 'branch': 'main'}
Plug 'hrsh7th/cmp-nvim-lua', { 'branch': 'main'}  " neovim lua api
Plug 'hrsh7th/cmp-cmdline' , { 'branch': 'main'}  " command line completion, currently bugged when ! os used !

Plug 'onsails/lspkind-nvim'  " vscode-like pictograms to neovim

" Code snipped engine, required for code completion
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" telescope can use a series of third party tools, such as 'ripgrep'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'branch': 'main', 'do': 'make' }

Plug 'kyazdani42/nvim-web-devicons' " lua fork of vim-devicons

" Tree-Sitter
"  parsers should be installed, use the command :TSInstall <language> or :TSInstallInfo
"  usage:   :TSUpdate so we keep parsers fresh
"           :TSInstall bash cmake cpp css dockerfile http javascript json5 latex lua python tsx typescript vim
"
"   Each module provides a distinct tree-sitter-based feature such as highlighting, indentation, or folding;
"   see :h nvim-treesitter-modules or "Available modules" below for a list of modules and their options.
"
"   All modules are disabled by default and need to be activated explicitly in your init.vim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" Language servers
if has('win32')
  Plug 'sumneko/lua-language-server', { 'do': 'git submodule update --init --recursive; cd ./3rd/luamake; ./compile/install.bat; cd ../..; ./3rd/luamake/luamake rebuild' }
endif
if has('unix')
  Plug 'sumneko/lua-language-server', { 'do': 'git submodule update --init --recursive; cd ./3rd/luamake; ./compile/install.bat && cd ../.. && ./3rd/luamake/luamake rebuild' }
endif

" Markdown preview on the web...  MarkdownPreview ...
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

if has('win32')
    source ~/AppData/Local/nvim/vimrcs/black.vim
    source ~/AppData/Local/nvim/vimrcs/vim-css-color.vim
    source ~/AppData/Local/nvim/vimrcs/airline.vim
    source ~/AppData/Local/nvim/vimrcs/git-gutter.vim
    source ~/AppData/Local/nvim/vimrcs/nerdtree.vim
    source ~/AppData/Local/nvim/vimrcs/vim-fugitive.vim
endif
if has('unix')
    source ~/.config/nvim/vimrcs/black.vim
    source ~/.config/nvim/vimrcs/vim-css-color.vim
    source ~/.config/nvim/vimrcs/airline.vim
    source ~/.config/nvim/vimrcs/git-gutter.vim
    source ~/.config/nvim/vimrcs/nerdtree.vim
    source ~/.config/nvim/vimrcs/vim-fugitive.vim
endif

call plug#end()

doautocmd User PlugLoaded

" --------------------------------------
"  Language Server Config
lua require('lsp_config')
lua require('cpm') --- Completion Engine
lua require('plugins.telescope').setup()
lua require('plugins.mdformat').setup()
lua require('plugins.treesitter').setup()
