local forceFocus = require('ext.window').forceFocus
local highlightWindow = require('ext.drawing').highlightWindow
local log = hs.logger.new('application', 'debug')
local template = require('ext.template')
local cache = {launchTimer=nil}
local module = {cache=cache}
module.activateFrontmost = function() -- activate frontmost window if exists
    local frontmostWindow = hs.window.frontmostWindow()
    if frontmostWindow then frontmostWindow:raise():focus() end
end
module.forceLaunchOrFocus = function(appName) -- force application launch or focus
    local appInstance = hs.application.get(appName)
    local isRunning = appInstance and appInstance:isRunning()
    local focusTimeout = isRunning and 0.05 or 1.5
    hs.application.launchOrFocus(appName) -- first focus/launch with hammerspoon
    if cache.launchTimer then cache.launchTimer:stop() end -- clear timer if exists
    -- wait for window to appear and try hard to show the window
    cache.launchTimer = hs.timer.doAfter(focusTimeout, function()
        local frontmostApp = hs.application.frontmostApplication()
        local frontmostWindows = hs.fnutils.filter(frontmostApp:allWindows(), function(win)
            return win:isStandard()
        end)
        if frontmostApp:title() ~= appName then -- break if this app is not frontmost (when/why?)
            log.d('--- expected app in front: ' .. appName .. ' got: ' .. frontmostApp:title())
            return
        end
        if #frontmostWindows == 0 then
            if appName == 'Hyper' then
                hs.eventtap.keyStroke({'cmd'}, 'n') -- otherwise some other Hyper window gets focused
            elseif frontmostApp:findMenuItem({'Window', appName}) then
                -- check if there's app name in window menu (Calendar, Messages, etc...)
                -- select it, usually moves to space with this window
                frontmostApp:selectMenuItem({'Window', appName})
            else
                hs.eventtap.keyStroke({'cmd'}, 'n') -- otherwise send cmd-n to create new window
            end
        end
    end)
end
module.smartLaunchOrFocus = function(launchApps) -- smart app launch or focus or cycle windows
    local frontmostWindow = hs.window.frontmostWindow()
    local runningWindows = {}
    launchApps = type(launchApps) == 'table' and launchApps or {launchApps}
    -- filter running applications by apps array
    local runningApps = hs.fnutils.map(launchApps, function(launchApp) return hs.application.get(launchApp) end)
    hs.fnutils.each(runningApps, function(runningApp) -- create table of sorted windows per application
        local standardWindows = hs.fnutils.filter(runningApp:allWindows(), function(win) return win:isStandard() end)
        table.sort(standardWindows, function(a, b) return a:id() > b:id() end) -- sort by id, so windows don't jump randomly every time
        hs.fnutils.concat(runningWindows, standardWindows) -- concat with all running windows
    end)
    if #runningApps == 0 then
        module.forceLaunchOrFocus(launchApps[1]) -- if no apps are running then launch first one in list
    elseif #runningWindows == 0 then
        module.forceLaunchOrFocus(runningApps[1]:name()) -- if some apps are running, but no windows - force create one
    else
        -- check if one of windows is already focused
        local currentIndex = hs.fnutils.indexOf(runningWindows, frontmostWindow)
        if not currentIndex then
            forceFocus(runningWindows[1]) -- if none of them is selected focus the first one
        else
            -- otherwise cycle through all the windows
            local newIndex = currentIndex + 1
            if newIndex > #runningWindows then newIndex = 1 end
            forceFocus(runningWindows[newIndex])
        end
        highlightWindow()
    end
end
-- count all windows on all spaces
module.allWindowsCount = function(appName)
    local _, result = hs.applescript.applescript(template([[
    tell application "{APP_NAME}"
      count every window where visible is true
    end tell
  ]], {APP_NAME=appName}))
    return tonumber(result) or 0
end
return module
