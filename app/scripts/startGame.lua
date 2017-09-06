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
    error('Mode "' .. mode .. '" wasn\'t founded')
  end
  game.setRoom('play')
  rooms.ui.all = game.ui.Filter({
    'game'
  })
  local Cls = modes[mode]
  local ui = { }
  ui.button = function(text, x, y, pressed)
    local elem = game.ui.Element({
      draw = function(self)
        if self.hover then
          game.color(255, 255, 255, 150)
        else
          game.color(255, 255, 255, 255)
        end
        love.graphics.setFont(game.fonts.menu)
        return love.graphics.print(self.text, 0, 0)
      end,
      tags = {
        'game'
      },
      x = x,
      y = y,
      width = game.fonts.menu:getWidth(text),
      height = game.fonts.menu:getHeight(),
      mousereleased = pressed
    })
    elem.text = text
    return rooms.ui.all:update()
  end
  game.playing = Cls(ui, content)
  game.playing.update = game.playing.update or function() end
  game.playing.draw = game.playing.draw or function() end
end
