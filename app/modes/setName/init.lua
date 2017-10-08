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
            self.newStar = function(self, img, x, y, items, sx, sy)
              if sx == nil then
                sx = 1
              end
              if sy == nil then
                sy = 1
              end
              local image = love.graphics.newImage(img)
              local ret = self.ui.element({
                draw = function(self)
                  love.graphics.setColor(255, 255, 255)
                  love.graphics.draw(image)
                  love.graphics.setFont(game.fonts.small)
                  if self._text then
                    return love.graphics.printf(self._text, 0, self.height + 1, self.width, 'center')
                  end
                end,
                x = x,
                y = y,
                width = 106,
                height = 106,
                sx = sx,
                sy = sy,
                mousereleased = function(self)
                  if not self._text then
                    a.current = 1
                  end
                  if self._text then
                    for name, value in pairs({
                      "Звезда №1",
                      "Звезда №2",
                      "Звезда №3",
                      "Звезда №4"
                    }) do
                      if self._text == value then
                        a.current = name
                      end
                    end
                  end
                  a.variants = {
                    "Звезда №1",
                    "Звезда №2",
                    "Звезда №3",
                    "Звезда №4"
                  }
                  a.changed = function(_, text)
                    self._text = text
                  end
                  a.text.width = game.fonts.play:getWidth(a.variants[1])
                  self._text = a.variants[1]
                  return sf.ui.bar.updatePositions()
                end,
                tags = {
                  'name'
                }
              })
              return table.insert(rets, ret)
            end
            self:newStar("resources/images/star1.png", 100, 100)
            self:newStar("resources/images/star2.png", 300, 200)
            self:newStar("resources/images/star3.png", 700, 200)
            self:newStar("resources/images/star4.png", 900, 500)
            sf.ui.bar.updatePositions()
            return self.filter:update()
          end,
          update = function(self)
            return game.ui.update(self.filter)
          end,
          draw = function(self)
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
            game.ret = self.rets[1]
            if self.rets[1]._text == "Звезда №1" then
              proc = proc + 25
            end
            if self.rets[2]._text == "Звезда №2" then
              proc = proc + 25
            end
            if self.rets[3]._text == "Звезда №3" then
              proc = proc + 25
            end
            if self.rets[4]._text == "Звезда №4" then
              proc = proc + 25
            end
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
