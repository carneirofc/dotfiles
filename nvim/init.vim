" ------------------------------------
" General editor settings
set updatetime=300      " Reduce time for highlighting other references
" set redrawtime=10000    " Allow more time for loading syntax on large files
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
" https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip?_ga=2.21246782.427104117.1586269112-2045209984.1586269112
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Theming
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight Normal           guifg=#dfdfdf ctermfg=15   guibg=#1D1F21 ctermbg=none  cterm=none
highlight LineNr           guifg=#5b6268 ctermfg=8    guibg=#1D1F21 ctermbg=none  cterm=none
highlight CursorLineNr     guifg=#202328 ctermfg=7    guifg=#1D1F21 ctermbg=8     cterm=none
highlight VertSplit        guifg=#1c1f24 ctermfg=0    guifg=#5b6268 ctermbg=8     cterm=none
highlight Statement        guifg=#98be65 ctermfg=2    guibg=none    ctermbg=none  cterm=none
highlight Directory        guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=none
highlight StatusLine       guifg=#202328 ctermfg=7    guifg=#5b6268 ctermbg=8     cterm=none
highlight StatusLineNC     guifg=#202328 ctermfg=7    guifg=#5b6268 ctermbg=8     cterm=none
highlight NERDTreeClosable guifg=#98be65 ctermfg=2
highlight NERDTreeOpenable guifg=#5b6268 ctermfg=8
highlight Comment          guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=italic
highlight Constant         guifg=#3071db ctermfg=12   guibg=none    ctermbg=none  cterm=none
highlight Special          guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=none
highlight Identifier       guifg=#5699af ctermfg=6    guibg=none    ctermbg=none  cterm=none
highlight PreProc          guifg=#c678dd ctermfg=5    guibg=none    ctermbg=none  cterm=none
highlight String           guifg=#3071db ctermfg=12   guibg=none    ctermbg=none  cterm=none
highlight Number           guifg=#ff6c6b ctermfg=1    guibg=none    ctermbg=none  cterm=none
highlight Function         guifg=#ff6c6b ctermfg=1    guibg=none    ctermbg=none  cterm=none
highlight Visual           guifg=#dfdfdf ctermfg=1    guibg=#748096 ctermbg=none  cterm=none

" highlight WildMenu         ctermfg=0       ctermbg=80      cterm=none
" highlight Folded           ctermfg=103     ctermbg=234     cterm=none
" highlight FoldColumn       ctermfg=103     ctermbg=234     cterm=none
" highlight DiffAdd          ctermfg=none    ctermbg=23      cterm=none
" highlight DiffChange       ctermfg=none    ctermbg=56      cterm=none
" highlight DiffDelete       ctermfg=168     ctermbg=96      cterm=none
" highlight DiffText         ctermfg=0       ctermbg=80      cterm=none
" highlight SignColumn       ctermfg=244     ctermbg=235     cterm=none
" highlight Conceal          ctermfg=251     ctermbg=none    cterm=none
" highlight SpellBad         ctermfg=168     ctermbg=none    cterm=underline
" highlight SpellCap         ctermfg=80      ctermbg=none    cterm=underline
" highlight SpellRare        ctermfg=121     ctermbg=none    cterm=underline
" highlight SpellLocal       ctermfg=186     ctermbg=none    cterm=underline
" highlight Pmenu            ctermfg=251     ctermbg=234     cterm=none
" highlight PmenuSel         ctermfg=0       ctermbg=111     cterm=none
" highlight PmenuSbar        ctermfg=206     ctermbg=235     cterm=none
" highlight PmenuThumb       ctermfg=235     ctermbg=206     cterm=none
" highlight TabLine          ctermfg=244     ctermbg=234     cterm=none
" highlight TablineSel       ctermfg=0       ctermbg=247     cterm=none
" highlight TablineFill      ctermfg=244     ctermbg=234     cterm=none
" highlight CursorColumn     ctermfg=none    ctermbg=236     cterm=none
" highlight CursorLine       ctermfg=none    ctermbg=236     cterm=none
" highlight ColorColumn      ctermfg=none    ctermbg=236     cterm=none
" highlight Cursor           ctermfg=0       ctermbg=5       cterm=none
" highlight htmlEndTag       ctermfg=114     ctermbg=none    cterm=none
" highlight xmlEndTag        ctermfg=114     ctermbg=none    cterm=none


 
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
