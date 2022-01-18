-- hhtwm - hackable hammerspoon tiling wm
local createLayouts = require('hhtwm.layouts')
local spaces = require('hs._asm.undocumented.spaces')
local cache = {spaces={}, layouts={}, floating={}, layoutOptions={}}
local module = {cache=cache}
local layouts = createLayouts(module)
local log = hs.logger.new('hhtwm', 'debug')
local SWAP_BETWEEN_SCREENS = false
local getDefaultLayoutOptions = function() return {mainPaneRatio=1.0} end
local capitalize = function(str) return str:gsub('^%l', string.upper) end
local ternary = function(cond, ifTrue, ifFalse)
    if cond then
        return ifTrue
    else
        return ifFalse
    end
end
local ensureCacheSpaces =
    function(spaceId) if spaceId and not cache.spaces[spaceId] then cache.spaces[spaceId] = {} end end
local getCurrentSpacesIds = function() return spaces.query(spaces.masks.currentSpaces) end
local getSpaceId = function(win)
    local spaceId
    win = win or hs.window.frontmostWindow()
    if win ~= nil and win:spaces() ~= nil and #win:spaces() > 0 then spaceId = win:spaces()[1] end
    return spaceId or spaces.activeSpace()
end
local getSpacesIdsTable = function()
    local spacesLayout = spaces.layout()
    local spacesIds = {}
    hs.fnutils.each(hs.screen.allScreens(), function(screen)
        local spaceUUID = screen:spacesUUID()
        local userSpaces = hs.fnutils.filter(spacesLayout[spaceUUID], function(spaceId)
            return spaces.spaceType(spaceId) == spaces.types.user
        end)
        hs.fnutils.concat(spacesIds, userSpaces or {})
    end)
    return spacesIds
end
local getAllWindowsUsingSpaces = function()
    local spacesIds = getSpacesIdsTable()
    local tmp = {}
    hs.fnutils.each(spacesIds, function(spaceId)
        local windows = spaces.allWindowsForSpace(spaceId)
        hs.fnutils.each(windows, function(win) table.insert(tmp, win) end)
    end)
    return tmp
end
local getScreenBySpaceId = function(spaceId)
    local spacesLayout = spaces.layout()
    return hs.fnutils.find(hs.screen.allScreens(), function(screen)
        local spaceUUID = screen:spacesUUID()
        return hs.fnutils.contains(spacesLayout[spaceUUID], spaceId)
    end)
end
local getCurrentSpacesByScreen = function()
    local currentSpaces = spaces.query(spaces.masks.currentSpaces)
    local spacesIds = {}
    hs.fnutils.each(hs.screen.allScreens(), function(screen)
        local screenSpaces = screen:spaces()
        local visibleSpace = hs.fnutils.find(screenSpaces,
                                             function(spaceId) return hs.fnutils.contains(currentSpaces, spaceId) end)
        spacesIds[screen:id()] = visibleSpace
    end)
    return spacesIds
end
-- iterate through cache.spaces to find matching window:id()
-- returns foundInAllWindows window, its space, and index in array
module.findTrackedWindow = function(win)
    if not win then return nil, nil, nil end
    local foundSpaceId, foundWinIndex, foundWin
    local didFound = false
    for spaceId, spaceWindows in pairs(cache.spaces) do
        for winIndex, window in pairs(spaceWindows) do
            if not didFound then
                didFound = window:id() == win:id()
                if didFound then
                    foundSpaceId = spaceId
                    foundWinIndex = winIndex
                    foundWin = window
                end
            end
        end
    end
    return foundWin, foundSpaceId, foundWinIndex
end
module.getLayouts = function()
    local layoutNames = {}
    for key in pairs(layouts) do table.insert(layoutNames, key) end
    return layoutNames
end
-- sets layout for space id, defaults to current windows space
module.setLayout = function(layout, spaceId)
    spaceId = spaceId or getSpaceId()
    if not spaceId then return end
    cache.layouts[spaceId] = layout
    -- remove all floating windows that are on this space, so retiling will put them back in the
    -- layout this allows us to switch back from floating layout and get windows back to layout
    cache.floating = hs.fnutils.filter(cache.floating, function(win) return win:spaces()[1] ~= spaceId end)
    module.tile()
