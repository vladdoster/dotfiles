local activeScreen = require('ext.screen').activeScreen
local activeSpaceIndex = require('ext.spaces').activeSpaceIndex
local focusScreen = require('ext.screen').focusScreen
local keys = require('ext.table').keys
local screenSpaces = require('ext.spaces').screenSpaces
local spaceFromIndex = require('ext.spaces').spaceFromIndex
local spaceInDirection = require('ext.spaces').spaceInDirection
-- local spaces = require('hs.spaces')
local spaces = require('hs._asm.undocumented.spaces')
local cache = {}
local module = {cache = cache}
local waitForSpaceAnimation = function(targetSpace, changedFocus, mousePosition)
    if cache.waiting then return end
    cache.changeStart = hs.timer.secondsSinceEpoch()
    -- wait for switching to end (spaces.isAnimating() doesn't work for me)
    -- and move cursor back to original position
    cache.waiting = hs.timer.waitUntil(function()
        return (spaces.activeSpace() == targetSpace) or (hs.timer.secondsSinceEpoch() - cache.changeStart > 2)
    end, function()
        if changedFocus then hs.mouse.setAbsolutePosition(mousePosition) end
        cache.changeStart = nil
        cache.switching = false
        cache.waiting = nil
    end, 0.01)
end
-- sends proper amount of ctrl+left/right to move you to given space, even if it's fullscreen app!
module.switchToIndex = function(targetIdx)
    local mousePosition = hs.mouse.absolutePosition() -- save mouse pointer to reset after switch is done
    local currentScreen = activeScreen() -- grab spaces for screen with active window
    local currentScreenSpaces = screenSpaces(currentScreen) -- gain focus on the screen
    local changedFocus = focusScreen(currentScreen)
    local activeIdx = activeSpaceIndex(currentScreenSpaces) -- grab index of currently active space
    local targetSpace = spaceFromIndex(targetIdx)
    local shouldSendEvents = hs.fnutils.every({ -- check if we really can send the keystrokes
        not cache.switching, targetSpace, activeIdx ~= targetIdx, targetIdx <= #currentScreenSpaces, targetIdx >= 1
    }, function(test) return test end)
    if shouldSendEvents then
        cache.switching = true
        local eventCount = math.abs(targetIdx - activeIdx)
        local eventDirection = targetIdx > activeIdx and 'right' or 'left'
        for _ = 1, eventCount do
            -- not using keyStroke because it's slow now
            hs.eventtap.event.newKeyEvent({'ctrl'}, eventDirection, true):post()
            hs.eventtap.event.newKeyEvent({'ctrl'}, eventDirection, false):post()
        end
        waitForSpaceAnimation(targetSpace, changedFocus, mousePosition)
    end
end
module.switchInDirection = function(direction)
    local currentScreen = activeScreen()
    local mousePosition = hs.mouse.absolutePosition()
    local targetSpace = spaceInDirection(direction)
    local changedFocus = focusScreen(currentScreen) -- gain focus on the screen
    waitForSpaceAnimation(targetSpace, changedFocus, mousePosition)
end
-- taps to ctrl + 1-9 overriding default functionality
-- allowing me to switch to fullscreen apps as if they were just normal spaces
module.start = function()
    cache.eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local keyCode = event:getKeyCode()
        local modifiers = event:getFlags()
        local isCtrl = #keys(modifiers) == 1 and modifiers.ctrl
        local isCtrlFn = #keys(modifiers) == 2 and modifiers.ctrl and modifiers.fn
        local targetIdx = tonumber(event:getCharacters())
        if isCtrl and targetIdx then -- switch to index if it's ctrl + 0-9
            module.switchToIndex(targetIdx)
            return true
        end
        if isCtrlFn and (keyCode == 123 or keyCode == 124) then -- switch left/right if it's ctrl + left(123)/right(124)
            module.switchInDirection(keyCode == 123 and 'west' or 'east')
            return false
        end
        return false -- propagate everything else back to the system
    end):start()
end
module.stop = function() if cache.eventtap then cache.eventtap:stop() end end
return module
