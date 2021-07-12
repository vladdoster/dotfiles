-- global stuff
require('console').init()
require('overrides').init()
require('hs.hotkey').setLogLevel('warning')

-- check IPC has loaded
hs.ipc.cliInstall()

hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

Install:andUse('TextClipboardHistory',
               {disable = false, config = {show_in_menubar = true}, hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}}, start = true})

Install:andUse('HeadphoneAutoPause', {start = true})

-- global config
config = {
    apps = {terms = {'kitty'}, browsers = {'Google Chrome', 'Safari', 'Vivaldi'}},
    wm = {
        defaultDisplayLayouts = {['Built-in Retina Display'] = {'main-right'}},

        displayLayouts = {['Built-in Retina Display'] = {'monocle', 'main-right'}}
    },
    window = {highlightBorder = true, highlightMouse = true, historyLimit = 0}
}

-- requires
bindings = require('bindings')
wm = require('utils.wm')

-- no animations
hs.window.animationDuration = 0.0

-- hints
hs.hints.fontName = 'Helvetica-Bold'
hs.hints.fontSize = 22
hs.hints.hintChars = {'A', 'S', 'D', 'F', 'J', 'K', 'L', 'Q', 'W', 'E', 'R', 'Z', 'X', 'C'}
hs.hints.iconAlpha = 1.0
hs.hints.showTitleThresh = 0

-- bindings
bindings.enabled = {'ask-before-quit', 'block-hide', 'ctrl-esc', 'f-keys', 'focus', 'global', 'tiling', 'term-ctrl-i'}
bindings.askBeforeQuitApps = config.apps.browsers

-- start/stop modules
local modules = {bindings, wm}

hs.fnutils.each(modules, function(module)
    if module then module.start() end
end)

-- stop modules on shutdown
hs.shutdownCallback = function()
    hs.fnutils.each(modules, function(module)
        if module then module.stop() end
    end)
end

hs.alert('Hammerspoon initiated')
