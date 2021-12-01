" ------------------------------------
"  YCM
" ------------------------------------
Plug 'ycm-core/YouCompleteMe' " Remember to compile the code! Requires nvim v0.6+

let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = "~/.config/nvim/scripts/.ycm_extra_conf.py"


nmap <C-Space> :YcmCompleter GetType<CR>
nmap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader>h :YcmDiags<CR>
