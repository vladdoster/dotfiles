local module = {}
local log = hs.logger.new("keymaps[wm]", "debug")
local wm = windowMgmt.cache.wm
local move = function(dir)
  local win = hs.window.frontmostWindow()
  if windowMgmt.isFloating(win) then
    local directions = {
      west = "left",
      south = "down",
      north = "up",
      east = "right",
    }
    hs.grid["pushWindow" .. wm.capitalize(directions[dir])](win)
  else
    windowMgmt.swapInDirection(win, dir)
  end
end
local throw = function(dir)
  local win = hs.window.frontmostWindow()
  if windowMgmt.isFloating(win) then
    hs.grid["pushWindow" .. wm.capitalize(dir) .. "Screen"](win)
  else
    windowMgmt.throwToScreenUsingSpaces(win, dir)
  end
end
local resize = function(resize)
  local win = hs.window.frontmostWindow()
  if windowMgmt.isFloating(win) then
    hs.grid["resizeWindow" .. wm.capitalize(resize)](win)
  else
    windowMgmt.resizeLayout(resize)
  end
end
module.start = function()
  local bind = function(key, fn)
    hs.hotkey.bind({ "ctrl", "shift" }, key, fn, nil, fn)
  end
  -- move window
  hs.fnutils.each({
    { key = "h", dir = "west" },
    { key = "j", dir = "south" },
    { key = "k", dir = "north" },
    { key = "l", dir = "east" },
  }, function(obj)
    bind(obj.key, function()
      move(obj.dir)
    end)
  end)
  -- throw between screens
  hs.fnutils.each({
    { key = "]", dir = "prev" },
    { key = "[", dir = "next" },
  }, function(obj)
    bind(obj.key, function()
      throw(obj.dir)
    end)
  end)
  -- resize (floating only)
  hs.fnutils.each({
    { key = ",", dir = "thinner" },
    { key = ".", dir = "wider" },
    { key = "-", dir = "shorter" },
    { key = "=", dir = "taller" },
  }, function(obj)
    bind(obj.key, function()
      resize(obj.dir)
    end)
  end)
  -- toggle [f]loat
  bind("f", function()
    local win = hs.window.frontmostWindow()
    if not win then
      return
    end
    windowMgmt.toggleFloat(win)
    if windowMgmt.isFloating(win) then
      hs.grid.center(win)
    end
  end)
  -- [r]eset
  bind("r", windowMgmt.reset)
  -- re[t]ile
  bind("t", windowMgmt.tile)
  -- [e]qualize
  bind("e", windowMgmt.equalizeLayout)
  bind("k", require("utils.quake").toggle())
  -- [c]enter window
  bind("c", function()
    local win = hs.window.frontmostWindow()
    if not windowMgmt.isFloating(win) then
      windowMgmt.toggleFloat(win)
    end
    -- win:centerOnScreen()
    hs.grid.center(win)
  end)
  -- toggle [z]oom window
  bind("z", function()
    local win = hs.window.frontmostWindow()
    if not windowMgmt.isFloating(win) then
      windowMgmt.toggleFloat(win)
      hs.grid.maximizeWindow(win)
    else
      windowMgmt.toggleFloat(win)
    end
  end)
  -- throw window to space (and move)
  for n = 0, 9 do
    local idx = tostring(n)
    hs.hotkey.bind({ "ctrl", "shift" }, idx, nil, function()
      local win = hs.window.focusedWindow()
      -- if there's no focused window, just move to that space
      if not win then
        hs.eventtap.keyStroke({ "ctrl" }, idx)
        return
      end
      local isFloating = windowMgmt.isFloating(win)
      local success = windowMgmt.throwToSpace(win, n)
      -- if window switched space, then follow it (ctrl + 0..9) and focus
      if success then
        hs.timer.doAfter(0.05, function()
          t = dofile("transition.lua")
          t.transition(n, false) -- change to the specified spaceID
          if not isFloating then
            windowMgmt.tile()
          end
          -- t.reset() -- reset to a (presumably) safe state if something goes wrong
        end)
      end
    end)
  end
end
module.stop = function() end
return module
