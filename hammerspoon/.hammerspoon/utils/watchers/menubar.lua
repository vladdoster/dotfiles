-- Display system statistics in menubar
local cache = {}
local module = {cache=cache}
module.ssidChanged = function()
    local network = hs.wifi.currentNetwork()
    if network then
        wifiMenu:setTitle('Wifi: ' .. network)
    else
        wifiMenu:setTitle('Wifi: No network')
    end
end
module.start = function()
    wifiMenu = hs.menubar.new()
    module.ssidChanged()
    wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()
end
module.stop = function() cache.filter:unsubscribe(wifiWatcher) end
return module