end
-- get layout for space id, priorities:
-- 1. already set layout (cache)
-- 2. layout selected by setLayout
-- 3. layout assigned by tiling.displayLayouts
-- 4. if all else fails - 'monocle'
module.getLayout = function(spaceId)
    spaceId = spaceId or getSpaceId()
    local layout = spaces.layout()
    local foundScreenUUID
    for screenUUID, layoutSpaces in pairs(layout) do
        if not foundScreenUUID then
            if hs.fnutils.contains(layoutSpaces, spaceId) then foundScreenUUID = screenUUID end
        end
    end
    local screen = hs.fnutils.find(hs.screen.allScreens(),
                                   function(screen) return screen:spacesUUID() == foundScreenUUID end)
    return cache.layouts[spaceId] or (screen and module.displayLayouts and module.displayLayouts[screen:id()]) or
               (screen and module.displayLayouts and module.displayLayouts[screen:name()]) or 'main-right'
end
module.resetLayouts =
    function() -- resbuild cache.layouts table using provided hhtwm.displayLayouts and hhtwm.defaultLayout
        for key in pairs(cache.layouts) do
            cache.layouts[key] = nil
            cache.layouts[key] = module.getLayout(key)
        end
    end
module.resizeLayout = function(resizeOpt)
    local spaceId = getSpaceId()
    if not spaceId then return end
    if not cache.layoutOptions[spaceId] then cache.layoutOptions[spaceId] = getDefaultLayoutOptions() end
    local calcResizeStep = module.calcResizeStep or function() return 0.1 end
    local screen = getScreenBySpaceId(spaceId)
    local step = calcResizeStep(screen)
    local ratio = cache.layoutOptions[spaceId].mainPaneRatio
    if not resizeOpt then
        ratio = 0.5
    elseif resizeOpt == 'thinner' then
        ratio = math.max(ratio - step, 0)
    elseif resizeOpt == 'wider' then
        ratio = math.min(ratio + step, 1)
    end
    cache.layoutOptions[spaceId].mainPaneRatio = ratio
    module.tile()
end
module.equalizeLayout = function()
    local spaceId = getSpaceId()
    if not spaceId then return end
    if cache.layoutOptions[spaceId] then
        cache.layoutOptions[spaceId] = getDefaultLayoutOptions()
        module.tile()
    end
end
-- swap windows in direction
-- works between screens
module.swapInDirection = function(win, direction)
    win = win or hs.window.frontmostWindow()
    if module.isFloating(win) then return end
    local winCmd = 'windowsTo' .. capitalize(direction)
    local ONLY_FRONTMOST = true
    local STRICT_ANGLE = true
    local windowsInDirection = cache.filter[winCmd](cache.filter, win, ONLY_FRONTMOST, STRICT_ANGLE)
    windowsInDirection = hs.fnutils.filter(windowsInDirection, function(testWin)
        return testWin:isStandard() and not module.isFloating(testWin)
    end)
    if #windowsInDirection >= 1 then
        local winInDirection = windowsInDirection[1]
        local _, winInDirectionSpaceId, winInDirectionIdx = module.findTrackedWindow(winInDirection)
        local _, winSpaceId, winIdx = module.findTrackedWindow(win)
        if hs.fnutils.some({
            win,
            winInDirection,
            winInDirectionSpaceId,
            winInDirectionIdx,
            winSpaceId,
            winIdx
        }, function(_) return _ == nil end) then
            log.e('swapInDirection error', hs.inspect({
                winInDirectionSpaceId,
                winInDirectionIdx,
                winSpaceId,
                winIdx
            }))
            return
        end
        local winInDirectionScreen = winInDirection:screen()
        local winScreen = win:screen()
        -- local winInDirectionFrame  = winInDirection:frame()
        -- local winFrame             = win:frame()
        -- if swapping between screens is disabled, then return early if screen ids differ
        if not SWAP_BETWEEN_SCREENS and winScreen:id() ~= winInDirectionScreen:id() then return end
        -- otherwise, move to screen if they differ
        if winScreen:id() ~= winInDirectionScreen:id() then
            win:moveToScreen(winInDirectionScreen)
            winInDirection:moveToScreen(winScreen)
        end
        ensureCacheSpaces(winSpaceId)
        ensureCacheSpaces(winInDirectionSpaceId)
        -- swap frames
        -- winInDirection:setFrame(winFrame)
        -- win:setFrame(winInDirectionFrame)
        -- swap positions in arrays
        cache.spaces[winSpaceId][winIdx] = winInDirection
        cache.spaces[winInDirectionSpaceId][winInDirectionIdx] = win
        module.tile() -- ~~no need to retile, assuming both windows were previously tiled!~~
    end
