-- Window Highlight (highlight focused window)
-- Global settings
hs.window.highlight.ui.overlay = true
hs.window.highlight.ui.overlayColor = {0, 0, 0, 0.3}
hs.window.highlight.ui.isolateColor = {0, 0, 0, 0.9}
-- hs.window.highlight.ui.isolateColorInverted = {1,1,1,0.95}
hs.window.highlight.ui.frameWidth = 10
hs.window.highlight.ui.frameColor = {1,0.5,1,0.5}
hs.window.highlight.ui.frameColorInvert = {1,0.4,0,0.5}
-- hs.window.highlight.ui.flashDuration = 0
-- hs.window.highlight.ui.windowShownFlashColor = {0,1,0,0.8}
-- hs.window.highlight.ui.windowHiddenFlashColor = {1,0,0,0.8}
-- hs.window.highlight.ui.windowShownFlashColorInvert = {1,0,1,0.8}
-- hs.window.highlight.ui.windowHiddenFlashColorInvert = {0,1,1,0.8}
local module = {}
module.logger = hs.logger.new('windowHighlight.lua')
module.windowFilter = hs.window.filter.new():setOverrideFilter{
    visible = true,
    fullscreen = false,
    allowScreens = '-1,0',
    currentSpace = true
}
module.start = function()
    module.logger.i("starting window highlight")
    hs.window.highlight.start(nil, module.windowFilter)
    return module
end
module.stop = function()
    module.logger.i("Stopping Window Highlight")
    hs.window.highlight.stop()
    return module
end
return module
local drawBorder = require('ext.drawing').drawBorder
local winFilter  = require('hs.window.filter')
local cache  = {}
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
