local wezterm = require('wezterm')

---Guards against a broken config taking the terminal down with it.
---Every failure is logged (view with `wezterm --config-file <path> start`, or the
---debug overlay) and swallowed, so the worst case is a missing option rather than
---a WezTerm that refuses to open a window.
local M = {}

---`require` a module, returning `fallback` if it raises.
---@generic T
---@param modname string module to load
---@param fallback T? value to return on failure. Defaults to an empty table.
---@return T
M.require = function(modname, fallback)
   local ok, result = pcall(require, modname)
   if ok then
      return result
   end

   wezterm.log_error(("config: failed to load '%s': %s"):format(modname, result))
   if fallback == nil then
      return {}
   end
   return fallback
end

---Call `fn`, returning `fallback` if it raises.
---@generic T
---@param label string name used in the error log
---@param fn fun(): T
---@param fallback T? value to return on failure. Defaults to `nil`.
---@return T?
M.call = function(label, fn, fallback)
   local ok, result = pcall(fn)
   if ok then
      return result
   end

   wezterm.log_error(("config: '%s' failed: %s"):format(label, result))
   return fallback
end

return M