end
-- throw window to screen - de-attach and re-attach
module.throwToScreen = function(win, direction)
    win = win or hs.window.frontmostWindow()
    if module.isFloating(win) then return end
    local directions = {next='next', prev='previous'}
    if not directions[direction] then
        log.e('can\'t throw in direction:', direction)
        return
    end
    local screen = win:screen()
    local screenInDirection = screen[directions[direction]](screen)
    if screenInDirection then
        local _, winSpaceId, winIdx = module.findTrackedWindow(win)
        if hs.fnutils.some({winSpaceId, winIdx}, function(_) return _ == nil end) then
            log.e('throwToScreen error: ', hs.inspect({winSpaceId, winIdx}))
            return
        end
        -- remove from tiling so we re-tile that window after it was moved
        if cache.spaces[winSpaceId] then
            table.remove(cache.spaces[winSpaceId], winIdx)
        else
            log.ef('throwToScreen no cache.spaces for space id: %s', winSpaceId)
        end
        win:moveToScreen(screenInDirection) -- move window to screen
        if hs.window.animationDuration > 0 then -- retile to update layouts
            hs.timer.doAfter(hs.window.animationDuration * 1, module.tile)
        else
            module.tile()
        end
    end
end
module.throwToScreenUsingSpaces = function(win, direction)
    win = win or hs.window.frontmostWindow()
    if module.isFloating(win) then return end
    local directions = {next='next', prev='previous'}
    if not directions[direction] then
        log.e('can\'t throw in direction:', direction)
        return
    end
    local screen = win:screen()
    local screenInDirection = screen[directions[direction]](screen)
    local currentSpaces = getCurrentSpacesByScreen()
    local throwToSpaceId = currentSpaces[screenInDirection:id()]
    if not throwToSpaceId then
        log.e('no space to throw to')
        return
    end
    local _, winSpaceId, winIdx = module.findTrackedWindow(win)
    if hs.fnutils.some({winSpaceId, winIdx}, function(_) return _ == nil end) then
        log.ef('throwToScreenUsingSpaces error: %s', hs.inspect({winSpaceId, winIdx}))
        return
    end
    -- remove from tiling so we re-tile that window after it was moved
    if cache.spaces[winSpaceId] then
        table.remove(cache.spaces[winSpaceId], winIdx)
    else
        log.e('throwToScreenUsingSpaces no cache.spaces for space id:', winSpaceId)
    end
    local newX = screenInDirection:frame().x
    local newY = screenInDirection:frame().y
    spaces.moveWindowToSpace(win:id(), throwToSpaceId)
    win:setTopLeft(newX, newY)
    module.tile()
end
module.throwToSpace = function(win, spaceIdx) -- throw window to space, indexed
    if not win then
        log.e('throwToSpace tried to throw nil window')
        return false
    end
    local spacesIds = getSpacesIdsTable()
    local spaceId = spacesIds[spaceIdx]
    if not spaceId then
        log.e('throwToSpace tried to move to non-existing space', spaceId, hs.inspect(spacesIds))
        return false
    end
    local targetScreen = getScreenBySpaceId(spaceId)
    local targetScreenFrame = targetScreen:frame()
    if module.isFloating(win) then
        -- adjust frame for new screen offset
        local newX = win:frame().x - win:screen():frame().x + targetScreen:frame().x
        local newY = win:frame().y - win:screen():frame().y + targetScreen:frame().y
        spaces.moveWindowToSpace(win:id(), spaceId) -- move to space
        win:setTopLeft(newX, newY) -- ensure window is visible
        return true
    end
    local _, winSpaceId, winIdx = module.findTrackedWindow(win)
    if hs.fnutils.some({winSpaceId, winIdx}, function(_) return _ == nil end) then
        log.e('throwToSpace error', hs.inspect({winSpaceId, winIdx}))
        return false
    end
    -- remove from tiling so we re-tile that window after it was moved
    if cache.spaces[winSpaceId] then
        table.remove(cache.spaces[winSpaceId], winIdx)
    else
        log.ef('throwToSpace no cache.spaces for space id: %s', winSpaceId)
    end
    spaces.moveWindowToSpace(win:id(), spaceId) -- move to space
    win:setTopLeft(targetScreenFrame.x, targetScreenFrame.y) -- ensure window is visible
    module.tile() -- retile when finished
    return true
