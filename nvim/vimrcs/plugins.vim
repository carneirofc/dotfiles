" ------------------------------------
"  Plug
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'preservim/nerdtree'
Plug 'psf/black', {'tag':'21.11b1'} " Python Formatter
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'ycm-core/YouCompleteMe' " Remember to compile the code! Requires nvim v0.6+
Plug 'junegunn/fzf'
call plug#end()

" -----------------------------------
" FZF Fuzzy Finder
" -----------------------------------
"  https://github.com/junegunn/fzf
"  https://github.com/junegunn/fzf.vim
nmap <C-P> :FZF<CR>

" ------------------------------------
"  syntastic
" ------------------------------------
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_flake8_args='--ignore=E501,E221,E231'

" ------------------------------------
"  black python format
" ------------------------------------
autocmd BufWritePre *.py execute ':Black'

" ------------------------------------
"  cmake-format
" ------------------------------------
" @todo

" ------------------------------------
" NERD Tree
" ------------------------------------
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden = 0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

" ------------------------------------
" Vim airline
" ------------------------------------
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_spell=1

" ------------------------------------
"  git gutter
" ------------------------------------
highlight GitGutterAdd    guifg=#009900 guibg=<X> ctermfg=2
highlight GitGutterChange guifg=#bbbb00 guibg=<X> ctermfg=3
highlight GitGutterDelete guifg=#ff2222 guibg=<X> ctermfg=1

" ------------------------------------
"  cpp-enhanced-highlight
" ------------------------------------
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let c_no_curly_error=1

" ------------------------------------
"  YCM
" ------------------------------------
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_confirm_extra_conf = 0
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

