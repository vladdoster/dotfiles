--- === hs.windowwatcher ===
---
--- Watches interesting events on interesting windows

-- This module abstracts hs.application.watcher and hs.uielement.watcher into a simple and coherent API
-- for users who are interested in window events. Additionally, a lot of effort is spent on cleaning up
-- the mess coming from upstream:
--   * reduntant events are never fired more than once
--   * related events are fired in the correct order (e.g. the previous window is unfocused before the
--     current one is focused)
--   * 'missing' events are filled in (e.g. a focused window that gets destroyed for any reason emits unfocused first)
--   * coherency is maintained (e.g. closing System Preferences with cmd-w has the same result as with cmd-q)
--
--
-- * There is the usual problem with spaces
-- * window(un)fullscreened is amusingly horrible and probably needs a better name
-- * window(un)maximized could be implemented (but currently isn't)
-- * Perhaps the user should be allowed to provide his own root filter for better performance
--   (e.g. if she knows all she cares about is Safari)

local type,next,pairs,ipairs,tsort,setmetatable=type,next,pairs,ipairs,table.sort,setmetatable
local windowfilter=require'hs.windowfilter'
local log=require'hs.logger'.new('wwatcher')
local delayed=require'hs.delayed'
local hsappwatcher,hsapp,hswin=require'hs.application.watcher',require'hs.application',require'hs.window'
local hsuiwatcher=require'hs.uielement'.watcher

local isGuiApp = windowfilter.isGuiApp
--TODO allow override of 'root' windowfilter

local watchers={} -- internal list for windowwatchers


local windowwatcher={} -- module and class object
local events={windowCreated=true, windowDestroyed=true, windowMoved=true,
  windowMinimized=true, windowUnminimized=true,
  windowFullscreened=true, windowUnfullscreened=true, --FIXME better names
  --TODO perhaps windowMaximized? (compare win:frame to win:screen:frame)
  windowHidden=true, windowShown=true, windowFocused=true, windowUnfocused=true,
  windowTitleChanged=true,
}
for k in pairs(events) do windowwatcher[k]=k end -- expose events
--- hs.windowwatcher.windowCreated
--- Constant
--- A new window was created

--- hs.windowwatcher.windowDestroyed
--- Constant
--- A window was destroyed

--- hs.windowwatcher.windowMoved
--- Constant
--- A window was moved or resized, including toggling fullscreen/maximize

--- hs.windowwatcher.windowMinimized
--- Constant
--- A window was minimized

--- hs.windowwatcher.windowUnminimized
--- Constant
--- A window was unminimized

--- hs.windowwatcher.windowFullscreened
--- Constant
--- A window was expanded to full screen

--- hs.windowwatcher.windowUnfullscreened
--- Constant
--- A window was reverted back from full screen

--- hs.windowwatcher.windowHidden
--- Constant
--- A window is no longer visible due to it being minimized, closed, or its application being hidden (e.g. via cmd-h) or closed

--- hs.windowwatcher.windowShown
--- Constant
--- A window has became visible (after being hidden, or when created)

--- hs.windowwatcher.windowFocused
--- Constant
--- A window received focus

--- hs.windowwatcher.windowUnfocused
--- Constant
--- A window lost focus

--- hs.windowwatcher.windowTitleChanged
--- Constant
--- A window's title changed

local apps={} -- all GUI apps
local global={} -- global state


local Window={} -- class

function Window:emitEvent(event)
  local logged
  for ww in pairs(self.wws) do
    if watchers[ww] then -- skip if wwatcher was stopped
      local fns=ww.events[event]
      if fns then
        if not logged then log.df('Emitting %s %d (%s)',event,self.id,self.app.name) logged=true end
        for fn in pairs(fns) do
          fn(self.window,self.app.name)
        end
      end
    end
  end
end

function Window:focused()
  if global.focused==self then return log.df('Window %d (%s) already focused',self.id,self.app.name) end
  global.focused=self
  self.app.focused=self
  self:emitEvent(windowwatcher.windowFocused)
end

function Window:unfocused()
  if global.focused~=self then return log.vf('Window %d (%s) already unfocused',self.id,self.app.name) end
  global.focused=nil
  self.app.focused=nil
  self:emitEvent(windowwatcher.windowUnfocused)
end

function Window:setWWatchers()
  self.wws={} -- reset in case any filters changed
  for ww in pairs(watchers) do
    self:setWWatcher(ww) -- recheck the filter for all watchers
  end
end
function Window:setWWatcher(ww)
  if ww.windowfilter:isWindowAllowed(self.window,self.app.name) then
    self.wws[ww]=true
  end
end

function Window.new(win,id,app,watcher)
  local o = setmetatable({app=app,window=win,id=id,watcher=watcher,wws={}},{__index=Window})
  if not win:isVisible() then o.isHidden = true end
  if win:isMinimized() then o.isMinimized = true end
  o.isFullscreen = win:isFullScreen()
  app.windows[id]=o
  for ww,active in pairs(watchers) do
    if active then o:setWWatcher(ww) end
  end
  o:emitEvent(windowwatcher.windowCreated)
  if not o.isHidden and not o.isMinimized then o:emitEvent(windowwatcher.windowShown) end
end

function Window:destroyed()
  delayed.cancel(self.movedDelayed)
  delayed.cancel(self.titleDelayed)
  self.watcher:stop()
  self.app.windows[self.id]=nil
  self:unfocused()
  if not self.isHidden then self:emitEvent(windowwatcher.windowHidden) end
  self:emitEvent(windowwatcher.windowDestroyed)
end
local WINDOWMOVED_DELAY=0.5
function Window:moved()
  self.movedDelayed=delayed.doAfter(self.movedDelayed,WINDOWMOVED_DELAY,Window.doMoved,self)
end

function Window:doMoved()
  self:emitEvent(windowwatcher.windowMoved)
  local fs = self.window:isFullScreen()
  local oldfs = self.isFullscreen or false
  if self.isFullscreen~=fs then
    self.isFullscreen=fs
    self:setWWatchers()
    self:emitEvent(fs and windowwatcher.windowFullscreened or windowwatcher.windowUnfullscreened)
  end
end
local TITLECHANGED_DELAY=0.5
function Window:titleChanged()
  self.titleDelayed=delayed.doAfter(self.titleDelayed,TITLECHANGED_DELAY,Window.doTitleChanged,self)
end
function Window:doTitleChanged()
  self:setWWatchers()
  self:emitEvent(windowwatcher.windowTitleChanged)
end
function Window:hidden()
  if self.isHidden then return log.df('Window %d (%s) already hidden',self.id,self.app.name) end
  self:unfocused()
  self.isHidden = true
  self:setWWatchers()
  self:emitEvent(windowwatcher.windowHidden)
end
function Window:shown()
  if not self.isHidden then return log.df('Window %d (%s) already shown',self.id,self.app.name) end
  self.isHidden = nil
  self:setWWatchers()
  self:emitEvent(windowwatcher.windowShown)
  --  if hswin.focusedWindow():id()==self.id then self:focused() end
end
function Window:minimized()
  if self.isMinimized then return log.df('Window %d (%s) already minimized',self.id,self.app.name) end
  self.isMinimized=true
  self:emitEvent(windowwatcher.windowMinimized)
  self:hidden()
end
function Window:unminimized()
  if not self.isMinimized then log.df('Window %d (%s) already unminimized',self.id,self.app.name) end
  self.isMinimized=nil
  self:shown()
  self:emitEvent(windowwatcher.windowUnminimized)
end

local appWindowEvent

local App={} -- class

function App:getFocused()
  if self.focused then return end
  local fw=self.app:focusedWindow()
  local fwid=fw and fw.id and fw:id()
  if not fwid then
    fw=self.app:mainWindow()
    fwid=fw and fw.id and fw:id()
  end
  if fwid then
    log.vf('Window %d is focused for app %s',fwid,self.name)
    if not self.windows[fwid] then
      -- windows on a different space aren't picked up by :allWindows()
      log.df('Focused window %d (%s) was not registered',fwid,self.name)
      appWindowEvent(fw,hsuiwatcher.windowCreated,nil,self.name)
    end
    if not self.windows[fwid] then
      log.wf('Focused window %d (%s) is STILL not registered',fwid,self.name)
    else
      self.focused = self.windows[fwid]
    end
  end
end

function App.new(app,appname,watcher)
  local o = setmetatable({app=app,name=appname,watcher=watcher,windows={}},{__index=App})
  if app:isHidden() then o.isHidden=true end
  --TODO is there a way to get windows in different spaces? focusedWindow() doesn't have a problem with that
  log.f('New app %s registered',appname)
  apps[appname] = o
  o:getWindows()
end

function App:getWindows()
  local windows=self.app:allWindows()
  if #windows>0 then log.df('Found %d windows for app %s',#windows,self.name) end
  for _,win in ipairs(windows) do
    appWindowEvent(win,hsuiwatcher.windowCreated,nil,self.name)
  end
  self:getFocused()
  if self.app:isFrontmost() then
    log.df('App %s is the frontmost app',self.name)
    if global.active then global.active:deactivated() end
    global.active = self
    if self.focused then
      self.focused:focused()
      log.df('Window %d is the focused window',self.focused.id)
    end
  end
end

function App:activated()
  local prevactive=global.active
  if self==prevactive then return log.df('App %s already active; skipping',self.name) end
  if prevactive then prevactive:deactivated() end
  log.vf('App %s activated',self.name)
  global.active=self
  self:getFocused()
  if not self.focused then return log.df('App %s does not (yet) have a focused window',self.name) end
  self.focused:focused()
end
function App:deactivated()
  if self~=global.active then return end
  log.vf('App %s deactivated',self.name)
  global.active=nil
  if global.focused~=self.focused then log.e('Focused app/window inconsistency') end
  --  if not self.focused then return log.ef('App %s does not have a focused window',self.name) end
  if self.focused then self.focused:unfocused() end
end
function App:focusChanged(id,win)
  if not id then return log.wf('Cannot process focus changed for app %s - no window id',self.name) end
  if self.focused and self.focused.id==id then return log.df('Window %d (%s) already focused, skipping',id,self.name) end
  local active=global.active
  if not self.windows[id] then
    appWindowEvent(win,hsuiwatcher.windowCreated,nil,self.name)
  end
  log.vf('App %s focus changed',self.name)
  if self==active then self:deactivated() end
  self.focused = self.windows[id]
  if self==active then self:activated() end
end
function App:hidden()
  if self.isHidden then return log.df('App %s already hidden, skipping',self.name) end
  for id,window in pairs(self.windows) do
    window:hidden()
  end
  log.vf('App %s hidden',self.name)
  self.isHidden=true
end
function App:shown()
  if not self.isHidden then return log.df('App %s already visible, skipping',self.name) end
  for id,window in pairs(self.windows) do
    window:shown()
  end
  log.vf('App %s shown',self.name)
  self.isHidden=nil
end
function App:destroyed()
  log.f('App %s deregistered',self.name)
  self.watcher:stop()
  for id,window in pairs(self.windows) do
    window:destroyed()
  end
  apps[self.name]=nil
end

local function windowEvent(win,event,_,appname,retry)
  log.vf('Received %s for %s',event,appname)
  local id=win and win.id and win:id()
  local app=apps[appname]
  if not id and app then
    for _,window in pairs(app.windows) do
      if window.window==win then id=window.id break end
    end
  end
  if not id then return log.ef('%s: %s cannot be processed',appname,event) end
  if not app then return log.ef('App %s is not registered!',appname) end
  local window = app.windows[id]
  if not window then return log.ef('Window %d (%s) is not registered!',id,appname) end
  if event==hsuiwatcher.elementDestroyed then
    window:destroyed()
  elseif event==hsuiwatcher.windowMoved or event==hsuiwatcher.windowResized then
    window:moved()
  elseif event==hsuiwatcher.windowMinimized then
    window:minimized()
  elseif event==hsuiwatcher.windowUnminimized then
    window:unminimized()
  elseif event==hsuiwatcher.titleChanged then
    window:titleChanged()
  end
end
local RETRY_DELAY,MAX_RETRIES = 0.2,3
local windowWatcherDelayed={}


appWindowEvent=function(win,event,_,appname,retry)
  log.vf('Received %s for %s',event,appname)
  local id = win and win.id and win:id()
  if event==hsuiwatcher.windowCreated then
    retry=(retry or 0)+1
    --    if retry>5 then return log.wf('%s: %s cannot be processed',appname,) end
    if not id then
      --      log.df('%s: window has no id%s',appname,retry>5 and ', giving up' or '')
      --      log.df('%s: %s has no id%s',appname,win.subrole and win:subrole() or (win.role and win:role()),retry>MAX_RETRIES and ', giving up' or'')
      if retry>MAX_RETRIES then log.df('%s: %s has no id',appname,win.subrole and win:subrole() or (win.role and win:role()) or 'window') end
      if retry<=MAX_RETRIES then windowWatcherDelayed[win]=delayed.doAfter(windowWatcherDelayed[win],retry*RETRY_DELAY,appWindowEvent,win,event,_,appname,retry) end
      return
    end
    if apps[appname].windows[id] then return log.df('%s: window %d already registered',appname,id) end
    local watcher=win:newWatcher(windowEvent,appname)
    if not watcher._element.pid then
      --      log.df('%s: %s has no watcher pid%s',appname,win.subrole and win:subrole() or (win.role and win:role()),retry>MAX_RETRIES and ', giving up' or'')
      if retry>MAX_RETRIES then log.df('%s: %s has no watcher pid',appname,win.subrole and win:subrole() or (win.role and win:role()) or 'window') end
      if retry<=MAX_RETRIES then windowWatcherDelayed[win]=delayed.doAfter(windowWatcherDelayed[win],retry*RETRY_DELAY,appWindowEvent,win,event,_,appname,retry) end
      return
    end
    delayed.cancel(windowWatcherDelayed[win]) windowWatcherDelayed[win]=nil
    Window.new(win,id,apps[appname],watcher)
    watcher:start({hsuiwatcher.elementDestroyed,hsuiwatcher.windowMoved,hsuiwatcher.windowResized
      ,hsuiwatcher.windowMinimized,hsuiwatcher.windowUnminimized,hsuiwatcher.titleChanged})
  elseif event==hsuiwatcher.focusedWindowChanged then
    local app=apps[appname]
    if not app then return log.ef('App %s is not registered!',appname) end
    app:focusChanged(id,win)
  end
end
local appWatcherDelayed={}

--[[
--FIXME for when the 'missing pid' bug is fixed
local function startAppWatcher(app,appname)
  if not app or not appname then log.e('Called startAppWatcher with no app') return end
  if apps[appname] then log.df('App %s already registered',appname) return end
  if app:kind()<0 or not isGuiApp(appname) then log.df('App %s has no GUI',appname) return end
  local watcher = app:newWatcher(appWindowEvent,appname)
  watcher:start({hsuiwatcher.windowCreated,hsuiwatcher.focusedWindowChanged})
  App.new(app,appname,watcher)
  if not watcher._element.pid then
    log.f('No accessibility pid for app %s',(appname or '[???]'))
  end
end
--]]
local function startAppWatcher(app,appname,retry,takeiteasy)
  if not app or not appname then log.e('Called startAppWatcher with no app') return end
  if apps[appname] then return not takeiteasy and log.df('App %s already registered',appname) end
  if app:kind()<0 or not isGuiApp(appname) then log.df('App %s has no GUI',appname) return end
  local watcher = app:newWatcher(appWindowEvent,appname)
  if watcher._element.pid then
    watcher:start({hsuiwatcher.windowCreated,hsuiwatcher.focusedWindowChanged})
    App.new(app,appname,watcher)
  else
    retry=(retry or 0)+1
    if retry>5 then return not takeiteasy and log.wf('STILL no accessibility pid for app %s, giving up',(appname or '[???]')) end
    log.df('No accessibility pid for app %s',(appname or '[???]'))
    appWatcherDelayed[appname]=delayed.doAfter(appWatcherDelayed[appname],0.2*retry,startAppWatcher,app,appname,retry)
  end
end

local function appEvent(appname,event,app,retry)
  local sevent={[0]='launching','launched','terminated','hidden','unhidden','activated','deactivated'}
  log.vf('Received app %s for %s',sevent[event],appname)
  if not appname then return end
  if event==hsappwatcher.launched then return startAppWatcher(app,appname)
  elseif event==hsappwatcher.launching then return end
  local appo=apps[appname]
  if event==hsappwatcher.activated then
    if appo then return appo:activated() end
    --    if true then return end
    retry = (retry or 0)+1
    if retry==1 then
      log.vf('First attempt at registering app %s',appname)
      startAppWatcher(app,appname,5,true)
    end
    if retry>5 then return log.df('App %s still is not registered!',appname) end
    return delayed.doAfter(0.1*retry,appEvent,appname,event,_,retry)
  end
  if not appo then return log.ef('App %s is not registered!',appname) end
  if event==hsappwatcher.terminated then return appo:destroyed()
  elseif event==hsappwatcher.deactivated then return appo:deactivated()
  elseif event==hsappwatcher.hidden then return appo:hidden()
  elseif event==hsappwatcher.unhidden then return appo:shown() end
end

local function startGlobalWatcher()
  if global.watcher then return end
  --if not next(watchers) then return end --safety
  --  if not next(events) then return end
  global.watcher = hsappwatcher.new(appEvent)
  local runningApps = hsapp.runningApplications()
  log.f('Registering %d running apps',#runningApps)
  for _,app in ipairs(runningApps) do
    startAppWatcher(app,app:title())
  end
  global.watcher:start()
end

local function stopGlobalWatcher()
  if not global.watcher then return end
  for _,active in pairs(watchers) do
    if active then return end
  end
  local totalApps = 0
  for _,app in pairs(apps) do
    for _,window in pairs(app.windows) do
      window.watcher:stop()
    end
    app.watcher:stop()
    totalApps=totalApps+1
  end
  global.watcher:stop()
  apps,global={},{}
  log.f('Unregistered %d apps',totalApps)
end

local function subscribe(self,event,fns)
  if not events[event] then error('invalid event: '..event,3) end
  if type(fns)=='function' then fns={fns} end
  if type(fns)~='table' then error('fn must be a function or table of functions',3) end
  for _,fn in ipairs(fns) do
    if type(fn)~='function' then error('fn must be a function or table of functions',3) end
    if not self.events[event] then self.events[event]={} end
    self.events[event][fn]=true
    log.df('Added callback for event %s',event)
  end
  --  self.events[event]=fn
  return self
end
local function unsubscribe(self,fn)
  for event in pairs(events) do
    if self.events[event] and self.events[event][fn] then
      log.df('Removed callback for event %s',event)
      self.events[event][fn]=nil
      if not next(self.events[event]) then
        log.df('No more callbacks for event %s',event)
        self.events[event]=nil
      end
    end
  end
  return self
end

local function unsubscribeEvent(self,event)
  if not events[event] then error('invalid event: '..event,3) end
  if self.events[event] then log.df('Removed all callbacks for event %s',event) end
  self.events[event]=nil
  return self
end


local function start(self)
  if watchers[self]==true then return end
  startGlobalWatcher()
  watchers[self]=true
  for appname,app in pairs(apps) do
    for _,window in pairs(app.windows) do
      window:setWWatcher(self)
    end
  end
end

--- hs.windowwatcher:getWindows() -> table
--- Method
--- Gets the list of windows being watched
---
--- Returns:
---  * a list of `hs.window` objects that are being watched
function windowwatcher:getWindows()
  start(self)
  local t={}
  for appname,app in pairs(apps) do
    for _,window in pairs(app.windows) do
      for ww in pairs(window.wws) do
        if ww==self then t[#t+1]=window.window end
      end
    end
  end
  -- sort by id
  tsort(t,function(a,b)return a:id()<b:id()end)
  return t
end


--- hs.windowwatcher:subscribe(event,fn)
--- Method
--- Subscribes to one or more events
---
--- Parameters:
---  * event - string or table of strings, the event(s) to subscribe to (see the `hs.windowwatcher` constants)
---  * fn - function or table of functions - the callback(s) to add for the event(s); each will be passed two parameters:
---          * a `hs.window` object referring to the event's window
---          * a string containing the application name (`window:application():title()`) for convenience
---
--- Returns:
---  * the `hs.windowwatcher` object for method chaining
function windowwatcher:subscribe(event,fn)
  start(self)
  if type(event)=='string' then return subscribe(self,event,fn)
  elseif type(event)=='table' then
    for _,e in ipairs(event) do
      subscribe(self,e,fn)
    end
    return self
  else error('event must be a string or a table of strings',2) end
end

--- hs.windowwatcher:unsubscribe(fn)
--- Method
--- Removes one or more subscriptions
---
--- Parameters:
---  * fn - it can be:
---    * a function or table of functions: the callback(s) to remove
---    * a string or table of strings: the event(s) to unsubscribe (*all* callbacks will be removed from these)
---
--- Returns:
---  * the `hs.windowwatcher` object for method chaining
---
--- Notes:
---  * If calling this on the default (or any other shared use) windowwatcher, do not pass events, as that would remove
---    *all* the callbacks for the events including ones subscribed elsewhere that you might not be aware of. Instead keep
---    references to your functions and pass in those.
function windowwatcher:unsubscribe(fn)
  if type(fn)=='string' or type(fn)=='function' then fn={fn} end--return unsubscribe(self,fn)
  if type(fn)~='table' then error('fn must be a function, string, or a table of functions or strings',2) end
  for _,e in ipairs(fn) do
    if type(e)=='string' then unsubscribeEvent(self,e)
    elseif type(e)=='function' then unsubscribe(self,e)
    else error('fn must be a function, string, or a table of functions or strings',2) end
  end
  if not next(self.events) then return self:unsubscribeAll() end
  return self
end

--- hs.windowwatcher:unsubscribeAll() -> hs.windowwatcher
--- Method
--- Removes all subscriptions
---
--- Returns:
---  * the `hs.windowwatcher` object for method chaining
---
--- Notes:
---  * You should not use this on the default windowwatcher or other shared windowwatchers
function windowwatcher:unsubscribeAll()
  self.events={}
  self:pause()
  return self
end



--- hs.windowwatcher:resume()
--- Method
--- Resumes the windowwatcher
function windowwatcher:resume()
  if watchers[self]==true then log.i('instance already running, ignoring') return end
  start(self)
end

--- hs.windowwatcher:pause()
--- Method
--- Stops the windowwatcher; no more event callbacks will be triggered, but the subscriptions remain intact for a subsequent call to `hs.windowwatcher:resume()`
function windowwatcher:pause()
  watchers[self]=nil
  stopGlobalWatcher()
end


function windowwatcher:delete()
  watchers[self]=nil
  self.events={}
  stopGlobalWatcher()
end


local spacesDone = {}
function windowwatcher.switchedToSpace(space,cb)
  if spacesDone[space] then log.v('Switched to space #'..space) return cb and cb() end
  delayed.doAfter(0.5,function()
    if spacesDone[space] then log.v('Switched to space #'..space) return cb and cb() end
    log.f('Entered space #%d, refreshing all windows',space)
    for _,app in pairs(apps) do
      app:getWindows()
    end
    spacesDone[space] = true
    return cb and cb()
  end)
end

--- hs.windowwatcher.new(windowfilter,...) -> hs.windowwatcher
--- Function
--- Creates a new windowwatcher instance. The windowwatcher uses a `hs.windowfilter` object to only receive events about specific windows
---
--- Parameters:
---  * windowfilter - if all parameters are nil (as in `myww=hs.windowwatcher.new()`), the default windowfilter will be used for this windowwatcher
--                  - if the first parameter is an already instanced `hs.windowfilter` object, then it will be used for this windowwatcher
---                 - otherwise all parameters are passed to `hs.windowfilter.new` to create a new instance
---  * ... - (optional) additional arguments passed to `hs.windowfilter.new`
---
--- Returns:
---  * a new windowwatcher instance

local function allnil(...)
  local n=select('#',...)
  for i=1,n do if select(i,...)~=nil then return end end
  return true
end
function windowwatcher.new(wf,...)
  local o = setmetatable({events={}},{__index=windowwatcher})
  if wf==nil then
    if allnil(...) then
      log.i('new windowwatcher using default windowfilter')
      o.windowfilter=windowfilter.default
    end
  elseif type(wf)=='table' and type(wf.isWindowAllowed)=='function' then
    log.i('new windowwatcher using a windowfilter instance')
    o.windowfilter=wf
  end
  if not o.windowfilter then
    log.i('new windowwatcher, creating windowfilter')
    o.windowfilter=windowfilter.new(wf,...)
  end
  return o
end

--- hs.windowwatcher.default
--- Constant
--- The default windowwatcher, which uses the default windowfilter (`hs.windowfilter.default`)
---
--- Notes:
---  * Use care when calling `:unsubscribe()`, `:unsubscribeAll()` or `:stop()` on the default windowwatcher; it might be in use elsewhere.
windowwatcher.default = windowwatcher.new()
log.i('default windowwatcher instantiated')
windowwatcher.setLogLevel=log.setLogLevel
return windowwatcher
