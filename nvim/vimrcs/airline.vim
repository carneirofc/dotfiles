" ------------------------------------
" Vim airline
" ------------------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_crypt = 1
let g:airline_detect_spell = 1

" let g:airline_skip_empty_sections = 1 " Consider adding this back if tmux requires
let g:airline_theme = 'deus'


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '


set noshowmode
