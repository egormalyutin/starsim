return {
  russian = {
    new = (function()
      do
        local _class_0
        local _base_0 = {
          start = function(self)
            self.filter = game.ui.Filter({
              "name"
            })
            self.stars = { }
            local current = nil
            local a = nil
            self.ui.bar.button("ПРОВЕРИТЬ РЕЗУЛЬТАТЫ", function()
              return self.checkResults(self:results())
            end)
            self.ui.bar.button("НАЗВАНИЕ ЗВЕЗДЫ: ", nil, true)
            local variants = {
              "Аль Салиб",
              "Аль Укуд",
              "Суалоцин",
              "Ротанев",
              "Денеб Дулфим"
            }
            a = self.ui.bar.selectOne({
              " "
            }, function(var, text) end)
            local sf = self
            self.sky = love.graphics.newImage('modes/setName/sky.png')
            self.skyW = self.sky:getWidth()
            self.skyH = self.sky:getHeight()
            self.skyCW, self.skyCH, self.skyS = self.ui.getSize(self.ui.width, self.ui.height, self.skyW, self.skyH)
            self.skyX = self.ui.width / 2 - self.skyCW / 2
            self.skyY = self.ui.height / 2 - self.skyCH / 2
            local rets = { }
            self.rets = rets
            self.newStar = function(self, radius, x, y, right)
              x = x / 100
              y = y / 100
              radius = radius / 100
              x = x * self.skyCW
              y = y * self.skyCH
              radius = radius * self.skyCH
              x = x + self.skyX
              y = y + self.skyY
              local ret = self.ui.element({
                draw = function(self)
                  love.graphics.setColor(255, 255, 255)
                  love.graphics.circle("fill", radius, radius, radius)
                  love.graphics.setFont(game.fonts.small)
                  if self._text then
                    return love.graphics.printf(self._text, -self.width, self.height + 1, self.width * 3, 'center')
                  end
                end,
                x = x - radius,
                y = y - radius,
                width = radius * 2,
                height = radius * 2,
                mousereleased = function(self)
                  if not self._text then
                    a.current = 1
                  end
                  if self._text then
                    for name, value in pairs(variants) do
                      if self._text == value then
                        a.current = name
                      end
                    end
                  end
                  a.variants = variants
                  a.changed = function(_, text)
                    self._text = text
                  end
                  a.text.width = game.fonts.play:getWidth(a.variants[1])
                  self._text = a.variants[1]
                  return sf.ui.bar.updatePositions()
                end,
                tags = {
                  'name'
                },
                data = {
                  right = right
                }
              })
              ret._right = right
              table.insert(rets, ret)
              return ret
            end
            sf.ui.bar.updatePositions()
            local r = 2
            self:newStar(r, 14, 48, "Аль Салиб")
            self:newStar(r, 26, 55, "Аль Укуд")
            self:newStar(r, 27, 27, "Суалоцин")
            self:newStar(r, 42, 42, "Ротанев")
            self:newStar(r, 70, 56, "Денеб Дулфим")
            return self.filter:update()
          end,
          update = function(self)
            return game.ui.update(self.filter)
          end,
          draw = function(self)
            local x, y = love.mouse.getPosition()
            love.graphics.draw(self.sky, self.skyX, self.skyY + self.ui.bar.height, nil, self.skyS)
            return game.ui.draw(self.filter)
          end,
          mousepressed = function(self)
            return game.ui.mousepressed(self.filter)
          end,
          mousereleased = function(self)
            return game.ui.mousereleased(self.filter)
          end,
          results = function(self)
            local proc = 0
            local cnt = 0
            local len = #self.rets
            for _, item in ipairs(self.rets) do
              if item._text == item._right then
                cnt = cnt + 1
              end
            end
            proc = cnt / len * 100
            return proc
          end
        }
        _base_0.__index = _base_0
        _class_0 = setmetatable({
          __init = function(self, ui, content, checkResults)
            self.ui, self.content, self.checkResults = ui, content, checkResults
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
    end)(),
    name = 'ВЫБРАТЬ ЗВЕЗДУ',
    description = 'Нужно определить созвездие и назвать каждую звезду своим именем.\nНажмите на звезду, чтобы выбрать её имя.'
  },
  english = {
    new = (function()
      do
        local _class_0
        local _base_0 = {
          update = function() end,
          draw = function() end
        }
        _base_0.__index = _base_0
        _class_0 = setmetatable({
          __init = function(self, ui, content)
            self.ui, self.content = ui, content
            self.button = self.ui.bar.button('PRESS ME', function()
              return error('YOU PRESSED ME!')
            end)
            self.button = self.ui.bar.button('NOT PRESS ME', function()
              return error('YOU PRESSED ME OLOLO!')
            end)
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
    end)(),
    name = 'SELECT STAR',
    description = 'It is necessary to determine the constellation and name each star by its own name. Click on the star to select its name.'
  }
}
