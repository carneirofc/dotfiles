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

EOF
" Moving around, tabs, windows and buffers

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :bdelete<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

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

" let g:loaded_python_provider = 0  " To disable Python 2 support
" let g:loaded_python3_provider = 0 " To disable Python 3 support
"
"
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
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'  " neovim lua api
Plug 'hrsh7th/cmp-cmdline'   " command line completion, currently bugged when ! os used !
Plug 'hrsh7th/nvim-cmp'      " A completion engine plugin
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

call plug#end()

doautocmd User PlugLoaded

" --------------------------------------
"  Language Server Config
lua require("lsp_config")

" --------------------------------------
"  Completion Engine
lua require("nvim-cpm")

