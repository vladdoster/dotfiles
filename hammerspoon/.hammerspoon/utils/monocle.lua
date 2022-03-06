local module = { state = {} }
module.toggle =
  ---@param win hs.window
  function(win)
    local screenFrame = win:screen():frame()
    screenFrame = hs.geometry.new({
      screenFrame.x + 4,
      screenFrame.y + 0 + 4,
      screenFrame.w - 2 * 4,
      screenFrame.h - 0 - 2 * 4,
    })
    if win:frame():equals(screenFrame) then
      -- restore state
      if module.state[win:id()] ~= nil then
        win:setFrame(module.state[win:id()])
        module.state[win:id()] = nil
      end
    else
      -- save state and maximise
      module.state[win:id()] = win:frame()
      win:setFrame(screenFrame)
    end
  end
return module
