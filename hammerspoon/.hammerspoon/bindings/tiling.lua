local module = {}
local wm  = wm.cache.wm
local move = function(dir)
  local win = hs.window.frontmostWindow()
  if wm.isFloating(win) then
    local directions = {
      west  = 'left',
      south = 'down',
      north = 'up',
      east  = 'right'
    }
    hs.grid['pushWindow' .. capitalize(directions[dir])](win)
  else
    wm.swapInDirection(win, dir)
  end
  
end
local throw = function(dir)
  local win = hs.window.frontmostWindow()
  if wm.isFloating(win) then
    hs.grid['pushWindow' .. capitalize(dir) .. 'Screen'](win)
  else
    wm.throwToScreenUsingSpaces(win, dir)
  end
  
end
local resize = function(resize)
  local win = hs.window.frontmostWindow()
  if wm.isFloating(win) then
    hs.grid['resizeWindow' .. capitalize(resize)](win)
    
  else
    wm.resizeLayout(resize)
  end
end
module.start = function()
  local bind = function(key, fn)
    hs.hotkey.bind({ 'ctrl', 'shift' }, key, fn, nil, fn)
  end
  -- move window
  hs.fnutils.each({
    { key = 'h', dir = "west"  },
    { key = 'j', dir = "south" },
    { key = 'k', dir = "north" },
    { key = 'l', dir = "east"  },
  }, function(obj)
    bind(obj.key, function() move(obj.dir) end)
  end)
  -- throw between screens
  hs.fnutils.each({
    { key = ']', dir = 'prev' },
    { key = '[', dir = 'next' },
  }, function(obj)
    bind(obj.key, function() throw(obj.dir) end)
  end)
  -- resize (floating only)
  hs.fnutils.each({
    { key = ',', dir = 'thinner' },
    { key = '.', dir = 'wider'   },
    { key = '-', dir = 'shorter' },
    { key = '=', dir = 'taller'  }
  }, function(obj)
    bind(obj.key, function() resize(obj.dir) end)
  end)
  -- toggle [f]loat
  bind('f', function()
    local win = hs.window.frontmostWindow()
    if not win then return end
    wm.toggleFloat(win)
    if wm.isFloating(win) then
      hs.grid.center(win)
    end
    
  end)
  -- [r]eset
  bind('r', wm.reset)
  -- re[t]ile
  bind('t', wm.tile)
  -- [e]qualize
  bind('e', wm.equalizeLayout)
  -- [c]enter window
  bind('c', function()
    local win = hs.window.frontmostWindow()
    if not wm.isFloating(win) then
      wm.toggleFloat(win)
    end
    -- win:centerOnScreen()
    hs.grid.center(win)
    
  end)
  -- toggle [z]oom window
  bind('z', function()
    local win = hs.window.frontmostWindow()
    if not wm.isFloating(win) then
      wm.toggleFloat(win)
      hs.grid.maximizeWindow(win)
    else
      wm.toggleFloat(win)
    end
    
  end)
  -- throw window to space (and move)
  for n = 0, 9 do
    local idx = tostring(n)
    -- important: use this with onKeyReleased, not onKeyPressed
    hs.hotkey.bind({ 'ctrl', 'shift' }, idx, nil, function()
      local win = hs.window.focusedWindow()
      -- if there's no focused window, just move to that space
      if not win then
        hs.eventtap.keyStroke({ 'ctrl' }, idx)
        return
      end
      local isFloating = wm.isFloating(win)
      local success    = wm.throwToSpace(win, n)
      -- if window switched space, then follow it (ctrl + 0..9) and focus
      if success then
        hs.eventtap.keyStroke({ 'ctrl' }, idx)
        -- retile and re-highlight window after we switch space
        hs.timer.doAfter(0.05, function()
          if not isFloating then wm.tile() end
          highlightWindow(win)
        end)
      end
    end)
  end
end
module.stop = function()
end
return module
