local status = hs.watchable.new('status')
local log = hs.logger.new('watchables', 'debug')
local cache = {status=status}
local module = {cache=cache}
-- battery
function batt_watch_changed(changed)
    pct = changed.percentage
    if not hs.battery.isCharging() and pct and pct < 5 then
        hs.alert.show(string.format('Plug-in the power, only %d%% left!!', pct))
    end
end
local batt_prev = {}
function batt_wrapper_changed()
    local batt_info, changed = hs.battery.getAll(), {}
    for key, new_val in pairs(batt_info) do if new_val ~= batt_prev[key] then changed[key] = new_val end end
    batt_prev = batt_info
    batt_watch_changed(changed)
end
-- start watchers
module.start = function() battery = hs.battery.watcher.new(batt_wrapper_changed):start() end
module.stop = function() battery:stop() end
return module
