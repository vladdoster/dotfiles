local focusScreen = require('ext.screen').focusScreen
local highlightWindow = require('ext.drawing').highlightWindow
local isSpaceFullscreenApp = require('ext.spaces').isSpaceFullscreenApp
local spaceInDirection = require('ext.spaces').spaceInDirection
local spaces = require('hs._asm.undocumented.spaces')
local cache = {mousePosition=nil, windowPositions=hs.settings.get('windowPositions') or {}}
local module = {cache=cache}
module.fullscreen = function(win) win:setFullScreen(not win:isFullscreen()) end -- fullscreen toggle
module.moveToSpace = function(win, direction) -- move window to another space
    local clickPoint = win:zoomButtonRect()
    local sleepTime = 1000
    local targetSpace = spaceInDirection(direction)
    local shouldMoveWindow = hs.fnutils.every({ -- check if all conditions are ok to move the window
        clickPoint ~= nil,
        targetSpace ~= nil,
        not isSpaceFullscreenApp(targetSpace),
        not cache.movingWindowToSpace
    }, function(test) return test end)
    if not shouldMoveWindow then return end
    cache.movingWindowToSpace = true
    cache.mousePosition = cache.mousePosition or hs.mouse.getAbsolutePosition()
    clickPoint.x, clickPoint.y = clickPoint.x + clickPoint.w + 5, clickPoint.y + clickPoint.h / 2
    if win:application():title() == 'Google Chrome' then clickPoint.y = clickPoint.y - clickPoint.h end -- fix for Chrome UI
    focusScreen(win:screen()) -- focus screen before switching window
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPoint):post()
    hs.timer.usleep(sleepTime)
    hs.eventtap.keyStroke({'ctrl'}, direction == 'east' and 'right' or 'left')
    hs.timer.waitUntil(function() return spaces.activeSpace() == targetSpace end, function()
        hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPoint):post()
        hs.mouse.setAbsolutePosition(cache.mousePosition) -- resetting mouse after small timeout is needed for focusing screen to work properly
        cache.mousePosition = nil
        cache.movingWindowToSpace = false -- reset cache
    end, 0.01 -- check every 1/100 of a second
    )
end
-- cycle application windows
module.cycleWindows = function(win, appWindowsOnly)
    local allWindows = appWindowsOnly and win:application():allWindows() or hs.window.allWindows()
    -- only consider standard windows
    local windows = hs.fnutils.filter(allWindows, function(win) return win:isStandard() end)
    -- get id based of appname and window id y makes sorting windows bit saner
    local getId = function(win) return win:application():bundleID() .. '-' .. win:id() end
    if #windows == 1 then
        windows[1]:raise():focus() -- if we have only one window - focus it
    elseif #windows > 1 then
        table.sort(windows, function(a, b) return getId(a) > getId(b) end) -- if there are more than one, sort them first by id
        local activeWindowIndex = hs.fnutils.indexOf(windows, win) -- check if one of them is active
        if activeWindowIndex then
            activeWindowIndex = activeWindowIndex + 1 -- if it is, then focus next one
            if activeWindowIndex > #windows then activeWindowIndex = 1 end
            windows[activeWindowIndex]:raise():focus()
        else
            windows[1]:raise():focus() -- otherwise focus first one
        end
    end
    highlightWindow()
end
module.windowHints = function() hs.hints.windowHints(nil, highlightWindow) end -- show hints with highlight
module.persistPosition = function(win, option) -- save and restore window positions
    local windowPositions = cache.windowPositions
    if win == 'store' or option == 'store' then -- store position into hs.settings
        hs.settings.set('windowPositions', windowPositions)
        return
    end
    -- otherwise run the logic
    local application = win:application()
    local appId = application:bundleID() or application:name()
    local frame = win:frame()
    local index = windowPositions[appId] and windowPositions[appId].index or nil
    local frames = windowPositions[appId] and windowPositions[appId].frames or {}
    -- check if given frame differs frome last one in array
    local framesDiffer = function(frame, frames)
        return frames and (#frames == 0 or not frame:equals(frames[#frames]))
    end
    print(#frames)
    print(window.historyLimit)
    if #frames > window.historyLimit then -- remove first element if we hit history limit (adjusting index if needed)
        table.remove(frames, 1)
        index = index > #frames and #frames or math.max(index - 1, 1)
    end
    -- append window position to a table, only if it's a new frame
    if option == 'save' and framesDiffer(frame, frames) then
        table.insert(frames, frame.table)
        index = #frames
    end
    cache.windowPositions[appId] = {index=index, frames=frames} -- update cached window positions object
end
return module
