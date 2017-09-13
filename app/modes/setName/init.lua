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
            self.newStar = function(self, img, x, y, items, sx, sy)
              if sx == nil then
                sx = 1
              end
              if sy == nil then
                sy = 1
              end
              local ret = self.ui.element({
                draw = function(self)
                  love.graphics.setColor(255, 255, 255)
                  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
                  love.graphics.setFont(game.fonts.small)
                  if self._text then
                    return love.graphics.printf(self._text, 0, self.height + 1, self.width, 'center')
                  end
                end,
                x = x,
                y = y,
                width = 100,
                height = 100,
                sx = sx,
                sy = sy,
                mousereleased = function(self)
                  return error('SELECT')
                end,
                tags = {
                  'name'
                }
              })
              ret.items = items
              ret.setItem = function(self, _text)
                self._text = _text
              end
            end
            self.star = self:newStar(100, 100)
            self.ui.bar.select({
              'LOL',
              'KEKLOLKEK',
              'sihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjssssssssssssssssssssssssssssssssssssss',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'dsdsd',
              'sdds',
              'dsdsd',
              'dsdsd',
              'dsdsd'
            }, function(var, text) end)
            return self.filter:update()
          end,
          update = function(self)
            return game.ui.update(self.filter)
          end,
          draw = function(self)
            return game.ui.draw(self.filter)
          end,
          mousepressed = function(self)
            return game.ui.mousepressed(self.filter)
          end,
          mousereleased = function(self)
            return game.ui.mousereleased(self.filter)
          end
        }
        _base_0.__index = _base_0
        _class_0 = setmetatable({
          __init = function(self, ui, content)
            self.ui, self.content = ui, content
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
