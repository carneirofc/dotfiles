" ------------------------------------
"  black python format
" ------------------------------------
Plug 'psf/black', {'tag':'21.12b0', 'for':'python'} " Python Formatter
autocmd BufWritePre *.py execute ':Black'
