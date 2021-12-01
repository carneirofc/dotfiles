" ------------------------------------
"  syntastic
" ------------------------------------
Plug 'vim-syntastic/syntastic'

let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_flake8_args='--ignore=E501,E221,E231'

