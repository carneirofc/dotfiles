-- The color scheme in use, shared by the config and the backdrops.
-- `colors.matugen` is generated from the wallpaper on Linux (linux/matugen) and
-- is absent elsewhere, so fall back to the hand-written scheme quietly.
local ok, matugen = pcall(require, 'colors.matugen')
if ok then
   return matugen
end
return require('colors.custom')
