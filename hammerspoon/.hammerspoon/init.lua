ctrl_cmd = {'cmd', 'ctrl'}
hyper = {'cmd', 'alt', 'ctrl'}
shift_hyper = {'cmd', 'alt', 'ctrl', 'shift'}

hs.hotkey.bindSpec({hyper, 'y'}, hs.toggleConsole)

-- require('windowBorder').start()
require('spoons')
require('ext.battery')
require('ext.navigation')
require('ext.infoDisplay').start()
require('ext.dockTime').start()

hs.notify.show('Hammerspoon', 'Sucessfully loaded config', '')
