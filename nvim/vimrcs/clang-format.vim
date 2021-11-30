" ------------------------------------
"  clang-format
" ------------------------------------

let g:clang_format_path = "clang-format"
let g:clang_format_fallback_style = "llvm"

function! Formatdiff()
  let l:formatdiff = 1
  py3f ~/.config/nvim/scripts/clang-format.py
endfunction
autocmd BufWritePre *.hh,*.hpp,*.h,*.cc,*.cpp call Formatdiff()
noremap <leader>k :call Formatdiff()<cr>