end
module.isFloating = function(win) -- check if window is floating
    local trackedWin, _, _ = module.findTrackedWindow(win)
    local isTrackedAsTiling = trackedWin ~= nil
    if isTrackedAsTiling then return false end
    local isTrackedAsFloating = hs.fnutils.find(cache.floating,
                                                function(floatingWin) return floatingWin:id() == win:id() end)
    -- if window is not floating and not tiling, then default to floating?
    if isTrackedAsFloating == nil and trackedWin == nil then return true end
    return isTrackedAsFloating ~= nil
end
module.toggleFloat = function(win) -- toggle floating state of window
    win = win or hs.window.frontmostWindow()
    if not win then return end
    if module.isFloating(win) then
        local spaceId = win:spaces()[1]
        local foundIdx
        for index, floatingWin in pairs(cache.floating) do
            if not foundIdx then if floatingWin:id() == win:id() then foundIdx = index end end
        end
        ensureCacheSpaces(spaceId)
        table.insert(cache.spaces[spaceId], win)
        table.remove(cache.floating, foundIdx)
    else
        local foundWin, winSpaceId, winIdx = module.findTrackedWindow(win)
        if cache.spaces[winSpaceId] then
            table.remove(cache.spaces[winSpaceId], winIdx)
        else
            log.e('window made floating without previous :space()', hs.inspect(foundWin))
        end
        table.insert(cache.floating, win)
    end
    module.tile() -- update tiling
end
-- internal function for deciding if window should float when recalculating tiling
local shouldFloat = function(win)
    -- if window is in tiling cache, then it is not floating
    local inTilingCache, _, _ = module.findTrackedWindow(win)
    if inTilingCache then return false end
    -- if window is already tracked as floating, then leave it be
    local isTrackedAsFloating = hs.fnutils.find(cache.floating,
                                                function(floatingWin) return floatingWin:id() == win:id() end) ~= nil
    if isTrackedAsFloating then return true end
    return not module.detectTile(win) -- otherwise detect if window should be floated/tiled
