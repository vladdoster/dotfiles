-- global stuff
require('console').init()
require('overrides').init()

-- ensure IPC is there
hs.ipc.cliInstall()

-- lower logging level for hotkeys
require('hs.hotkey').setLogLevel("warning")

-- global config
config = {
    apps = {terms = {'kitty'}, browsers = {'Google Chrome'}},
    wm = {
        defaultDisplayLayouts = {
            ['Color LCD'] = 'main-right',
            ['LG QHD'] = 'main-right'

        },
        displayLayouts = {
            ['Color LCD'] = {'main-right', 'main-center'},
            ['LG QHD'] = {'main-right', 'main-center'}
        }
    },
    window = {highlightBorder = true, highlightMouse = true, historyLimit = 10},
    network = {home = 'Moon'}
}

-- requires
bindings = require('bindings')
watchables = require('utils.watchables')
watchers = require('utils.watchers')
wm = require('utils.wm')

-- no animations
hs.window.animationDuration = 0.0

-- hints
hs.hints.fontName = 'Helvetica-Bold'
hs.hints.fontSize = 22
hs.hints.hintChars = {
    'A', 'S', 'D', 'F', 'J', 'K', 'L', 'Q', 'W', 'E', 'R', 'Z', 'X', 'C'
}
hs.hints.iconAlpha = 1.0
hs.hints.showTitleThresh = 0

-- watchers
watchers.enabled = {'urlevent'}
watchers.urlPreference = config.apps.browsers

-- bindings
bindings.enabled = {
    'ask-before-quit', 'block-hide', 'ctrl-esc', 'f-keys', 'focus', 'global',
    'tiling', 'term-ctrl-i'
}
bindings.askBeforeQuitApps = config.apps.browsers

-- start/stop modules
local modules = {bindings, watchables, watchers, wm}

hs.fnutils.each(modules, function(module) if module then module.start() end end)

-- stop modules on shutdown
hs.shutdownCallback = function()
    hs.fnutils.each(modules,
                    function(module) if module then module.stop() end end)
end
