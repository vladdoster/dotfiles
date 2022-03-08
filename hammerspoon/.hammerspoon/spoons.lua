hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall
Install:andUse('TextClipboardHistory', {
  disable = false,
  config = {show_in_menubar = true},
  hotkeys = {toggle_clipboard = {{'cmd', 'shift'}, 'v'}},
  start = true
})

Install:andUse('KSheet', {hotkeys = {toggle = {hyper, '/'}}})

Install:andUse('HeadphoneAutoPause', {start = true})

Install:andUse('MouseCircle', {
  disable = false,
  config = {color = hs.drawing.color.x11.red},
  hotkeys = {show = {hyper, 'm'}}
})
