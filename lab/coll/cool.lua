local cool = { }
do
  local _class_0
  local _base_0 = {
    draw = function(self, method)
      return love.graphics.rectangle(method, self.x, self.y, self.width, self.height)
    end,
    check = function(self, b)
      if not ((self.x + self.width < b.x or b.x + b.width < self.x) or (self.y + self.height < b.y or b.y + b.height < self.y)) then
        return true
      end
      return false
    end,
    moveTo = function(self, x, y)
      self.x, self.y = x, y
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      self.x, self.y, self.width, self.height = x, y, width, height
    end,
    __base = _base_0,
    __name = "rectangle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  cool.rectangle = _class_0
end
return cool
