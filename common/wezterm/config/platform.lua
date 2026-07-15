local platform = require('utils.platform')

---Platform-specific options, split out so the other `config` modules stay portable.
---@type table<PlatformType, Config>
local overrides = {
   linux = {
      -- Run under XWayland. Kept from the previous config -- flip to `true` to try
      -- the native Wayland backend.
      enable_wayland = false,
   },
   mac = {},
   windows = {},
}

---@type Config
return overrides[platform.os] or {}
