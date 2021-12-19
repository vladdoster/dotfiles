local pathwatcher = require('hs.pathwatcher')
local reloadHS = require('ext.system').reloadHS

return pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', function(files)
    local shouldReload = false
    for _, file in pairs(files) do if file:sub(-4) == '.lua' then execReload = true end end
    if execReload then reloadHS() end
end)
