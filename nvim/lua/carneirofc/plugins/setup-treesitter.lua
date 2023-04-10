local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup({
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
            "bash", "c", "c_sharp", "cmake", "cpp", "css", "dockerfile", "go", "graphql", "html", "ini", "javascript",
            "jq", "json", "json5", "jsonc", "lua", "make", "markdown", "ninja", "python", "regex", "rust", "scss", "sql",
            "terraform", "tsx", "typescript", "vim", "vimdoc", "yaml"
        },
        sync_install = false,
        ignore_install = { 'phpdoc' }, -- List of parsers to ignore installing
        highlight = {
            enable = true,             -- false will disable the whole extension
            disable = {},              -- list of language that will be disabled
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    })
end

return M
