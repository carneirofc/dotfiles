" ------------------------------------
"  black python format
" ------------------------------------
Plug 'psf/black', {'tag':'21.11b1', 'for':'python'} " Python Formatter
autocmd BufWritePre *.py execute ':Black'
