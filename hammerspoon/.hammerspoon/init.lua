require("console").init()
hs.ipc.cliInstall()
hs.window.animationDuration = 0
-- local running = require("running")
-- local hyper = require("hyper")
-- local monocle = require("monocle")
-- local quake = require("quake")
require("windowMgmt.border")
-- require("spaces")
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", { start = true })
spoon.SpoonInstall:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
windowMgmt = require("windowMgmt")
-- bindings
bindings = require("bindings")
bindings.enabled = { "windows" }
local modules = { bindings, windowMgmt }
hs.fnutils.each(modules, function(module)
  if module then
    module.start()
  end
end)
-- stop modules on shutdown
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then
      module.stop()
    end
  end)
end
hs.alert.show("hammerspoon instantiated")
