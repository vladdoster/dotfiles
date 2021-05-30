-- Hammerspoon configuration, heavily influenced by sdegutis default configuration

-- DEPENDENCIES
--------------------------------------------------------------------------------
require('console').init()
require('overrides').init()

-- global variables
bindings                    = require('bindings')
controlplane                = require('utils.controlplane')
watchables                  = require('utils.watchables')
watchers                    = require('utils.watchers')
wm                          = require('utils.wm')

-- CONFIGURATION
--------------------------------------------------------------------------------
-- ensure IPC is available
hs.ipc.cliInstall()
-- lower logging level for hotkeys
require('hs.hotkey').setLogLevel("warning")

config = {
  apps = {
    terms    = { 'kitty' },
    browsers = { 'Google Chrome' }
  },
  network = { home = 'moon' },
  wm = {
    defaultDisplayLayouts = {
      ['Color LCD']  = 'monocle',
      ['LG QHD (1)'] = 'monocle',
      ['LG QHD (2)'] = 'monocle',
    },
    displayLayouts = {
      ['Color LCD']  = { 'monocle', 'main-right', 'side-by-side' },
      ['LG QHD (1)'] = { 'monocle', 'main-right', 'side-by-side' },
      ['LG QHD (2)'] = { 'monocle', 'main-right', 'side-by-side' },
    }
  },
  window = {
    highlightBorder = false,
    highlightMouse  = true,
    historyLimit    = 0
  },
}

-- disable animations
hs.window.animationDuration = 0.0

-- bindings
bindings.enabled            = { 'ask-before-quit', 'block-hide', 'ctrl-esc', 'f-keys', 'focus', 'global', 'tiling', 'term-ctrl-i', 'viscosity' }
bindings.askBeforeQuitApps  = config.apps.browsers

-- controlplane
controlplane.enabled        = { 'autohome', 'automount' }

-- hammerspoon hints
hs.hints.fontName           = 'Helvetica-Bold'
hs.hints.fontSize           = 22
hs.hints.hintChars          = { 'A', 'S', 'D', 'F', 'J', 'K', 'L', 'Q', 'W', 'E', 'R', 'Z', 'X', 'C' }
hs.hints.iconAlpha          = 1.0
hs.hints.showTitleThresh    = 0

-- watchers
watchers.enabled            = { 'urlevent' }
watchers.urlPreference      = config.apps.browsers

-- {start,stop} modules
local modules               = { bindings, controlplane, watchables, watchers, wm }

hs.fnutils.each(modules, function(module)
  if module then module.start() end
end)

-- stop modules on shutdown
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then module.stop() end
  end)
end

init()
