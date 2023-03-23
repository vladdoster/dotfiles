-- vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
local W = require('wezterm')
return {
  adjust_window_size_when_changing_font_size=false,
  audible_bell='Disabled',
  check_for_updates=false,
  color_scheme='Macintosh (base16)',
  default_prog={'zsh'},
  enable_csi_u_key_encoding=true,
  enable_scroll_bar=true,
  enable_tab_bar=true,
  exit_behavior='Close',
  font=W.font('BlexMono Nerd Font Mono', { weight = 'Bold', italic = true }),
  font_size=18,
  force_reverse_video_cursor=true,
  hide_tab_bar_if_only_one_tab=true,
  native_macos_fullscreen_mode=true,
  quit_when_all_windows_are_closed=false,
  scrollback_lines=100000,
  show_update_window=true,
  unicode_version=14,
  use_dead_keys=false,
  use_fancy_tab_bar=true,
  window_close_confirmation='NeverPrompt',
  window_padding={left='0.1cell', right='0.1cell', top='0.1cell', bottom='0.1cell'},
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    {key = '|', mods = 'LEADER|SHIFT', action = W.action.SplitHorizontal { domain = 'CurrentPaneDomain' }},
    {key = '-',mods = 'LEADER',action = W.action.SplitVertical { domain = 'CurrentPaneDomain' }},
    {action=W.action.SplitPane {direction='Down', size={Percent=50}}, mods='SUPER|SHIFT', key='Enter'},
    {action=W.action.SplitPane {direction='Right', size={Percent=50}}, mods='SUPER', key='Enter'},
    {action=W.action.ToggleFullScreen, mods='ALT|CTRL', key='f'},
    {key='w', mods='SUPER', action=W.action.CloseCurrentPane {confirm=true}}
  },
  window_frame={
    border_left_width='0.1cell',
    border_right_width='0.1cell',
    border_bottom_height='0.1cell',
    border_top_height='0.1cell',
    border_left_color='red',
    border_right_color='red',
    border_bottom_color='red',
    border_top_color='red',
  },
}
