local Audio
do
  local _class_0
  local _base_0 = {
    play = function(self)
      if game.muted then
        return 
      end
      if self.source:isPaused() then
        return self.source:resume()
      else
        return self.source:play()
      end
    end,
    pause = function(self)
      if game.muted then
        return 
      end
      return self.source:pause()
    end,
    resume = function(self)
      if game.muted then
        return 
      end
      return self.source:resume()
    end,
    toggle = function(self)
      if game.muted then
        return 
      end
      if self.source:isPlaying() then
        return self:pause()
      else
        return self:resume()
      end
    end,
    rewind = function(self)
      if game.muted then
        return 
      end
      return self.source:rewind()
    end,
    seek = function(self, pos, unit)
      if game.muted then
        return 
      end
      return self.source:seek(pos, unit)
    end,
    volume = function(self, proc)
      if game.muted then
        return 
      end
      if proc then
        return self.source:setVolume(0.01 * proc)
      else
        return self.source:getVolume()
      end
    end,
    clone = function(self, pure)
      if game.muted then
        return 
      end
      if pure then
        return self.source:clone()
      end
      return Audio(self.source)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, tags, source, tp)
      if game.muted then
        return 
      end
      if type(source) == "string" then
        self.source = love.audio.newSource(source, tp)
        return self.source:setVolume(0)
      else
        self.source = source:clone()
      end
    end,
    __base = _base_0,
    __name = "Audio"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Audio = _class_0
end
return Audio
