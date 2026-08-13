local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Module setup runs first; per-field assignments later in this file override
-- module settings if a field is ever set in both places. links.lua owns
-- hyperlink_rules; mouse.lua owns mouse_bindings and mouse-related options.
require("links").setup(config)
require("mouse").setup(config)

local act = wezterm.action
local mux = wezterm.mux

-- Move panes between existing tabs. The Lua API has no native equivalent, so
-- both directions shell out to `wezterm cli split-pane --move-pane-id`, which
-- splits --pane-id and moves an existing pane into the new split.
local wezterm_bin = wezterm.executable_dir .. "/wezterm"

-- Pane cwd for picker labels: nil when unknown, $HOME abbreviated to ~.
local function pane_cwd(p)
  local url = p:get_current_working_dir() -- Url object or nil on this build
  local path = url and url.file_path
  if not path then return nil end
  if #path > 1 then path = path:gsub("/+$", "") end
  local home = wezterm.home_dir
  if path == home then return "~" end
  if path:sub(1, #home + 1) == home .. "/" then return "~" .. path:sub(#home + 1) end
  return path
end

-- "<ids>  <title>  <cwd>" with empty parts omitted; kept compact because
-- these labels feed the fuzzy matcher.
local function choice_label(ids, title, cwd)
  local parts = { ids }
  if title and title ~= "" then table.insert(parts, title) end
  if cwd then table.insert(parts, cwd) end
  return table.concat(parts, "  ")
end

local function move_pane_action(direction)
  local title = direction == "send" and "Send pane to tab" or "Bring pane here"
  return wezterm.action_callback(function(window, pane)
    local current_tab_id = pane:tab():tab_id()
    local choices = {}
    for _, mux_window in ipairs(mux.all_windows()) do
      local prefix = string.format("w%d", mux_window:window_id())
      local workspace = mux_window:get_workspace()
      if workspace ~= "default" then prefix = string.format("[%s] %s", workspace, prefix) end
      for _, tab in ipairs(mux_window:tabs()) do
        if tab:tab_id() ~= current_tab_id then
          if direction == "send" then
            local target = tab:active_pane()
            local label = tab:get_title()
            if label == nil or label == "" then label = target:get_title() end
            table.insert(choices, {
              id = tostring(target:pane_id()),
              label = choice_label(string.format("%s t%d", prefix, tab:tab_id()), label, pane_cwd(target)),
            })
          else
            for _, other in ipairs(tab:panes()) do
              table.insert(choices, {
                id = tostring(other:pane_id()),
                label = choice_label(
                  string.format("%s t%d p%d", prefix, tab:tab_id(), other:pane_id()),
                  other:get_title(),
                  pane_cwd(other)
                ),
              })
            end
          end
        end
      end
    end

    if #choices == 0 then
      if direction == "send" then
        local tab = pane:move_to_new_tab()
        tab:activate()
      else
        window:toast_notification("wezterm", "No other tab to bring a pane from", nil, 4000)
      end
      return
    end

    window:perform_action(
      act.InputSelector({
        title = title,
        choices = choices,
        fuzzy = true,
        fuzzy_description = title .. ": ",
        action = wezterm.action_callback(function(inner_window, inner_pane, id)
          if not id then return end
          local target_id, moved_id
          if direction == "send" then
            target_id, moved_id = id, tostring(inner_pane:pane_id())
          else
            target_id, moved_id = tostring(inner_pane:pane_id()), id
          end
          local ok, _, stderr = wezterm.run_child_process({
            wezterm_bin,
            "cli",
            "--no-auto-start",
            "split-pane",
            "--right",
            "--pane-id",
            target_id,
            "--move-pane-id",
            moved_id,
          })
          if ok then
            local moved = mux.get_pane(tonumber(moved_id))
            if moved then
              moved:activate()
              -- activate() focuses the pane and tab but is not documented to
              -- raise the OS window, so raise it for cross-window moves.
              local gui = moved:window():gui_window()
              if gui then gui:focus() end
            end
          else
            inner_window:toast_notification("wezterm", "Failed to move pane: " .. stderr, nil, 4000)
          end
        end),
      }),
      pane
    )
  end)
end

-- Break the current pane out into its own new tab (native API).
local break_pane_to_new_tab = wezterm.action_callback(function(_, pane)
  local tab = pane:move_to_new_tab()
  tab:activate()
end)

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config = {
  adjust_window_size_when_changing_font_size = false,
  audible_bell = "Disabled",
  check_for_updates = false,
  color_scheme = "Windows High Contrast (base16)", -- 'Windows NT (base16)'
  enable_csi_u_key_encoding = true,
  enable_scroll_bar = true,
  enable_tab_bar = true,
  exit_behavior = "Close",
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  font = wezterm.font("Server Mono"),
  -- config.font = wezterm.font('BlexMono Nerd Font Mono'),
  font_size = 22,
  force_reverse_video_cursor = true,
  hide_tab_bar_if_only_one_tab = true,
  max_fps = 120,
  native_macos_fullscreen_mode = true,
  pane_focus_follows_mouse = true,
  quit_when_all_windows_are_closed = false,
  scrollback_lines = 100000,
  unicode_version = 14,
  use_dead_keys = false,
  use_fancy_tab_bar = true,
  use_resize_increments = true,
  keys = {
    {
      action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 50 } }),
      key = "Enter",
      mods = "SUPER|SHIFT",
    },
    {
      action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 50 } }),
      key = "Enter",
      mods = "SUPER",
    },
    { action = wezterm.action.ToggleFullScreen, key = "f", mods = "ALT|CTRL" },
    { action = wezterm.action.CloseCurrentPane({ confirm = true }), key = "w", mods = "SUPER" },
    { action = wezterm.action.ShowLauncher, key = "l", mods = "ALT" },
    { action = move_pane_action("send"), key = "s", mods = "SUPER|SHIFT" },
    { action = move_pane_action("bring"), key = "b", mods = "SUPER|SHIFT" },
    { action = break_pane_to_new_tab, key = "t", mods = "SUPER|SHIFT" },
  },
  window_close_confirmation = "NeverPrompt",
  window_padding = { bottom = "0.1cell", left = "0.1cell", right = "0.1cell", top = "0.1cell" },
  window_frame = {
    border_bottom_color = "red",
    border_bottom_height = "0.1cell",
    border_left_color = "red",
    border_left_width = "0.1cell",
    border_right_color = "red",
    border_right_width = "0.1cell",
    border_top_color = "red",
    border_top_height = "0.1cell",
  },
}

return config
