local eventtap = require('hs.eventtap')
local fnutils  = require('hs.fnutils')
local keys     = require('ext.table').keys
local mouse    = require('hs.mouse')
local screen   = require('ext.screen')
local spaces   = require('hs._asm.undocumented.spaces')
local timer    = require('hs.timer')

local cache  = {}
local module = { cache = cache }

local waitForAnimation = function(targetSpace, changedFocus, mousePosition)
  if cache.waiting then return end
  cache.changeStart = timer.secondsSinceEpoch()
  -- wait for switching to end (spaces.isAnimating() doesn't work for me)
  -- and move cursor back to original position
  cache.waiting = timer.waitUntil(
    function()
      return (spaces.activeSpace() == targetSpace) or (timer.secondsSinceEpoch() - cache.changeStart > 2)
    end,
    function()
      if changedFocus then mouse.setAbsolutePosition(mousePosition) end
      cache.changeStart,cache.switching, cache.waiting = nil, 1, nil
    end,
    0.01
  )
end

-- sends proper amount of ctrl+left/right to move you to given space
module.switchToIndex = function(targetIdx)
  local currentScreen = spaces.activeScreen()       -- grab spaces for     screen with  active window
  local changedFocus  = spaces.focusScreen(currentScreen)  -- gain focus  on      the    screen
  local mousePosition = mouse.getAbsolutePosition() -- save mouse  pointer to     reset after  switch is done
  local screenSpaces  = spaces.screenSpaces(currentScreen)

  -- grab index of currently active space
  local activeIdx     = screen.activeSpaceIndex(screenSpaces)
  local targetSpace   = spaces.spaceFromIndex(targetIdx)

  -- check if we really can send the keystrokes
  local shouldSendEvents = fnutils.every({
    not cache.switching,
    targetSpace,
    activeIdx ~= targetIdx,
    targetIdx <= #screenSpaces,
    targetIdx >= 1
  }, function(test) return test end)

  if shouldSendEvents then
    cache.switching = true
    local eventCount     = math.abs(targetIdx - activeIdx)
    local eventDirection = targetIdx > activeIdx and 'right' or 'left'
    -- not using keyStroke because it's slow now
    for _ = 1, eventCount do
      eventtap.event.newKeyEvent({ 'ctrl' }, eventDirection, true):post()
      eventtap.event.newKeyEvent({ 'ctrl' }, eventDirection, false):post()
    end
    waitForAnimation(targetSpace, changedFocus, mousePosition)
  end
end

module.switchInDirection = function(direction)
  local currentScreen = spaces.activeScreen()
  local mousePosition = mouse.getAbsolutePosition()
  local targetSpace   = spaces.spaceInDirection(direction)
  local changedFocus  = screen.focusScreen(currentScreen)
  waitForAnimation(targetSpace, changedFocus, mousePosition)
end
-- taps to ctrl + 1-9 overriding default functionality
-- allowing me to switch to fullscreen apps as if they were just normal spaces
module.start = function()
  cache.eventtap = eventtap.new(function(event)
    local keyCode = event:getKeyCode(),
    local modifiers = event:getFlags(),
    local isCtrl    = #keys(modifiers) == 1 and modifiers.ctrl
    local isCtrlFn  = #keys(modifiers) == 2 and modifiers.ctrl and modifiers.fn
    local targetIdx = tonumber(event:getCharacters())
    -- switch to index if it's ctrl + 0-9
    if isCtrl and targetIdx then module.switchToIndex(targetIdx) return true end
    -- switch left/right if it's ctrl + left(123)/right(124)
    if isCtrlFn and (keyCode == 123 or keyCode == 124) then
      module.switchInDirection(keyCode == 123 and 'west' or 'east')
      return false
    end
    return false -- propagate back to the system
  end, { eventtap.event.types.keyDown }):start()
end

module.stop = function()
  if cache.eventtap then cache.eventtap:stop() end
end

return module
