local wezterm = require('wezterm')
local safe = require('utils.safe')

---Last-resort config, used only if building the real one raises.
---Keep this dependency-free and boring: its whole job is to guarantee a usable
---terminal so you can open the debug overlay and read the error.
---@type Config
local FALLBACK = {
   font = wezterm.font('JetBrainsMono Nerd Font'),
   font_size = 12,
   color_scheme = 'Catppuccin Mocha',
   enable_wayland = false,
   automatically_reload_config = true,
}

local function build()
   local backdrops = safe.require('utils.backdrops')

   -- `scan_images_dir` shells out via `wezterm.glob`, which is only legal here in
   -- `wezterm.lua` during the initial config load -- see the note on the method.
   safe.call('backdrops:scan_images_dir', function()
      -- backdrops:set_images_dir(wezterm.home_dir .. '/Pictures/Wallpapers')
      backdrops:scan_images_dir():random()
   end)

   return safe.require('config'):init()
      :append(safe.require('config.appearance'))
      :append(safe.require('config.fonts'))
      :append(safe.require('config.general'))
      :append(safe.require('config.platform')).options
end

local ok, config = pcall(build)

if not ok then
   wezterm.log_error('config: build failed, falling back to a minimal config: ' .. tostring(config))
   return FALLBACK
end

return config
