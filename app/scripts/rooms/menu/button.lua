local button
button = function(x, y, text, click)
  local res = game.ui.Element({
    draw = function(self)
      if self.hover then
        game.color(255, 255, 255, 120)
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
  res.width = game.fonts.menu:getWidth(text)
  res.height = game.fonts.menu:getHeight()
  return res
end
return button