end
module.tile = function() -- tile windows - combine caches with current state, and apply layout
    if #hs.mouse.getButtons() ~= 0 then return end -- ignore tiling if we're doing something with a mouse
    local tilingWindows = {} -- this allows us to have tabs and do proper tiling!
    local floatingWindows = {}
    local currentSpaces = getCurrentSpacesIds()
    local allWindows = hs.window.allWindows()
    -- local allWindowsFilter = cache.filter:getWindows()
    -- local allWindowsSpaces = getAllWindowsUsingSpaces()
    -- log.d('allWindows', hs.inspect(allWindows))
    -- log.d('allWindowsFilter', hs.inspect(allWindowsFilter))
    hs.fnutils.each(allWindows or {}, function(win)
        -- we don't care about minimized or fullscreen windows
        if win:isMinimized() or win:isFullscreen() then return end
        -- we also don't care about special windows that have no spaces
        if not win:spaces() or #win:spaces() == 0 then return end
        if shouldFloat(win) then
            table.insert(floatingWindows, win)
        else
            table.insert(tilingWindows, win)
        end
    end)
    -- add new tiling windows to cache
    hs.fnutils.each(tilingWindows, function(win)
        if not win or #win:spaces() == 0 then return end
        local spaces = win:spaces()
        local spaceId = spaces[1]
        local tmp = cache.spaces[spaceId] or {}
        local trackedWin, trackedSpaceId, _ = module.findTrackedWindow(win)
        -- log.d('update cache.spaces', hs.inspect({
        --   win = win,
        --   spaces = spaces,
        --   spaceId = spaceId,
        --   trackedWin = trackedWin or 'none',
        --   trackedSpaceId = trackedSpaceId or 'none',
        --   shouldInsert = not trackedWin or trackedSpaceId ~= spaceId
        -- }))
        -- window is "new" if it's not in cache at all, or if it changed space
        if not trackedWin or trackedSpaceId ~= spaceId then
            table.insert(tmp, win) -- table.insert(tmp, 1, win)
        end
        cache.spaces[spaceId] = tmp
    end)
    -- clean up tiling cache
    hs.fnutils.each(currentSpaces, function(spaceId)
        local spaceWindows = cache.spaces[spaceId] or {}
        for i = #spaceWindows, 1, -1 do
            -- window exists in cache if there's spaceId and windowId match
            local existsOnScreen = hs.fnutils.find(tilingWindows, function(win)
                return win:id() == spaceWindows[i]:id() and win:spaces()[1] == spaceId
            end)
            -- window is duplicated (why?) if it's tracked more than once
            -- this shouldn't happen, but helps for now...
            local duplicateIdx = 0
            for j = 1, #spaceWindows do
                if spaceWindows[i]:id() == spaceWindows[j]:id() and i ~= j then duplicateIdx = j end
            end
            if duplicateIdx > 0 then
                log.e('duplicate idx', hs.inspect({
                    i=i,
                    duplicateIdx=duplicateIdx,
                    spaceWindows=spaceWindows
                }))
            end
            if not existsOnScreen or duplicateIdx > 0 then
                table.remove(spaceWindows, i)
            else
                i = i + 1
            end
        end
        cache.spaces[spaceId] = spaceWindows
    end)
    hs.fnutils.each(floatingWindows, -- add new windows to floating cache
    function(win) if not module.isFloating(win) then table.insert(cache.floating, win) end end)
    -- clean up floating cache
    cache.floating = hs.fnutils.filter(cache.floating, function(cacheWin)
        return hs.fnutils.find(floatingWindows, function(win) return cacheWin:id() == win:id() end)
    end)
    local moveToFloat = {} -- apply layout window-by-window
    hs.fnutils.each(currentSpaces, function(spaceId)
        local spaceWindows = cache.spaces[spaceId] or {}
        hs.fnutils.each(hs.screen.allScreens(), function(screen)
            local screenWindows = hs.fnutils.filter(spaceWindows,
                                                    function(win) return win:screen():id() == screen:id() end)
            local layoutName = module.getLayout(spaceId)
            if not layoutName or not layouts[layoutName] then
                log.ef('layout doesn\'t exist: %s', layoutName)
            else
                for index, window in pairs(screenWindows) do
                    local frame = layouts[layoutName](window, screenWindows, screen, index,
                                                      cache.layoutOptions[spaceId] or getDefaultLayoutOptions())
                    -- only set frame if returned,
                    -- this allows for layout to decide if window should be floating
                    if frame then
                        window:setFrame(frame)
                    else
                        table.insert(moveToFloat, window)
                    end
                end
            end
        end)
    end)
    hs.fnutils.each(moveToFloat, function(win)
        local _, spaceId, winIdx = module.findTrackedWindow(win)
        table.remove(cache.spaces[spaceId], winIdx)
        table.insert(cache.floating, win)
    end)
end
-- tile detection:
-- 1. test tiling.filters if exist
-- 2. check if there's fullscreen button -> yes = tile, no = float
module.detectTile = function(win)
    local app = win:application():name()
    local role = win:role()
    local subrole = win:subrole()
    local title = win:title()
    if module.filters then
        local foundMatch = hs.fnutils.find(module.filters, function(obj)
            local appMatches = ternary(obj.app ~= nil and app ~= nil, string.match(app, obj.app or ''), true)
            local titleMatches = ternary(obj.title ~= nil and title ~= nil, string.match(title, obj.title or ''), true)
            local roleMatches = ternary(obj.role ~= nil, obj.role == role, true)
            local subroleMatches = ternary(obj.subrole ~= nil, obj.subrole == subrole, true)
            return appMatches and titleMatches and roleMatches and subroleMatches
        end)
        if foundMatch then return foundMatch.tile end
    end
    local shouldTileDefault = hs.axuielement.windowElement(win):isAttributeSettable('AXSize')
    return shouldTileDefault
end
module.reset = function() -- mostly for debugging
    cache.spaces = {}
    cache.layouts = {}
    cache.floating = {}
    module.tile()
