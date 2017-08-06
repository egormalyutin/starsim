do
  local _class_0
  local _base_0 = {
    draw = function(self)
      love.graphics.setColor(self.s.color[1], self.s.color[2], self.s.color[3])
      return love.graphics.circle("fill", self.s.x, self.s.y, self.s.radius)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, settings)
      self.settings = {
        x = 128,
        y = 128,
        radius = 32 / 2,
        color = {
          255,
          255,
          255
        }
      }
      if settings ~= nil then
        for setting, val in pairs(settings) do
          self.settings[setting] = val
        end
      end
      self.s = self.settings
    end,
    __base = _base_0,
    __name = nil
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  return _class_0
end
