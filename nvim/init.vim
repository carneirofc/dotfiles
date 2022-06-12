" Load neovim settings
lua require('settings')

" Load keymaps
lua require('keymaps')

" Colors
hi NonText   guifg=#494949
hi SignColum guibg=#000000
hi Visual    guibg=#575757
hi VerSplit  guibg=#575757 guifg=#000000

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
" map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

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


" Exit terminal emulator remap
tnoremap <leader>q <C-\><C-n>

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
" sudo apt-get install ripgrep
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
Plug 'dracula/vim', { 'as': 'dracula' }
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
lua require("lsp_config")

" --------------------------------------
"  Completion Engine
lua require("cpm")

" ---------------
lua << EOF

local status, telescope = pcall(required, "telescope")

if not status then
    -- Failed to load telescope
    return
end

local default = {
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

EOF

" Using Lua functions
" nnoremap <C-f> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({ hidden = true })<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep({ follow = true })<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" --------------------------------------
"  FormatMarkdown - pip install --user -U mdformat mdformat-gfm
function! FormatMarkdown()
    let l:cursor_pos = getpos(".")
    execute ':%!mdformat -'
    " call histdel('search', -1)
    call setpos(".", l:cursor_pos)
endfunction

" autocmd BufWritePre *.md execute ':call FormatMarkdown()'

" ------------------------------------------
"  Configure nvim-treesitter
lua << EOF

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  -- ensure_installed = {'astro','bash','c','c_sharp','clojure','cmake','comment','commonlisp','cooklang','cpp','css','dart','dockerfile','dot','eex','elixir','elm','elvish','embedded_template','erlang','fennel','fish','foam','fortran','gleam','glimmer','go','gowork','graphql','hack','haskell','hcl','heex','help','hjson','hocon','html','http','java','javascript','jsdoc','json','json5','jsonc','julia','kotlin','lalrpop','latex','llvm','lua','m68k','make','markdown','ninja','nix','norg','ocaml','ocaml_interface','org','pascal','perl','php','pioasm','prisma','proto','pug','python','ql','query','rasi','regex','rego','rst','ruby','rust','scala','scheme','scss','slint','solidity','sparql','supercollider','surface','swift','tlaplus','todotxt','toml','tsx','typescript','vala','verilog','vim','vue','yaml','yang','zig'},

  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

  ignore_install = {'phpdoc'},  -- List of parsers to ignore installing

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
