local highlightWindow = require('ext.drawing').highlightWindow
local capitalize = require('ext.utils').capitalize
local module = {}
local hhtwm = wm.cache.hhtwm
local move = function(dir)
    local win = hs.window.frontmostWindow()
    if hhtwm.isFloating(win) then
        local directions = {west='left', south='down', north='up', east='right'}
        hs.grid['pushWindow' .. capitalize(directions[dir])](win)
    else
        hhtwm.swapInDirection(win, dir)
    end
    highlightWindow()
end
local throw = function(dir)
    local win = hs.window.frontmostWindow()
    if hhtwm.isFloating(win) then
        hs.grid['pushWindow' .. capitalize(dir) .. 'Screen'](win)
    else
        hhtwm.throwToScreenUsingSpaces(win, dir)
    end
    highlightWindow()
end
local resize = function(resize)
    local win = hs.window.frontmostWindow()
    if hhtwm.isFloating(win) then
        hs.grid['resizeWindow' .. capitalize(resize)](win)
        highlightWindow()
    else
        hhtwm.resizeLayout(resize)
    end
end
module.start = function()
    local bind = function(key, fn) hs.hotkey.bind({'ctrl', 'shift'}, key, fn, nil, fn) end
    -- move window
    hs.fnutils.each({
        {key='h', dir='west'},
        {key='j', dir='south'},
        {key='k', dir='north'},
        {key='l', dir='east'}
    }, function(obj) bind(obj.key, function() move(obj.dir) end) end)
    -- throw between screens
    hs.fnutils.each({{key=']', dir='prev'}, {key='[', dir='next'}},
                    function(obj) bind(obj.key, function() throw(obj.dir) end) end)
    hs.fnutils.each({ -- resize (floating only)
        {key=',', dir='thinner'},
        {key='.', dir='wider'},
        {key='-', dir='shorter'},
        {key='=', dir='taller'}
    }, function(obj) bind(obj.key, function() resize(obj.dir) end) end)
    bind('f', function() -- toggle [f]loat
        local win = hs.window.frontmostWindow()
        if not win then return end
        hhtwm.toggleFloat(win)
        if hhtwm.isFloating(win) then hs.grid.center(win) end
        highlightWindow()
    end)
    bind('r', hhtwm.reset) -- [r]eset
    bind('t', hhtwm.tile) -- re[t]ile
    bind('e', hhtwm.equalizeLayout) -- [e]qualize
    bind('c', function() -- [c]enter window
        local win = hs.window.frontmostWindow()
        if not hhtwm.isFloating(win) then hhtwm.toggleFloat(win) end
        hs.grid.center(win) -- win:centerOnScreen()
        highlightWindow()
    end)
    bind('z', function() -- toggle [z]oom window
        local win = hs.window.frontmostWindow()
        if not hhtwm.isFloating(win) then
            hhtwm.toggleFloat(win)
            hs.grid.maximizeWindow(win)
        else
            hhtwm.toggleFloat(win)
        end
        highlightWindow()
    end)
    for n = 0, 9 do -- throw window to space (and move)
        local idx = tostring(n)
        -- important: use this with onKeyReleased, not onKeyPressed
        hs.hotkey.bind({'ctrl', 'shift'}, idx, nil, function()
            local win = hs.window.focusedWindow()
            -- if there's no focused window, just move to that space
            if not win then
                hs.eventtap.keyStroke({'ctrl'}, idx)
                return
            end
            local isFloating = hhtwm.isFloating(win)
            local success = hhtwm.throwToSpace(win, n)
            if success then -- if window switched space, then follow it (ctrl + 0..9) and focus
                hs.eventtap.keyStroke({'ctrl'}, idx)
                hs.timer.doAfter(0.05, function() -- retile and re-highlight window after we switch space
                    if not isFloating then hhtwm.tile() end
                    highlightWindow(win)
                end)
            end
        end)
    end
end
module.stop = function() end
return module
