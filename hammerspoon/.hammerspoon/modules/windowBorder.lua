local w = {}

w.border = nil

function w.drawBorder()
  win = hs.window.focusedWindow()
  if win ~= nil then
    top_left = win:topLeft()
    size = win:size()
    if w.border ~= nil then
      w.border:delete()
      w.border = nil
    end

    w.border = hs.drawing.rectangle(hs.geometry.rect(top_left['x'], top_left['y'], size['w'], size['h']))
    w.border:setStrokeColor({["red"]=1.0,["blue"]=0.0,["green"]=0.0,["alpha"]=1.0})
    w.border:setFill(false)
    w.border:setStrokeWidth(8)
  end
  w.border:show()
end

function w.deleteBorder()
  if w.border ~= nil then
    w.border:delete()
    w.border = nil
  end
end

function w.manageBorder()
  w.drawBorder()
end


allwindows = hs.window.filter.new(nil)
allwindows:subscribe(hs.window.filter.windowCreated, function () w.manageBorder() end)
allwindows:subscribe(hs.window.filter.windowFocused, function () w.manageBorder() end)
allwindows:subscribe(hs.window.filter.windowMoved, function () w.manageBorder() end)
allwindows:subscribe(hs.window.filter.windowUnfocused, function () w.manageBorder() end)
