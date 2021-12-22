-- module: Battery notifications
local m = {}
local battery = require('hs.battery')
local isCharged, percentage, powerSource = battery.isCharged(), battery.percentage(), battery.powerSource()
-- send a notification about the battery status
local function batteryNotify(statusType, subTitle, message)
    hs.notify.new({
        title = statusType .. ' Status',
        subTitle = subTitle,
        soundName = 'Ping.aiff', -- /System/Library/Sounds/Ping.aiff
        informativeText = message,
        hasActionButton = false,
        autoWithdraw = true
    }):send()
end
-- battery watching callback sends a notification if charging status
-- has changed, or power thresholds have been reached.
local function watchFunc()
    local newPercentage = battery.percentage()
    local newIsCharged = battery.isCharged()
    local newPowerSource = battery.powerSource()
    if newPercentage < 100 then isCharged = false end
    if newIsCharged ~= isCharged and newPercentage == 100 and newPowerSource == 'AC Power' then
        batteryNotify('Battery', 'Completely Charged')
        isCharged = true
    end
    local threshold = 5 -- 5% of battery
    if (newPercentage <= threshold and newPowerSource == "Battery Power") then
        local timeRemaining = hs.battery.timeRemaining()
        batteryNotify('Low Battery', 'Time Remaining:', 'is ' .. timeRemaining .. ' minutes')
    end
    if newPowerSource ~= powerSource and newPowerSource == "Battery Power" then
        batteryNotify('Power Source Change', 'Current :', newPowerSource)
        powerSource = newPowerSource
    end
end
function m.start() m.watcher = hs.battery.watcher.new(watchFunc):start() end
function m.stop()
    m.watcher:stop()
    m.watcher = nil
end
return m
