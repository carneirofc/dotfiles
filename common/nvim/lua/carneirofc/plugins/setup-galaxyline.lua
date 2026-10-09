local M = {}

function M.setup()
    local status, gl = pcall(require, 'galaxyline')
    if not status then
        print("galaxyline not found, ensure plugin is installed")
        return
    end
    local colors = require('galaxyline.theme').default
    local condition = require('galaxyline.condition')
    local gls = gl.section
    gl.short_line_list = { 'NvimTree', 'vista', 'dbui', 'packer' }

    -- galaxyline's built-in Diagnostic*/GetLspClient providers call
    -- vim.lsp.buf_get_clients / get_active_clients, both deprecated and
    -- scheduled for removal. These replacements use the current APIs.
    local function diagnostic_count(severity)
        return function()
            if next(vim.lsp.get_clients({ bufnr = 0 })) == nil then
                return ''
            end
            local n = vim.diagnostic.count(0)[severity] or 0
            if n == 0 then
                return ''
            end
            return n .. ' '
        end
    end

    local function lsp_client_name()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, client.name)
        end
        if #names == 0 then
            return 'No Active Lsp'
        end
        return table.concat(names, ',')
    end

    gls.left[1] = {
        RainbowRed = {
            provider = function() return '▊ ' end,
            highlight = { colors.blue, colors.bg }
        },
    }
    gls.left[2] = {
        ViMode = {
            provider = function()
                -- auto change color according the vim mode
                local mode_color = {
                    R      = colors.violet,
                    Rv     = colors.violet,
                    S      = colors.orange,
                    V      = colors.blue,
                    ['']  = colors.orange,
                    ['']  = colors.blue,
                    ['!']  = colors.red,
                    ['r?'] = colors.cyan,
                    c      = colors.magenta,
                    ce     = colors.red,
                    cv     = colors.red,
                    i      = colors.green,
                    ic     = colors.yellow,
                    n      = colors.red,
                    no     = colors.red,
                    r      = colors.cyan,
                    rm     = colors.cyan,
                    s      = colors.orange,
                    t      = colors.red,
                    v      = colors.blue,
                }
                -- Fall back for modes not listed above (e.g. 'nt', 'niI').
                vim.api.nvim_command('hi GalaxyViMode guifg=' .. (mode_color[vim.fn.mode()] or colors.red))
                return '  '
            end,
            highlight = { colors.red, colors.bg, 'bold' },
        },
    }
    gls.left[3] = {
        FileSize = {
            provider = 'FileSize',
            condition = condition.buffer_not_empty,
            highlight = { colors.fg, colors.bg }
        }
    }
    gls.left[4] = {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg },
        },
    }

    gls.left[5] = {
        FileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty,
            highlight = { colors.magenta, colors.bg, 'bold' }
        }
    }

    gls.left[6] = {
        LineInfo = {
            provider = 'LineColumn',
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.fg, colors.bg },
        },
    }

    gls.left[7] = {
        PerCent = {
            provider = 'LinePercent',
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.fg, colors.bg, 'bold' },
        }
    }

    gls.left[8] = {
        DiagnosticError = {
            provider = diagnostic_count(vim.diagnostic.severity.ERROR),
            icon = '  ',
            highlight = { colors.red, colors.bg }
        }
    }
    gls.left[9] = {
        DiagnosticWarn = {
            provider = diagnostic_count(vim.diagnostic.severity.WARN),
            icon = '  ',
            highlight = { colors.yellow, colors.bg },
        }
    }

    gls.left[10] = {
        DiagnosticHint = {
            provider = diagnostic_count(vim.diagnostic.severity.HINT),
            icon = '  ',
            highlight = { colors.cyan, colors.bg },
        }
    }

    gls.left[11] = {
        DiagnosticInfo = {
            provider = diagnostic_count(vim.diagnostic.severity.INFO),
            icon = '  ',
            highlight = { colors.blue, colors.bg },
        }
    }

    gls.mid[1] = {
        ShowLspClient = {
            provider = lsp_client_name,
            condition = function()
                local tbl = { ['dashboard'] = true,[''] = true }
                if tbl[vim.bo.filetype] then
                    return false
                end
                return true
            end,
            icon = ' LSP:',
            highlight = { colors.cyan, colors.bg, 'bold' }
        }
    }

    gls.right[1] = {
        FileEncode = {
            provider = 'FileEncode',
            condition = condition.hide_in_width,
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.green, colors.bg, 'bold' }
        }
    }

    gls.right[2] = {
        FileFormat = {
            provider = 'FileFormat',
            condition = condition.hide_in_width,
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.green, colors.bg, 'bold' }
        }
    }

    gls.right[3] = {
        GitIcon = {
            provider = function() return '  ' end,
            condition = condition.check_git_workspace,
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.violet, colors.bg, 'bold' },
        }
    }

    gls.right[4] = {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            highlight = { colors.violet, colors.bg, 'bold' },
        }
    }

    gls.right[5] = {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = { colors.green, colors.bg },
        }
    }
    gls.right[6] = {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width,
            icon = ' 柳',
            highlight = { colors.orange, colors.bg },
        }
    }
    gls.right[7] = {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = { colors.red, colors.bg },
        }
    }

    gls.right[8] = {
        RainbowBlue = {
            provider = function() return ' ▊' end,
            highlight = { colors.blue, colors.bg }
        },
    }

    gls.short_line_left[1] = {
        BufferType = {
            provider = 'FileTypeName',
            separator = ' ',
            separator_highlight = { 'NONE', colors.bg },
            highlight = { colors.blue, colors.bg, 'bold' }
        }
    }

    gls.short_line_left[2] = {
        SFileName = {
            provider = 'SFileName',
            condition = condition.buffer_not_empty,
            highlight = { colors.fg, colors.bg, 'bold' }
        }
    }

    gls.short_line_right[1] = {
        BufferIcon = {
            provider = 'BufferIcon',
            highlight = { colors.fg, colors.bg }
        }
    }
end

return M
