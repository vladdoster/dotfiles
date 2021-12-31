local drawBorder = require('ext.drawing').drawBorder
local winFilter = require('hs.window.filter')
local cache = {}
local module = {cache=cache}
module.start = function()
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
        winFilter.windowUnminimized,
    }, drawBorder)
end
module.stop = function() cache.filter:unsubscribe(drawBorder) end
return module
