" https://github.com/tpope/vim-fugitive

Plug 'tpope/vim-fugitive'


" :Git commit, :Git rebase -i, and other commands that invoke an editor do their editing in the current Vim instance.
" :Git diff, :Git log, and other verbose, paginated commands have their output loaded into a temporary buffer. Force this behavior for any command with :Git --paginate or :Git -p.
" :Git blame uses a temporary buffer with maps for additional triage. Press enter on a line to view the commit where the line changed, or g? to see other available maps. Omit the filename argument and the currently edited file will be blamed in a vertical, scroll-bound split.
" :Git mergetool and :Git difftool load their changesets into the quickfix list.
" Called with no arguments, :Git opens a summary window with dirty files and unpushed and unpulled commits. Press g? to bring up a list of maps for numerous operations including diffing, staging, committing, rebasing, and stashing. (This is the successor to the old :Gstatus.)
