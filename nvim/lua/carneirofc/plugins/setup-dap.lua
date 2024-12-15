local M = {}
function M.setup()
    local neodev = require("neodev")
    local dap = require("dap")
    local dapui = require("dapui")

    neodev.setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
        --      ...
    })
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
