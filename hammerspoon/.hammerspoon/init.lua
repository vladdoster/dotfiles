-- GLOBAL REQUIRES ---------------------
hs.ipc.cliInstall()
hs.ipc.cliUninstall()
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
    config = {show_in_menubar = true},
    deduplicate = true,
    disable = false,
    hist_size = 10,
    hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}},
    start = true,
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
bindings = require('bindings')
spaces   = require('utils.spaces')
watchers = require('utils.watchers')
wm       = require('utils.wm')

require('modules.battery')
require('modules.windowBorder')

spaces.enabled = {'dots'}
-- no animations
hs.window.animationDuration = 0.0
-- watchers
-- watchers.enabled = {'window-border', 'reload' }
watchers.enabled = { 'reload' }
-- bindings
bindings.enabled            = { 'ask-before-quit', 'block-hide', 'focus', 'global', 'tiling' }
bindings.askBeforeQuitApps  = config.apps.browsers
-- start/stop modules
local modules               = { bindings, watchables, watchers, wm, spaces}
hs.fnutils.each(modules, function(module)
  if module then module.start() end
end)
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then module.stop() end
  end)
end
hs.notify.show('Hammerspoon', 'Hammerspoon configuration reloaded.','')
