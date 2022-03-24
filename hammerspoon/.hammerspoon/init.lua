ctrl_cmd = {'cmd', 'ctrl'}
hyper = {'cmd', 'alt', 'ctrl'}
shift_hyper = {'cmd', 'alt', 'ctrl', 'shift'}

hs.hotkey.bindSpec({hyper, 'y'}, hs.toggleConsole)

-- require('windowBorder').start()
require('ext.battery')
require('ext.navigation')
require('ext.infoDisplay').start()
require('ext.dockTime').start()
hs.hotkey.bindSpec({hyper, 't'}, require('ext.sysStats').toggle)

hs.hotkey.bindSpec({hyper, 'r'}, hs.reload)

require('spoons')

hs.notify.show('Hammerspoon', 'Sucessfully loaded config', '')
