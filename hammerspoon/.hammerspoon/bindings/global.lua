local module = {}
local grid = require('ext.grid')
local smartLaunchOrFocus = require('ext.application').smartLaunchOrFocus
local system = require('ext.system')
local window = require('ext.window')
local spacesv2= require('ext.working-spaces')
module.start = function()
    -- ultra bindings
    local ultra = {'ctrl', 'alt', 'cmd'}
    -- force paste (sometimes cmd + v is blocked)
    hs.hotkey.bind({'cmd', 'alt'}, 's', function() require('ext.working-spaces').openMissionControl() end)
    hs.hotkey.bind({'cmd', 'alt', 'shift'}, 'v', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
    hs.fnutils.each({ -- toggles
        {key='/', fn=system.toggleConsole},
        {key='g', fn=grid.toggleGrid},
        {key='l', fn=wm.cycleLayout},
        {key='r', fn=system.reloadHS}
    }, function(object) hs.hotkey.bind(ultra, object.key, object.fn) end)
    hs.fnutils.each({ -- apps
        {key='return', apps=config.apps.terms},
        {key='space', apps=config.apps.browsers},
        {key=',', apps={'System Preferences'}}
    }, function(object) hs.hotkey.bind(ultra, object.key, function() smartLaunchOrFocus(object.apps) end) end)
end
module.stop = function() end
return module
