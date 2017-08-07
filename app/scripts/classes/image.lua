do
  local _class_0
  local _base_0 = {
    draw = function(self)
      return love.graphics.draw(self.image, self.s.x, self.s.y, nil, self.s.scale.x, self.s.scale.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, settings)
      self.settings = {
        x = 128,
        y = 128,
        width = 32,
        height = 32,
        scale = {
          x = 1,
          y = 1
        },
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
      self.image = love.graphics.newImage(self.s.path)
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
