local M = {}
function M.setup()
    -- require("lazydev").setup({})

    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()

    --  require("dapui").open()
    --  require("dapui").close()
    --  require("dapui").toggle()
    --
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

return M
