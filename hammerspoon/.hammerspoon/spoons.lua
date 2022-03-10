local M = {log = hs.logger.new('spoons', 'debug')}
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

M.Install = spoon.SpoonInstall

M.log.i('installing KSheet')
M.Install:andUse('KSheet', {hotkeys = {toggle = {hyper, '/'}}})
M.log.i('installing HeadphoneAutoPause')
M.Install:andUse('HeadphoneAutoPause', {start = true})

M.log.i('installing TextClipboardHistory')
M.Install:andUse('TextClipboardHistory', {
  config = {show_in_menubar = true},
  disable = false,
  hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}},
  start = true
})

M.log.i('installing MouseCircle')
M.Install:andUse('MouseCircle', {
  config = {color = hs.drawing.color.x11.red},
  disable = false,
  hotkeys = {show = {hyper, 'm'}}
})
return M
