" Load neovim settings
lua require('settings')

" Colors
hi NonText   guifg=#494949
hi SignColum guibg=#000000
hi Visual    guibg=#575757
hi VerSplit  guibg=#575757 guifg=#000000

set guioptions-=r                         " Disable scrollbar
set guioptions-=R                         " Disable scrollbar
set guioptions-=l                         " Disable scrollbar
set guioptions-=L                         " Disable scrollbar

" ------------------------------------
lua << EOF

-- Reselect visual selection after indenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

-- Buffer handling
vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<cr>',   { silent = false })
vim.api.nvim_set_keymap('n', '<leader>ba', ':bufdo bd<cr>',  { silent = false }) -- Close all the buffers
vim.api.nvim_set_keymap('n', '<leader>l',  ':bnext<cr>',     { silent = false })
vim.api.nvim_set_keymap('n', '<leader>h',  ':bprevious<cr>', { silent = false })

-- Smart way to move between windows
vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', { silent = false })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { silent = false })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { silent = false })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { silent = false })

-- Useful mappings for managing tabs
vim.api.nvim_set_keymap('n', '<leader>tn',         ':tabnew<cr>',   { silent = false })
vim.api.nvim_set_keymap('n', '<leader>to',         ':tabonly<cr>',  { silent = false })
vim.api.nvim_set_keymap('n', '<leader>tc',         ':tabclose<cr>', { silent = false })
vim.api.nvim_set_keymap('n', '<leader>tm',         ':tabmove',      { silent = false })
vim.api.nvim_set_keymap('n', '<leader>t<leader>',  ':tabnext',      { silent = false })


-- Switch CWD to the directory of the open buffer
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', { silent = false })

-- Vertical Split Current Buffer
vim.api.nvim_set_keymap('n', '<leader>vs', ':vs %<cr>', { silent = false })

-- Horizontal Split Current Buffer
vim.api.nvim_set_keymap('n', '<leader>sv', ':sv %<cr>', { silent = false })

EOF

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

let g:python_host_prog  = '/home/carneirofc/miniconda3/envs/py27/bin/python'
let g:python3_host_prog  = '/home/carneirofc/miniconda3/bin/python'

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
source ~/.config/nvim/vimrcs/clang-format.vim
source ~/.config/nvim/vimrcs/cmake-format.vim
source ~/.config/nvim/vimrcs/virtualenv.vim

" ------------------------------------
" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig' "  common configuration for various servers
Plug 'hrsh7th/nvim-cmp'      " A completion engine plugin
Plug 'hrsh7th/cmp-nvim-lsp'  " source for neovim builtin LSP client
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'  " neovim lua api
Plug 'hrsh7th/cmp-cmdline'   " command line completion, currently bugged when ! os used !
Plug 'onsails/lspkind-nvim'  " vscode-like pictograms to neovim

" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Language servers
Plug 'sumneko/lua-language-server', { 'do': 'git submodule update --init --recursive && cd ./3rd/luamake && ./compile/install.sh && cd ../.. && ./3rd/luamake/luamake rebuild' }

" Markdown preview on the web...  MarkdownPreview ...
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

source ~/.config/nvim/vimrcs/black.vim
source ~/.config/nvim/vimrcs/vim-css-color.vim
source ~/.config/nvim/vimrcs/airline.vim
source ~/.config/nvim/vimrcs/fzf.vim
source ~/.config/nvim/vimrcs/git-gutter.vim
source ~/.config/nvim/vimrcs/nerdtree.vim
source ~/.config/nvim/vimrcs/vim-fugitive.vim

Plug 'kyazdani42/nvim-web-devicons' " lua fork of vim-devicons

call plug#end()

doautocmd User PlugLoaded

" --------------------------------------
"  Language Server Config
lua require("lsp_config")

" --------------------------------------
"  Completion Engine
lua require("nvim-cpm")


" --------------------------------------
"  FormatMarkdown - pip install --user -U mdformat mdformat-gfm
function! FormatMarkdown()
    let l:cursor_pos = getpos(".")
    execute ':%!mdformat -'
    " call histdel('search', -1)
    call setpos(".", l:cursor_pos)
endfunction

autocmd BufWritePre *.md execute ':call FormatMarkdown()'

