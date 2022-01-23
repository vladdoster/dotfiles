-- GLOBAL REQUIRES ---------------------
hs.ipc.cliInstall()
hs.ipc.cliUninstall()
require('hs.ipc')
require('console').init()
require('overrides').init()
require('hs.hotkey').setLogLevel('warning')
-- +----------------------------+
-- |           SPOONS           |
-- +----------------------------+
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall
Install:andUse('HeadphoneAutoPause', {start = true})
Install:andUse('TextClipboardHistory', {
    config = {show_in_menubar = true},
    deduplicate = true,
    disable = false,
    hist_size = 10,
    hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}},
    start = true
})
hs.brightness.set(100)
-- GLOBAL CONFIGURATION
config = {
    apps = {terms = {'kitty'}, browsers = {'Vivaldi'}},
    wm = {
        defaultDisplayLayouts = {['Built-in Retina Display'] = {'main-center'}},
        displayLayouts = {
            ['Built-in Retina Display'] = {'main-center', 'main-right', 'monocle'},
        }
    },
    window = {highlightBorder = true, highlightMouse = true, historyLimit = 0}
}
hs.window.animationDuration = 0.0
-- +----------------------------+
-- |           MODULES          |
-- +----------------------------+
wm = require('utils.wm')

-- pspaces = require('utils.spaces')
-- pspaces.enabled = {'dots', 'betterswitch'}

watchers = require('utils.watchers')
watchers.enabled = {'reload'}

bindings = require('bindings')
bindings.enabled = {'block-hide', 'focus', 'global', 'tiling'}
-- bindings.askBeforeQuitApps = config.apps.browsers

require('modules.battery')
-- require('modules.windowBorder')

local modules = {bindings, watchers}
hs.fnutils.each(modules, function(module) if module then module.start() end end)
hs.shutdownCallback = function() hs.fnutils.each(modules, function(module) if module then module.stop() end end) end
hs.notify.show('Hammerspoon', 'Hammerspoon configuration reloaded.', '')
