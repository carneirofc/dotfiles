local wezterm = require('wezterm')

---Last-resort config, used only if building the real one raises.
---Keep this dependency-free and boring: its whole job is to guarantee a usable
---terminal so you can open the debug overlay (`CTRL+SHIFT+L`) and read the error.
---@type Config
local FALLBACK = {
   font = wezterm.font('JetBrainsMono Nerd Font'),
   font_size = 12,
   color_scheme = 'Catppuccin Mocha',
   enable_wayland = false,
   automatically_reload_config = true,
}

---Nothing below may raise: every module load and every side effect is wrapped.
---The one thing no amount of pcall can save is a syntax error in *this* file --
---WezTerm falls back to its own built-in defaults there and shows the error.
local function build()
   local safe = require('utils.safe')
   local backdrops = safe.require('utils.backdrops')

   -- `scan_images_dir` shells out via `wezterm.glob`, which is only legal here in
   -- `wezterm.lua` during the initial config load -- see the note on the method.
   -- Drop images into `backdrops/` (or point `set_images_dir` elsewhere) to use it.
   safe.call('backdrops:scan_images_dir', function()
      -- backdrops:set_images_dir(wezterm.home_dir .. '/Pictures/Wallpapers')
      backdrops:scan_images_dir():random()
   end)

   local options = safe.require('config'):init()
      :append(safe.require('config.appearance'))
      :append(safe.require('config.fonts'))
      :append(safe.require('config.general'))
      :append(safe.require('config.platform')).options

   -- Every module failed and was swallowed individually; an empty config is valid
   -- but silently drops us to WezTerm's defaults, so take FALLBACK instead.
   if next(options) == nil then
      error('every config module failed to load')
   end

   return options
end

local ok, config = pcall(build)

if not ok then
   wezterm.log_error('config: build failed, falling back to a minimal config: ' .. tostring(config))
   return FALLBACK
end

return config
