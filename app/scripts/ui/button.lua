local button
button = function(x, y, text, click)
  local res = game.ui.Element({
    draw = function(self)
      if self.focused then
        game.color(255, 255, 255, 50)
      else
        game.color(255, 255, 255)
      end
      game.font(game.fonts.menu)
      return game.text(text, 0, 0)
    end,
    x = x,
    y = y,
    mousereleased = click,
    tags = {
      "menu"
    }
  })
  res:setWidth(game.fonts.menu:getWidth(text))
  res:setHeight(game.fonts.menu:getHeight())
  res:setRotation(math.pi / 10)
  res:__reshape()
  return res
end
return button
