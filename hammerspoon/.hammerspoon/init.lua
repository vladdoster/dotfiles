ctrl_cmd = {'cmd', 'ctrl'}
hyper = {'cmd', 'alt', 'ctrl'}
shift_hyper = {'cmd', 'alt', 'ctrl', 'shift'}

hs.hotkey.bindSpec({hyper, 'y'}, hs.toggleConsole)

require('windowBorder')
require('spoons')

hs.notify.show('Hammerspoon', 'Sucessfully loaded config', '')
