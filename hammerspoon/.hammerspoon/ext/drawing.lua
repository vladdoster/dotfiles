local cache = {borderDrawings={}, borderDrawingFadeOuts={}}
local module = {cache=cache}
module.getHighlightWindowColor = function() return {red=1, green=0, blue=0, alpha=1.0} end
module.drawBorder = function()
    local focusedWindow = hs.window.focusedWindow()
    if not focusedWindow or focusedWindow:role() ~= 'AXWindow' then
        if cache.borderCanvas then cache.borderCanvas:hide(0.5) end
        return
    end
    local alpha = 1.0
    local borderWidth = 5
    local distance = 3
    local roundRadius = 15.0
    local isFullScreen = focusedWindow:isFullScreen()
    local frame = focusedWindow:frame()
    if not cache.borderCanvas then
        cache.borderCanvas = hs.canvas.new({x=0, y=0, w=0, h=0}):level(hs.canvas.windowLevels.overlay):behavior({
            hs.canvas.windowBehaviors.transient,
            hs.canvas.windowBehaviors.moveToActiveSpace
        }):alpha(alpha)
    end
    if isFullScreen then
        cache.borderCanvas:frame(frame)
    else
        cache.borderCanvas:frame({
            x=frame.x - distance / 2,
            y=frame.y - distance / 2,
            w=frame.w + distance,
            h=frame.h + distance
        })
    end
    cache.borderCanvas[1] = {
        type='rectangle',
        action='stroke',
        strokeColor=module.getHighlightWindowColor(),
        strokeWidth=borderWidth,
        roundedRectRadii={xRadius=roundRadius, yRadius=roundRadius}
    }
    cache.borderCanvas:show()
end
module.highlightWindow = function(win)
    if config.window.highlightBorder then module.drawBorder(0.5) end
    if config.window.highlightMouse then
        local focusedWindow = win or hs.window.focusedWindow()
        if not focusedWindow or focusedWindow:role() ~= 'AXWindow' then return end
        local frameCenter = hs.geometry.getcenter(focusedWindow:frame())
        -- hs.mouse.AbsolutePosition(frameCenter)
    end
end
return module
