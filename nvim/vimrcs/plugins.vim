" ------------------------------------
"  Plug
" ------------------------------------

call plug#begin('~/.config/nvim/plugged')
"This should work but isn't. Instead one should compile with the flags after the repository is cloned
"Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') } 
Plug 'airblade/vim-gitgutter'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'preservim/nerdtree'
Plug 'psf/black', {'tag':'19.10b0'} " Python Formatter
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ycm-core/YouCompleteMe'
call plug#end()

" ------------------------------------
"  clang-format
" ------------------------------------
function! Formatdiff()
  let l:formatdiff = 1
  py3f ~/.config/nvim/scripts/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatdiff()
noremap <leader>k :call Formatdiff()<cr>

let g:clang_format_fallback_style = "llvm"

" ------------------------------------
"  black python format
" ------------------------------------
autocmd BufWritePre *.py execute ':Black'

" ------------------------------------
"  cmake-format
" ------------------------------------
" /home/carneirofc/Devel/cons-regatron-interface/venv/bin/cmake-format
" @todo

" ------------------------------------
" NERD Tree
" ------------------------------------
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
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
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

