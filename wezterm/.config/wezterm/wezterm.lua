local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config = {
  adjust_window_size_when_changing_font_size=false,
  audible_bell='Disabled',
  check_for_updates=false,
  color_scheme='Macintosh (base16)',
  enable_csi_u_key_encoding=true,
  enable_scroll_bar=true,
  enable_tab_bar=true,
  exit_behavior='Close',
  font=wezterm.font('BlexMono Nerd Font Mono'),
  font_size=18,
  force_reverse_video_cursor=true,
  hide_tab_bar_if_only_one_tab=true,
  native_macos_fullscreen_mode=true,
  pane_focus_follows_mouse = true,
  quit_when_all_windows_are_closed=false,
  scrollback_lines=100000,
  show_update_window=true,
  unicode_version=14,
  use_dead_keys=false,
  use_fancy_tab_bar=true,
  use_resize_increments = true,
  keys = {
    {action=wezterm.action.SplitPane {direction='Down', size={Percent=50}}, mods='SUPER|SHIFT', key='Enter'},
    {action=wezterm.action.SplitPane {direction='Right', size={Percent=50}}, mods='SUPER', key='Enter'},
    {action=wezterm.action.ToggleFullScreen, mods='ALT|CTRL', key='f'},
    {key='w', mods='SUPER', action=wezterm.action.CloseCurrentPane {confirm=true}}
  },
  mouse_bindings = {
    { -- Click only selects text and doesn't open hyperlinks
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
    { -- CTRL-Click open hyperlinks
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
    },
  },
  window_close_confirmation='NeverPrompt',
  window_padding={left='0.1cell', right='0.1cell', top='0.1cell', bottom='0.1cell'},
  window_frame={
    border_bottom_color='red',
    border_bottom_height='0.1cell',
    border_left_color='red',
    border_left_width='0.1cell',
    border_right_color='red',
    border_right_width='0.1cell',
    border_top_color='red',
    border_top_height='0.1cell',
  },
}

return config
