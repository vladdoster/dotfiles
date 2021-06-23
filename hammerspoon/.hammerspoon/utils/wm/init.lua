local activeScreen = require(
                         'ext.screen').activeScreen
local table = require('ext.table')
local hhtwm = require('hhtwm')
local log = hs.logger.new('wm', 'debug')

local cache = { hhtwm = hhtwm }
local module = { cache = cache }

local notify = function(text)
    hs.alert.closeAll()
    hs.alert(text)
end

local screenWatcher =
    function(_, _, _, prevScreens,
             screens)
        if prevScreens == nil
            or #prevScreens == 0 then
            return
        end

        if table.equal(prevScreens,
                       screens) then
            return
        end

        log.d(
            '--- resetting display layouts')

        hhtwm.displayLayouts = config.wm
                                   .defaultDisplayLayouts
        hhtwm.resetLayouts()
        hhtwm.tile()
    end

local calcResizeStep =
    function(screen)
        return
            1 / hs.grid.getGrid(screen)
                .w
    end

module.setLayout = function(layout)
    hhtwm.setLayout(layout)
    hhtwm.resizeLayout()

    notify('Switched to: ' .. layout)
end

module.cycleLayout =
    function()
        local screen = hs.screen
                           .mainScreen()

        local layouts = config.wm
                            .displayLayouts[screen:name()]
        local currentLayout =
            hhtwm.getLayout()

        log.d('--- current layout: ',
              currentLayout)
        log.d('--- display: ', screen)
        log.d('--- layouts: ', layouts)

        local currentLayoutIndex =
            hs.fnutils.indexOf(layouts,
                               currentLayout)
                or 0

        local nextLayoutIndex =
            (currentLayoutIndex
                % #layouts) + 1
        local nextLayout =
            layouts[nextLayoutIndex]

        module.setLayout(nextLayout)
    end

module.start = function()
    cache.watcher = hs.watchable.watch(
                        'status.connectedScreenIds',
                        screenWatcher)

    local filters = {
        {
            app = 'Application Loader',
            tile = true
        },
        {
            app = 'Archive Utility',
            tile = false
        }, {
            app = 'DiskImages UI Agent',
            tile = false
        },
        { app = 'FaceTime', tile = false },
        {
            app = 'Finder',
            title = 'Copy',
            tile = false
        }, {
            app = 'Finder',
            title = 'Move',
            tile = false
        },
        { app = 'Focus', tile = false },
        {
            app = 'Hammerspoon',
            title = 'Hammerspoon Console',
            tile = true
        }, {
            app = 'Kitty',
            subrole = 'AXDialog',
            tile = false
        }, { app = 'Max', tile = true },
        { app = 'Messages', tile = false },
        {
            app = 'QuickTime Player',
            tile = false
        }, {
            app = 'System Preferences',
            tile = false
        }, {
            app = 'iTunes',
            title = 'Mini Player',
            tile = false
        }, {
            app = 'iTunes',
            title = 'Multiple Song Info',
            tile = false
        }, {
            app = 'iTunes',
            title = 'Song Info',
            tile = false
        },
        {
            title = 'Quick Look',
            tile = false
        }
    }

    local isMenubarVisible = hs.screen
                                 .primaryScreen():frame()
                                 .y > 0

    local fullMargin = 12
    local halfMargin = fullMargin / 2

    local screenMargin = {
        top = (isMenubarVisible and 22
            or 0) + halfMargin,
        bottom = halfMargin,
        left = halfMargin,
        right = halfMargin
    }

    hhtwm.margin = fullMargin
    hhtwm.screenMargin = screenMargin
    hhtwm.filters = filters
    hhtwm.calcResizeStep =
        calcResizeStep
    hhtwm.displayLayouts =
        DEFAULT_DISPLAY_LAYOUTS
    hhtwm.defaultLayout = 'main-right'

    hhtwm.start()
end

module.stop = function()
    cache.watcher:release()
    hhtwm.stop()
end

return module

