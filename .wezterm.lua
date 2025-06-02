local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config start
config.font_size = 13
config.font = wezterm.font 'RobotoMono Nerd Font Mono'

config.enable_tab_bar = false

return config
