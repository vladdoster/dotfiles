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
Install:andUse('HeadphoneAutoPause', {start=true})
Install:andUse('TextClipboardHistory', {
    disable=false,
    config={show_in_menubar=true},
    hotkeys={toggle_clipboard={{'cmd', 'shift'}, 'v'}},
    start=true
})
-- GLOBAL CONFIGURATION
config = {
    apps={terms={'kitty'}, browsers={'Vivaldi'}},
    wm={
        defaultDisplayLayouts={['Built-in Retina Display']={'main-right'}},
        displayLayouts={['Built-in Retina Display']={'main-right', 'monocle'}}
    },
    window={highlightBorder=true, highlightMouse=true, historyLimit=0}
}
-- BETTER SWITCHER ----------------------
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher.ui.highlightColor = {0.4, 0.4, 0.5, 0.8}
-- switcher.ui.thumbnailSize = 112
-- switcher.ui.selectedThumbnailSize = 0.0
-- switcher.ui.backgroundColor = {0.3, 0.3, 0.3, 0.5}
-- switcher.ui.fontName = 'IBM Plex Mono'
-- switcher.ui.textSize = 12
-- switcher.ui.showSelectedTitle = false
-- hs.hotkey.bind('alt', 'tab', function() switcher:next() end)
-- hs.hotkey.bind('alt-shift', 'tab', function() switcher:previous() end)
-- SETTINGS -----------------------------
hs.window.animationDuration = 0.0
hs.hints.fontName = 'IBM Plex Mono'
hs.hints.fontSize = 22
hs.hints.hintChars = {'A', 'S', 'D', 'F', 'J', 'K', 'L', 'Q', 'W', 'E', 'R', 'Z', 'X', 'C'}
hs.hints.iconAlpha = 1.0
hs.hints.showTitleThresh = 0
-- BINDINGS
bindings = require('bindings')
bindings.askBeforeQuitApps = config.apps.browsers
bindings.enabled = {'block-hide', 'ctrl-esc', 'f-keys', 'focus', 'global', 'tiling'}
-- SPACES
-- spaces = require('utils.spaces')
-- spaces.enabled = {'betterswitch'}
-- WATCHABLES
watchables = require('utils.watchables')
watchers = require('utils.watchers')
watchers.enabled = {'autoborder'}
-- watchers.enabled = {}
-- hs.window.highlight.start()
-- WINDOW MANAGEMENT
wm = require('utils.wm')
-- START MODULES
local modules = {bindings, wm, watchers, watchables}
hs.fnutils.each(modules, function(module) if module then module.start() end end)
-- STOP MODULES ON SHUTDOWN
hs.shutdownCallback = function() hs.fnutils.each(modules, function(module) if module then module.stop() end end) end
-- NOTIFY USER
hs.notify.show('Hammerspoon', 'Reload Notification', 'Hammerspoon configuration reloaded.')
-- hs.alert('Hammerspoon initiated')
