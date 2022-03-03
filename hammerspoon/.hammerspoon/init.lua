-- require('console').init()
hs.ipc.cliInstall()
hs.window.animationDuration = 0
local running = require("running")
local hyper = require("hyper")
local monocle = require("monocle")
local quake = require("quake")
require("border")
require("spaces")
require("wm")

hyper.bindApp({ "cmd" }, "b", function() hs.osascript.javascript([[ Application("Vivaldi").Window().make() ]]) end)
hyper.bindApp({}, "b", "Vivaldi")
hyper.bindApp({}, "f", "Finder")
hyper.bindApp({}, "t", "Kitty")
hs.hotkey.bind({ "alt" }, "z", "Zoom", function(event)
hs.hotkey.bind("alt", "tab", "Switch Window", function() running.switcher() end)
  local win = hs.window.focusedWindow() if win then monocle.toggle(win) end end)
hs.hotkey.bind({ "cmd" }, "escape", "Scratchpad", quake.toggle)
hyper.bindApp({}, "return", quake.toggle)
local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  -- print(hs.inspect(event))
  local isCmd = event:getFlags():containExactly({ "cmd" })
  local isQ = event:getKeyCode() == hs.keycodes.map["q"]
  if isCmd and isQ then
    local win = hs.window.focusedWindow()
    if win and win:application():name():find("kitty") then
      hs.alert("Use alt+cmd+q instead!")
      return true
    end
  end
end)
tap:start()
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", { start = true })
spoon.SpoonInstall:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
wm = require('wm')
-- bindings
bindings = require('bindings')
bindings.enabled = {  'wm' }

-- start/stop modules
local modules               = { bindings, wm }

hs.fnutils.each(modules, function(module)
  if module then module.start() end
end)

-- stop modules on shutdown
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then module.stop() end
  end)
end
hs.alert.show("hammerspoon instantiated")
