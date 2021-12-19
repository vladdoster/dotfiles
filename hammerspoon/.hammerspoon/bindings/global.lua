local module = {}

local grid = require('ext.grid')
local smartLaunchOrFocus = require('ext.application').smartLaunchOrFocus
local system = require('ext.system')
local window = require('ext.window')

module.start = function()
    -- ultra bindings
    local ultra = {'ctrl', 'alt', 'cmd'}

    -- ctrl + tab as alternative to cmd + tab
    hs.hotkey.bind({'ctrl'}, 'tab', window.windowHints)

    -- force paste (sometimes cmd + v is blocked)
    hs.hotkey.bind({'cmd', 'alt', 'shift'}, 'v', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

    -- toggles
    hs.fnutils.each({
        {key='/', fn=system.toggleConsole},
        {key='g', fn=grid.toggleGrid},
        {key='l', fn=wm.cycleLayout},
        {key='r', fn=system.reloadHS}
    }, function(object) hs.hotkey.bind(ultra, object.key, object.fn) end)

    -- apps
    hs.fnutils.each({
        {key='return', apps=config.apps.terms},
        {key='space', apps=config.apps.browsers},
        {key=',', apps={'System Preferences'}}
    }, function(object) hs.hotkey.bind(ultra, object.key, function() smartLaunchOrFocus(object.apps) end) end)
end

module.stop = function() end

return module
