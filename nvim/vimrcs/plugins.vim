" ------------------------------------
"  Plug
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'preservim/nerdtree'
Plug 'psf/black', {'tag':'21.11b1'} " Python Formatter
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'ycm-core/YouCompleteMe' " Remember to compile the code! Requires nvim v0.6+
call plug#end()

source ~/.config/nvim/vimrcs/airline.vim
source ~/.config/nvim/vimrcs/black.vim
source ~/.config/nvim/vimrcs/cmake-format.vim
source ~/.config/nvim/vimrcs/cpp-enhanced-highlight.vim
source ~/.config/nvim/vimrcs/fzf.vim
source ~/.config/nvim/vimrcs/git-gutter.vim
source ~/.config/nvim/vimrcs/nerdtree.vim
source ~/.config/nvim/vimrcs/syntastic.vim
source ~/.config/nvim/vimrcs/ycm.vim

