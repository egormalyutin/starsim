local button
button = function(x, y, text, click)
  local res = game.ui.Element({
    draw = function(self)
      game.color(255, 255, 255)
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
  res.width = (string.len(text)) * game.fonts.buttonSize
  res.height = game.fonts.buttonSize
  return res
end
return button
