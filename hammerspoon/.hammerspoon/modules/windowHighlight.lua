-- Window Highlight (highlight focused window)
-- Global settings
local module = {}
local logger = hs.logger.new('windowHighlight', 'debug')
module.windowFilter = hs.window.filter.new():setOverrideFilter{
    visible=true,
    fullscreen=false,
    allowScreens='-1,0',
    currentSpace=true
}
local drawBorder = require('ext.drawing').drawBorder
local winFilter = require('hs.window.filter')
local cache = {}
local module = {cache=cache}
module.start = function()
    module.logger.i('starting window highlight')
    cache.filter = winFilter.new(nil)
    cache.filter.forceRefreshOnSpaceChange = true
    cache.filter:subscribe({
        winFilter.windowCreated,
        winFilter.windowDestroyed,
        winFilter.windowFocused,
        winFilter.windowFullscreened,
        winFilter.windowHidden,
        winFilter.windowMinimized,
        winFilter.windowMoved,
        winFilter.windowUnfocused,
        winFilter.windowUnfullscreened,
        winFilter.windowUnhidden,
        winFilter.windowUnminimized
    }, drawBorder)
    return module
end
module.stop = function()
    cache.filter:unsubscribe(drawBorder)
    module.logger.i('stopping window highlight')
    return module
end
