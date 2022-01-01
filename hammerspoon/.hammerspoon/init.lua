-- GLOBAL REQUIRES ---------------------
hs.ipc.cliUninstall()
hs.ipc.cliInstall()
require("hs.ipc")
require('console').init()
require('overrides').init()
require('hs.hotkey').setLogLevel('warning')
-- SPOONS -------------------------------
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall
Install:andUse('HeadphoneAutoPause', {start = true})
Install:andUse('TextClipboardHistory', {
    disable = false,
    config = {show_in_menubar = true},
    hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}},
    start = true
})
hs.brightness.set(100)
-- GLOBAL CONFIGURATION
config = {
    apps = {terms = {'kitty'}, browsers = {'Vivaldi'}},
    wm = {
        defaultDisplayLayouts = {['Built-in Retina Display'] = {'main-center'}},
        displayLayouts = { ['Built-in Retina Display'] = {'main-center','main-right', 'monocle'} }
    },
    window = {highlightBorder = true, highlightMouse = true, historyLimit = 0}
}
-- SETTINGS -----------------------------
hs.window.animationDuration = 0.0
wm= require('utils.wm')
notify = require('utils.notify')
notify.enabled = {'battery'}
watchables = require('utils.watchables')
-- watchers = require('utils.watchers')
-- watchers.enabled = {'window-border', 'reload', 'menubar'}
bindings = require('bindings')
bindings.askBeforeQuitApps = config.apps.browsers
bindings.enabled = {'block-hide','focus','global','tiling'}
-- START MODULES
local modules = {bindings, notify, watchables, watchers, wm}
hs.fnutils.each(modules, function(module) if module then module.start() end end)
-- STOP RUNNING MODULES ON SHUTDOWN
hs.shutdownCallback = function()
    hs.fnutils.each(modules,
                    function(module) if module then module.stop() end end)
end
-- ALERT THAT HS SUCCESSFULLY STARTED
hs.notify.show('Hammerspoon', 'Reload Notification',
               'Hammerspoon configuration reloaded.')
