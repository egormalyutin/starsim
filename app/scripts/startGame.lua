return function(mode, content)
  if mode == nil then
    mode = (error('Mode is nil'))
  end
  if content == nil then
    content = (error('Content is nil'))
  end
  local rawModes = require('modes/list')
  local modes = { }
  for name, path in pairs(rawModes) do
    modes[name] = require('modes/' .. path)
  end
  if not modes[mode] then
    error('Mode "' .. mode .. '" not found')
  end
  game.setRoom('play')
  local Cls = modes[mode].new
  local ui = { }
  ui.button = function(text, x, y, pressed, border)
    local elem = nil
    if border then
      elem = game.ui.Element({
        draw = function(self)
          if self.hover then
            game.color(255, 255, 255, 150)
          else
            game.color(255, 255, 255, 255)
          end
          love.graphics.rectangle('line', 0, 0, self.width, self.height)
          love.graphics.setFont(game.fonts.play)
          return love.graphics.print(self._text, 3, 3)
        end,
        tags = {
          'game'
        },
        x = x,
        y = y,
        width = (game.fonts.play:getWidth(text)) + 6,
        height = (game.fonts.play:getHeight()) + 6,
        mousereleased = pressed
      })
    else
      elem = game.ui.Element({
        draw = function(self)
          if self.hover then
            game.color(255, 255, 255, 150)
          else
            game.color(255, 255, 255, 255)
          end
          love.graphics.setFont(game.fonts.play)
          return love.graphics.print(self._text)
        end,
        tags = {
          'game'
        },
        x = x,
        y = y,
        z = 1,
        width = (game.fonts.play:getWidth(text)),
        height = (game.fonts.play:getHeight()),
        mousereleased = pressed
      })
    end
    elem._text = text
    elem.setText = function(self, text)
      self._text = text
      self.width = game.fonts.play:getWidth(text)
      return self:reshape()
    end
    elem.getText = function(self)
      return self._text
    end
    rooms.ui.all:update()
    return elem
  end
  ui.line = function(x, y)
    local line = game.ui.Element({
      draw = function(self)
        game.color(255, 255, 255, 255)
        return love.graphics.line(0, 0, 0, self.height)
      end,
      tags = {
        'game'
      },
      x = x,
      y = y,
      z = 1,
      width = 1,
      height = 25
    })
    return line
  end
  ui.bar = (function(self)
    local bar = game.ui.Element({
      draw = function(self)
        love.graphics.setColor(0x19, 0x1B, 0x1F, 150)
        love.graphics.rectangle('fill', 0, 0, self.width, self.height - 1)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.line(0, self.height, self.width, self.height)
        love.graphics.setColor(0, 0, 0, 255)
        return love.graphics.rectangle('fill', 0, self.height, self.width, sizes.height)
      end,
      update = function(self)
        self.data.angle = self.data.angle + 0.0005
      end,
      tags = {
        'game'
      },
      data = {
        angle = 0
      },
      x = 0,
      y = 0,
      z = 0,
      width = sizes.width,
      height = sizes.scaleY * 50
    })
    return bar
  end)()
  ui.bar.elements = {
    {
      x = 0,
      width = 0
    }
  }
  ui.bar.updatePositions = function()
    local last = nil
    for _, elem in pairs(ui.bar.elements) do
      if last == nil then
        elem.x = 0
        last = elem
        if elem.reshape then
          elem:reshape()
        end
      else
        elem.x = last.x + last.width + 10
        elem.y = ui.bar.height / 2 - (elem.height / 2)
        last = elem
        if elem.reshape then
          elem:reshape()
        end
      end
    end
  end
  ui.bar.button = function(text, pressed)
    local lastElem = ui.bar.elements[#ui.bar.elements]
    table.insert(ui.bar.elements, (ui.button(text, 0, 0, pressed)))
    table.insert(ui.bar.elements, (ui.line(0, 0)))
    return ui.bar.updatePositions()
  end
  local preloaderName = 'Lorem ipsum dolor sit amet, cononcdentrius dsdsd'
  local preloader = game.ui.Element({
    draw = function(self)
      love.graphics.setColor(0, 0, 0, self.data.alpha)
      love.graphics.rectangle('fill', 0, 0, sizes.width, sizes.height)
      love.graphics.setColor(255, 255, 255, self.data.alpha)
      love.graphics.setFont(game.fonts.play)
      local str = string.sub(preloaderName, 0, self.data.text)
      if (#str % 3 == 1) and (#str ~= #preloaderName) then
        str = str .. '_'
      end
      return love.graphics.print(str, sizes.position.y * 10, sizes.height - sizes.position.y * 10)
    end,
    z = 3,
    data = {
      alpha = 0,
      text = 0
    },
    tags = {
      'preloader'
    }
  })
  game.timer.tween(0.7, preloader.data, {
    alpha = 255
  }, 'in-out-linear')
  game.timer.tween(1.5, preloader.data, {
    text = #preloaderName
  }, 'in-out-linear')
  rooms.ui.all = game.ui.Filter({
    'preloader'
  })
  game.playing = Cls(ui, content)
  game.playing.update = game.playing.update or function() end
  game.playing.draw = game.playing.draw or function() end
  return game.timer.after(4, function(self)
    rooms.ui.all = game.ui.Filter({
      'game',
      'preloader'
    })
    return game.timer.tween(0.3, preloader.data, {
      alpha = 0
    }, 'in-out-linear', function()
      return game.ui.destroy(preloader)
    end)
  end)
end
