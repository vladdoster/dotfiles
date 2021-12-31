local module = {}
local noop = function() end
module.start = function() -- I keep hitting cmd-h by mistake, and I never use it
    hs.hotkey.bind({'cmd'}, 'h', noop)
    hs.hotkey.bind({'cmd', 'alt'}, 'h', noop)
end
module.stop = function() end
return module
