local safe = require('utils.safe')

local gpu_adapters = safe.require('utils.gpu-adapter')
local backdrops = safe.require('utils.backdrops')
local colors = safe.require('colors.custom')

-- `enumerate_gpus` talks to the GPU drivers and `initial_options` touches the filesystem,
-- so both are guarded: a failure here costs an option, not the whole config.
local preferred_adapter = safe.call('gpu-adapter:pick_best', function()
   return gpu_adapters:pick_best()
   -- Swap to the line below to pin the Intel iGPU and keep the dGPU asleep on battery
   -- return gpu_adapters:pick_manual('Vulkan', 'IntegratedGpu')
end)

local background = safe.call('backdrops:initial_options', function()
   -- pass in `no_img = true` if you want wezterm to start with focus mode on (no bg images)
   return backdrops:initial_options({ no_img = false })
end)

---@type Config
return {
   max_fps = 120,
   front_end = 'WebGpu', ---@type 'WebGpu' | 'OpenGL' | 'Software'
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = preferred_adapter,
   underline_thickness = '1.5pt',

   -- cursor
   animation_fps = 120,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_rate = 650,

   -- color scheme
   colors = colors,

   background = background,
   window_background_opacity = 0.9,

   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   use_fancy_tab_bar = false,
   tab_max_width = 23,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,

   -- command palette
   command_palette_fg_color = '#b4befe',
   command_palette_bg_color = '#11111b',
   command_palette_font_size = 12,
   command_palette_rows = 25,

   -- window
   window_padding = {
      left = 12,
      right = 12,
      top = 8,
      bottom = 8,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
   },
   inactive_pane_hsb = {
      saturation = 1,
      brightness = 1,
   },

   visual_bell = {
      fade_in_function = 'EaseIn',
      fade_in_duration_ms = 250,
      fade_out_function = 'EaseOut',
      fade_out_duration_ms = 250,
      target = 'CursorColor',
   },
}
