" ------------------------------------
" General editor settings
set updatetime=300      " Reduce time for highlighting other references
set redrawtime=10000    " Allow more time for loading syntax on large files
set number
set relativenumber
set encoding=utf-8
set termguicolors       " True collor (24bit) support
set title
set ignorecase
set smartcase
set confirm

" Send yank to system's clipboard
set clipboard=unnamedplus

set showtabline=2

" ------------------------------------
" GUI related

" Set font according to system.
set guifont=JetBrainsMono\ Nerd\ Font:h16

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mouse Scrolling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=nicr
set mouse=a

" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
 
" ------------------------------------
" Text, tab and indent related

set expandtab       " Use spaces instead of tabs
set smarttab        " Be smart when using tabs ;)
set shiftwidth=4    " 1 tab == 4 spaces
set tabstop=4       " 1 tab == 4 spaces
set lbr             " Linebreak on 500 characters
set tw=500          " Linebreak on 500 characters
set ai              " Auto indent
set si              " Smart indent
set wrap            " Wrap lines

" ------------------------------------
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
" Plugins and scripts
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')

source ~/.config/nvim/vimrcs/vim-css-color.vim
source ~/.config/nvim/vimrcs/airline.vim
source ~/.config/nvim/vimrcs/black.vim
source ~/.config/nvim/vimrcs/clang-format.vim
source ~/.config/nvim/vimrcs/cmake-format.vim
source ~/.config/nvim/vimrcs/cpp-enhanced-highlight.vim
source ~/.config/nvim/vimrcs/fzf.vim
source ~/.config/nvim/vimrcs/git-gutter.vim
source ~/.config/nvim/vimrcs/nerdtree.vim
source ~/.config/nvim/vimrcs/syntastic.vim
source ~/.config/nvim/vimrcs/vim-fugitive.vim
source ~/.config/nvim/vimrcs/virtualenv.vim
source ~/.config/nvim/vimrcs/ycm.vim

call plug#end()
doautocmd User PlugLoaded
