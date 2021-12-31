-- Display system statistics in menubar
wifiWatcher = nil
function ssidChanged()
    local network = hs.wifi.currentNetwork()
    if network then
        wifiMenu:setTitle('Wifi: ' .. network )
    else
        wifiMenu:setTitle("Wifi: No network")
    end
end
wifiMenu = hs.menubar.new()
ssidChanged()
wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()
