local ui = {
  elements = { }
}
ui.draw = function(elements)
  if elements == nil then
    elements = { }
  end
  local args = ui.__pipeArray(elements)
  for name, element in pairs(args) do
    element:draw()
  end
end
ui.mousepressed = function(elements, x, y, button)
  if elements == nil then
    elements = { }
  end
  local args = ui.__pipeArray(elements)
  for name, element in pairs(args) do
    element:mousepressed(x, y, button)
  end
end
ui.mousereleased = function(elements, x, y, button)
  if elements == nil then
    elements = { }
  end
  local args = ui.__pipeArray(elements)
  for name, element in pairs(args) do
    element:mousereleased(x, y, button)
  end
end
ui.update = function(elements, x, y)
  if elements == nil then
    elements = { }
  end
  local args = ui.__pipeArray(elements)
  for name, element in pairs(args) do
    element:update(x, y)
  end
end
ui.destroy = function(elements)
  if elements == nil then
    elements = { }
  end
  local args = ui.__pipeArray(elements)
  for _, element in pairs(args) do
    for name, destroy in pairs(ui.elements) do
      if destroy == element then
        destroy = nil
        table.remove(ui.elements, name)
      end
    end
  end
end
ui.__pipeArray = function(elements)
  if elements.__type == "Filter" then
    return elements.elements
  else
    return elements
  end
end
ui.__filter = function(patterns)
  local res = { }
  local exists
  exists = function(element1)
    for _, element2 in pairs(res) do
      if element1 == element2 then
        return true
      end
    end
    return false
  end
  for _, pattern in pairs(patterns) do
    for _, element in pairs(ui.elements) do
      for _, tag in pairs(element.tags) do
        if (not exists(element)) then
          if type(pattern == "string") then
            if string.match(tag, pattern) then
              table.insert(res, element)
            end
          end
        end
      end
    end
  end
  return res
end
do
  local _class_0
  local _base_0 = {
    update = function(self)
      self.elements = nil
      self.elements = ui.__filter(self.patterns)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, patterns)
      self.patterns = patterns
      self.elements = ui.__filter(self.patterns)
      self.__type = "Filter"
    end,
    __base = _base_0,
    __name = "Filter"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ui.Filter = _class_0
end
do
  local _class_0
  local _base_0 = {
    draw = function(self)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.setBlendMode("alpha", "premultiplied")
      love.graphics.setCanvas(self.canvas)
      love.graphics.clear()
      self:drawFunction()
      love.graphics.setCanvas()
      love.graphics.setBlendMode("alpha")
      return love.graphics.draw(self.canvas, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    end,
    mousepressed = function(self, x, y, button)
      x = x or love.mouse.getX()
      y = y or love.mouse.getY()
      if (x > self.x) and (x < (self.x + self.width)) and (y > self.y) and (y < (self.y + self.height)) then
        if self.on.mousepressed ~= nil then
          for _, listener in pairs(self.on.mousepressed) do
            listener(x, y, button)
          end
        end
        if (self.on.mousepressedonce ~= nil) and (not self._pressed) then
          for _, listener in pairs(self.on.mousepressedonce) do
            listener(x, y, button)
          end
        end
        self._pressed = true
      end
    end,
    mousereleased = function(self, x, y, button)
      x = x or love.mouse.getX()
      y = y or love.mouse.getY()
      if (x > self.x) and (x < (self.x + self.width)) and (y > self.y) and (y < (self.y + self.height)) then
        if self.on.mousereleased ~= nil then
          for _, listener in pairs(self.on.mousereleased) do
            listener(x, y, button)
          end
        end
        if (self.on.mousereleasedonce ~= nil) and (self._pressed) then
          for _, listener in pairs(self.on.mousereleasedonce) do
            listener(x, y, button)
          end
        end
        self._pressed = false
      end
    end,
    update = function(self, x, y)
      x = x or love.mouse.getX()
      y = y or love.mouse.getY()
      if (x > self.x) and (x < (self.x + self.width)) and (y > self.y) and (y < (self.y + self.height)) then
        if self.on.mousefocus ~= nil then
          for _, listener in pairs(self.on.mousefocus) do
            listener(x, y, button)
          end
        end
        if (self.on.mousefocusonce ~= nil) and (not self._focused) then
          for _, listener in pairs(self.on.mousefocusonce) do
            listener(x, y, button)
          end
        end
        self._focused = true
      else
        if self.on.mouseblur ~= nil then
          for _, listener in pairs(self.on.mouseblur) do
            listener(x, y, button)
          end
        end
        if (self.on.mousebluronce ~= nil) and (self._focused) then
          for _, listener in pairs(self.on.mousebluronce) do
            listener(x, y, button)
          end
        end
        self._focused = false
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, s)
      self.drawFunction = s.draw or function() end
      self.drawf = self.drawFunction
      self.canvas = love.graphics.newCanvas()
      self.x = s.x
      self.y = s.y
      self.r = s.r
      self.sx = s.sx
      self.sy = s.sy
      self.ox = s.ox
      self.oy = s.oy
      self.kx = s.kx
      self.ky = s.ky
      self.data = { }
      self.width = s.width or 0
      self.height = s.height or 0
      self.tags = s.tags or { }
      table.insert(ui.elements, self)
      self.on = {
        mousepressed = s.mousepressedbare or s.pressedbare or { },
        mousepressedonce = s.mousepressed or s.pressed or { },
        mousereleased = s.mousereleasedbare or s.releasedbare or { },
        mousereleasedonce = s.mousereleased or s.released or { },
        mouseblur = s.mouseblurbare or s.blurbare or { },
        mousebluronce = s.mouseblur or s.blur or { },
        mousefocus = s.mousefocusbare or s.bare or { },
        mousefocusonce = s.mousefocus or s.focus or { }
      }
      self._focused = false
      self._pressed = false
    end,
    __base = _base_0,
    __name = "Element"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ui.Element = _class_0
end
return ui
