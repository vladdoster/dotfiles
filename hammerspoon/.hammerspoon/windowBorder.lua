hs.window.filter.forceRefreshOnSpaceChange = true
local desktop = require('utils.desktop')
local running = require('utils.running')
local spaces = require('hs._asm.undocumented.spaces')

local module = {widget = hs.canvas.new({})}

local wb = hs.canvas.windowBehaviors

module.widget:level(hs.canvas.windowLevels.floating)
module.widget:clickActivating(false)
module.widget:_accessibilitySubrole('AXUnknown')
module.widget:behavior({wb.default, wb.transient})

module.update = function()
  module.widget:hide()
  local win = hs.window.focusedWindow()
  if win == nil or not win:application() or not win:application():isRunning() or not win:isVisible() then return end
  local current, found = spaces.activeSpace(), false
  for _, space in ipairs(win:spaces()) do if space == current then found = true end end
  if not found then win = nil end
  if win ~= nil and win:subrole() == 'AXStandardWindow' and win:isVisible() and not win:isFullScreen() then
    module.widget:frame(hs.screen.mainScreen():fullFrame())
    local alpha, border, offset, radius = 0.9, 4, 2, 10
    local size, top_left = win:size(), win:topLeft()
    module.widget:replaceElements({
      action = 'build',
      frame = {
        x = top_left['x'] - offset,
        y = top_left['y'] - offset,
        h = size['h'] + offset * 2,
        w = size['w'] + offset * 2
      },
      type = 'rectangle',
      roundedRectRadii = {xRadius = radius, yRadius = radius},
      withShadow = true
    }, {
      action = 'fill',
      frame = {
        x = top_left['x'] + border - offset,
        y = top_left['y'] + border - offset,
        h = size['h'] - border * 2 + offset * 2,
        w = size['w'] - border * 2 + offset * 2
      },
      type = 'rectangle',
      reversePath = true,
      roundedRectRadii = {xRadius = radius - border, yRadius = radius - border},
      withShadow = false,
      fillColor = {alpha = alpha, red = 6 / 255, green = 182 / 255, blue = 239 / 255}
    }):show()
  end
end
running.onChange(function(_app, _win, _event) module.update() end)

local watcher = hs.spaces.watcher.new(module.update)

watcher:start()
desktop.onChange(module.update)
module.update()

return module

-- another more general logger/delayed/windowfilter/windowf.tcher example
