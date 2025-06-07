local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config start
config.font_size = 12
config.font = wezterm.font 'RobotoMono Nerd Font Mono'

config.enable_tab_bar = false

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5
}

config.default_prog = {'/usr/bin/tmux'}

return config
