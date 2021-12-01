" ------------------------------------
" NERD Tree
" ------------------------------------
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1

let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=0

let g:NERDTreeWinPos = "left"
let g:NERDTreeDirArrowExpandable = '▹'
let g:NERDTreeDirArrowCollapsible = '▿'

nnoremap <expr> <leader>n g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nmap <leader>N :NERDTreeFind<CR>

" If more than one window and previous buffer was NERDTree, go back to it.
" autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'

map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
