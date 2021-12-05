" -----------------------------------
" FZF Fuzzy Finder
" -----------------------------------
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

let g:fzf_layout = { 'up': '~90%', 'window': { 'width': 0.8, 'height': 0.8, 'yoffset':0.5, 'xoffset': 0.5 } }
let $FZF_DEFAULT_OPTS = '--info=inline'

" Customise the Files command to use rg which respects .gitignore files
command! -bang -nargs=? -complete=dir Files
       \ call fzf#run(fzf#wrap('files', fzf#vim#with_preview({ 'dir': <q-args>, 'sink': 'e', 'source': 'rg --files --hidden' }), <bang>0))

" Add an AllFiles variation that ignores .gitignore files
command! -bang -nargs=? -complete=dir AllFiles
       \ call fzf#run(fzf#wrap('allfiles', fzf#vim#with_preview({ 'dir': <q-args>, 'sink': 'e', 'source': 'rg --files --hidden --no-ignore' }), <bang>0))

nmap <C-f> :Files<cr>
nmap <C-F> :AllFiles<cr>
nmap <C-b> :Buffers<cr>

" @todo: remap this! Conflict with register access
" nmap <C- > :History<cr> 
" nmap <C- > :Rg<cr>
" nmap <C- > :Rg<space>
nmap <C-P> :FZF<CR>
" nmap <leader>gb :GBranches<cr>
