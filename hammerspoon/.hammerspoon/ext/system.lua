local module = {}
local activateFrontmost = require('ext.application').activateFrontmost
-- show notification center
module.toggleNotificationCenter = function()
    hs.applescript.applescript([[
    tell application "System Events" to tell process "SystemUIServer"
      click menu bar item "Notification Center" of menu bar 2
    end tell
  ]])
end
module.toggleWiFi = function()
    local newStatus = not hs.wifi.interfaceDetails().power
    hs.wifi.setPower(newStatus)
    local imagePath = os.getenv('HOME') .. '/.hammerspoon/assets/airport.png'
    hs.notify.new({
        title='Wi-Fi',
        subTitle='Power: ' .. (newStatus and 'On' or 'Off'),
        contentImage=imagePath
    }):send()
end
module.toggleConsole = function()
    hs.console.darkMode(true)
    hs.toggleConsole()
    activateFrontmost()
end
module.reloadHS = function()
    hs.reload()
    hs.notify.new({title='Hammerspoon', subTitle='Reloaded'}):send()
end
return module
