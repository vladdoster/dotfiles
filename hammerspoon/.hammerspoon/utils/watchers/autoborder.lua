-- return module
local drawBorder = require('ext.drawing').drawBorder

local cache = {}
local module = {cache=cache}

module.start = function()
    cache.filter = hs.window.filter.new(nil)
    cache.filter.forceRefreshOnSpaceChange = true
    cache.filter:subscribe({
        hs.window.filter.windowCreated,
        hs.window.filter.windowDestroyed,
        hs.window.filter.windowFocused,
        hs.window.filter.windowMoved,
        hs.window.filter.windowUnfocused
    }, drawBorder)
end

module.stop = function() cache.filter:unsubscribe(drawBorder) end

return module
