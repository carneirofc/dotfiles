
if has('win32')
  source ~/AppData/Local/nvim/vimrcs/plug.vim
  source ~/AppData/Local/nvim/vimrcs/clang-format.vim
endif

if has('unix')
  source ~/.config/nvim/vimrcs/plug.vim
  source ~/.config/nvim/vimrcs/clang-format.vim
endif

lua << EOF

require('settings').setup()
require('keymaps').setup()

require('lsp_config')             --- Language Server
require('core.cmp')               --- Completion Engine

require('plugins.black').setup()
require('plugins.nvim-tree').setup()
require('plugins.telescope').setup()
require('plugins.mdformat').setup()
require('plugins.treesitter').setup()
require('plugins.galaxyline').setup()

EOF
