-- vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
local wezterm = require('wezterm')
return {
  adjust_window_size_when_changing_font_size=false,
  audible_bell='Disabled',
  check_for_updates=false,
  color_scheme='SpaceGray',
  default_prog={'zsh'},
  enable_csi_u_key_encoding=true,
  enable_scroll_bar=true,
  enable_tab_bar=true,
  exit_behavior='Close',
  font_size=18,
  force_reverse_video_cursor=true,
  hide_tab_bar_if_only_one_tab=true,
  scrollback_lines=100000,
  show_update_window=true,
  unicode_version=14,
  use_dead_keys=false,
  use_fancy_tab_bar=true,
  window_close_confirmation='NeverPrompt',
  color_scheme='Macintosh (base16)',
  font=wezterm.font {
    family='BlexMono Nerd Font Mono',
    harfbuzz_features={'cv29', 'cv30', 'ss01', 'ss03', 'ss06', 'ss07', 'ss09'}
  },
  leader={key='a', mods='CTRL'},
  keys={
    {action=wezterm.action.SplitPane {direction='Down', size={Percent=50}}, mods='SUPER|SHIFT', key='Enter'},
    {action=wezterm.action.SplitPane {direction='Right', size={Percent=50}}, mods='SUPER', key='Enter'},
    {action=wezterm.action.ToggleFullScreen, mods='ALT|CTRL', key='f'},
    {key='w', mods='SUPER', action=wezterm.action.CloseCurrentPane {confirm=true}}
  },
  window_frame={
    border_left_width='0.1cell',
    border_right_width='0.1cell',
    border_bottom_height='0.1cell',
    border_top_height='0.1cell',
    border_left_color='red',
    border_right_color='red',
    border_bottom_color='red',
    border_top_color='red'
  },
  window_padding={left='0.1cell', right='0.1cell', top='0.1cell', bottom='0.1cell'},
  window_padding={bottom=0, left=0, right=0, top=0}
}