end
local loadSettings = function()
    -- load from cache
    local jsonTilingCache = hs.settings.get('hhtwm.tilingCache')
    local jsonFloatingCache = hs.settings.get('hhtwm.floatingCache')
    log.d('reading from hs.settings')
    log.df('hhtwm.tilingCache: %s', jsonTilingCache)
    log.df('hhtwm.floatingCache: %s', jsonFloatingCache)
    local allWindows = getAllWindowsUsingSpaces() -- all windows from window filter
    local findWindowById = function(winId)
        return hs.fnutils.find(allWindows, function(win) return win:id() == winId end)
    end
    if jsonTilingCache then -- decode tiling cache
        local tilingCache = hs.json.decode(jsonTilingCache)
        local spacesIds = getSpacesIdsTable()
        hs.fnutils.each(tilingCache, function(obj)
            if hs.fnutils.contains(spacesIds, obj.spaceId) then -- we don't care about spaces that no longer exist
                cache.spaces[obj.spaceId] = {}
                cache.layouts[obj.spaceId] = obj.layout
                cache.layoutOptions[obj.spaceId] = obj.layoutOptions
                hs.fnutils.each(obj.windowIds, function(winId)
                    local win = findWindowById(winId)
                    log.df('restoring (spaceId=%s, windowId=%s, window=%s)', obj.spaceId, winId, win)
                    if win then table.insert(cache.spaces[obj.spaceId], win) end
                end)
            end
        end)
    end
    -- decode floating cache
    if jsonFloatingCache then
        local floatingCache = hs.json.decode(jsonFloatingCache)
        hs.fnutils.each(floatingCache, function(winId)
            local win = hs.window.find(winId)
            if win then table.insert(cache.floating, win) end -- we don't care about windows that no longer exist
        end)
    end
    log.d('--- read from hs.settings')
    log.df('cache.spaces=%s', hs.inspect(cache.spaces))
    log.df('cache.floating=%s', hs.inspect(cache.floating))
end
local saveSettings = function()
    local tilingCache = {}
    local floatingCache = hs.fnutils.map(cache.floating, function(win) return win:id() end)
    for spaceId, spaceWindows in pairs(cache.spaces) do
        if #spaceWindows > 0 then -- only save spaces with windows on them
            local tmp = {}
            for _, window in pairs(spaceWindows) do
                log.df('storing (spaceId=%s, windowId=%s, window=%s)', spaceId, window:id(), window)
                table.insert(tmp, window:id())
            end
            table.insert(tilingCache, {
                spaceId=spaceId,
                layout=module.getLayout(spaceId),
                layoutOptions=cache.layoutOptions[spaceId],
                windowIds=tmp
            })
        end
    end
    local jsonTilingCache = hs.json.encode(tilingCache)
    local jsonFloatingCache = hs.json.encode(floatingCache)
    log.d('storing to hs.settings')
    log.df('hhtwm.tiling=%s', jsonTilingCache)
    log.df('hhtwm.floating=%s', jsonFloatingCache)
    hs.settings.set('hhtwm.tilingCache', jsonTilingCache)
    hs.settings.set('hhtwm.floatingCache', jsonFloatingCache)
end
module.start = function()
    -- discover windows on spaces as soon as possible
    -- hs.window.filter.forceRefreshOnSpaceChange = true
    -- start window filter
    cache.filter = hs.window.filter.new():setDefaultFilter():setOverrideFilter({
        visible=true, -- only allow visible windows
        fullscreen=false, -- ignore fullscreen windows
        allowRoles={'AXStandardWindow'} -- currentSpace = true,  -- only windows on current space
    })
    -- :setSortOrder(hs.window.filter.sortByCreated)
    -- load window/floating status from saved state
    loadSettings()
    -- retile automatically when windows change
    cache.filter:subscribe({hs.window.filter.windowsChanged, hs.window.filter.windowMoved}, module.tile)
    cache.screenWatcher = hs.screen.watcher.new(module.tile):start() -- update on screens change
    module.tile() -- tile on start
end
module.stop = function()
    saveSettings() -- store cache so we persist layouts between restarts
    cache.filter:unsubscribeAll() -- stop filter
    cache.screenWatcher:stop() -- stop watching screens
end
return module
