local fnutils, layouts = require('hs.fnutils'), {}
-- FULLSCREEN
layouts['fullscreen'] = function(windows) fnutils.each(windows, function(window) window:maximize() end) end
-- MAIN VERTICAL
layouts['main-vertical'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    if index == 1 then
      frame.w = frame.w / 2
    else
      frame.x = frame.x + frame.w / 2
      frame.w = frame.w / 2
      frame.h = frame.h / (wincount - 1)
      frame.y = frame.y + frame.h * (index - 2)
    end
    win:setframe(frame)
  end
end
-- MAIN HORIZONTAL
layouts['main-horizontal'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    if index == 1 then
      frame.h = frame.h / 2
    else
      frame.y = frame.y + frame.h / 2
      frame.h = frame.h / 2
      frame.w = frame.w / (wincount - 1)
      frame.x = frame.x + frame.w * (index - 2)
    end
    win:setframe(frame)
  end
end
-- COLUMNS
layouts['columns'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    frame.w = frame.w / wincount
    frame.x = frame.x + (index - 1) * frame.w
    frame.y = 0
    win:setframe(frame)
  end
end
layouts['rows'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    frame.h = frame.h / wincount
    frame.y = frame.y + (index - 1) * frame.h
    frame.x = 0
    win:setframe(frame)
  end
end
-- FIB-VERTICAL
layouts['fib-vertical'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  local width
  local height
  local x = 0
  local y = 0
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    if index == 1 then
      height = frame.h
      width = frame.w / 2
    elseif index % 2 == 0 then
      if index ~= wincount then height = height / 2 end
      x = x + width
    else
      if index ~= wincount then width = width / 2 end
      y = y + height
    end
    frame.x = frame.x + x
    frame.y = frame.y + y
    frame.w = width
    frame.h = height
    win:setframe(frame)
  end
end
-- FIB-HORIZONTAL
layouts['fib-horizontal'] = function(windows)
  local wincount = #windows
  if wincount == 1 then return layouts['fullscreen'](windows) end
  local width
  local height
  local x = 0
  local y = 0
  for index, win in pairs(windows) do
    local frame = win:screen():frame()
    if index == 1 then
      height = frame.h / 2
      width = frame.w
    elseif index % 2 == 0 then
      if index ~= wincount then width = width / 2 end
      y = y + height
    else
      if index ~= wincount then height = height / 2 end
      x = x + width
    end
    frame.x = frame.x + x
    frame.y = frame.y + y
    frame.w = width
    frame.h = height
    win:setframe(frame)
  end
end
return layouts
