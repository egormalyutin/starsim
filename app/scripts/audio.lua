local Audio
do
  local _class_0
  local _base_0 = {
    play = function(self)
      if self.source:isPaused() then
        return self.source:resume()
      else
        return self.source:play()
      end
    end,
    pause = function(self)
      return self.source:pause()
    end,
    resume = function(self)
      return self.source:resume()
    end,
    toggle = function(self)
      if self.source:isPlaying() then
        return self:pause()
      else
        return self:resume()
      end
    end,
    rewind = function(self)
      return self.source:rewind()
    end,
    seek = function(self, pos, unit)
      return self.source:seek(pos, unit)
    end,
    clone = function(self, pure)
      if pure then
        return self.source:clone()
      end
      return Audio(self.source)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, source, tp)
      if type(source) == "string" then
        self.source = love.audio.newSource(source, tp)
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
