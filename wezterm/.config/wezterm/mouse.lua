local wezterm = require('wezterm')
-- local keys = require("keys")

local M = {}

---@param config Config
function M.setup(config)
  config.alternate_buffer_wheel_scroll_speed = 1
  config.bypass_mouse_reporting_modifiers = 'CTRL'
  config.mouse_bindings = {
    -- Don't open links without modifier
    {
      event = { Up = { streak = 1, button = 'Left' } },
      action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('ClipboardAndPrimarySelection'),
    },
  }
end

return M
