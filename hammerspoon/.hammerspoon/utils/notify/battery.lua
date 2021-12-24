-- module: Battery notifications
local m = {}
local battery = require('hs.battery')
local isCharged, powerSource = battery.isCharged(), battery.powerSource()
local notifThreshold = 5 -- 5% of battery
-- send a notification about the battery status
local function batteryNotify(statusType, subTitle, message)
    hs.notify.new({
        title = statusType .. ' Alert',
        subTitle = subTitle,
        soundName = 'Ping.aiff', -- /System/Library/Sounds/Ping.aiff
        informativeText = message,
        hasActionButton = false,
        autoWithdraw = true
    }):send()
end
-- battery watching callback sends a notification if charging status has changed or power thresholds are reached.
local function watchFunc()
    local newPercentage = battery.percentage()
    local newIsCharged = battery.isCharged()
    local newPowerSource = battery.powerSource()
    if newPercentage < 100 then isCharged = false end
    if newPowerSource ~= powerSource then
        batteryNotify('Power Source Change', 'Source: ' .. newPowerSource)
        powerSource = newPowerSource
        hs.brightness.set(100)
    end
    if newPercentage <= notifThreshold and newPowerSource == "Battery Power" then
        local timeRemaining = battery.timeRemaining()
        batteryNotify('Low Battery', 'Time Remaining: ' .. timeRemaining .. ' minutes')
    end
    if newIsCharged ~= isCharged and newPercentage == 100 and newPowerSource == 'AC Power' then
        batteryNotify('Battery', 'Completely Charged')
        isCharged = true
    end
end
function m.start() m.watcher = hs.battery.watcher.new(watchFunc):start() end
function m.stop()
    m.watcher:stop()
    m.watcher = nil
end
return m
