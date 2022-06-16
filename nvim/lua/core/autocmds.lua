local M = {}
function M.setup()
    --- Return to last edit position when opening files (You want this!)
    vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

    --- Python with VIRTUAL_ENV
    vim.cmd([[
        function! Pythonvenv()
        py3 << EOF
        import os
        import sys
        if "VIRTUAL_ENV" in os.environ:
          project_base_dir = os.environ["VIRTUAL_ENV"]
          activate_this = os.path.join(project_base_dir, "bin/activate_this.py")
          # execfile(activate_this, dict(__file__=activate_this))
          with open(activate_this, "rb") as source_file:
            code = compile(source_file.read(), activate_this, "exec")
          exec(code, dict(__file__=activate_this))
        EOF
        endfunction

        autocmd BufReadPost,BufNewFile *.py call Pythonvenv()
    ]])
end
return M

