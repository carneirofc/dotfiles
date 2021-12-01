" ------------------------------------
" General editor settings
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files
set number
set relativenumber
set encoding=utf-8
set termguicolors
set title
set ignorecase
set smartcase
set mouse=a
set confirm


" ------------------------------------
" GUI related

" Set font according to system https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip?_ga=2.21246782.427104117.1586269112-2045209984.1586269112
set gfn="JetBrainsMono Nerd Font"

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" ------------------------------------
" Text, tab and indent related

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

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
map <leader>bd :Bclose<cr>:tabclose<cr>gT

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

" ------------------------------------
" Plugins and scripts
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')

source ~/.config/nvim/vimrcs/airline.vim
source ~/.config/nvim/vimrcs/black.vim
source ~/.config/nvim/vimrcs/clang-format.vim
source ~/.config/nvim/vimrcs/cmake-format.vim
source ~/.config/nvim/vimrcs/cpp-enhanced-highlight.vim
source ~/.config/nvim/vimrcs/fzf.vim
source ~/.config/nvim/vimrcs/git-gutter.vim
source ~/.config/nvim/vimrcs/nerdtree.vim
source ~/.config/nvim/vimrcs/syntastic.vim
source ~/.config/nvim/vimrcs/virtualenv.vim
source ~/.config/nvim/vimrcs/ycm.vim

call plug#end()
doautocmd User PlugLoaded
