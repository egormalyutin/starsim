return function(x, y)
  local label = game.ui.Element({
    draw = function(self)
      game.setFont(game.fonts.menu)
      return game.text(phrases.setLanguage, 0, 0)
    end,
    x = x,
    y = y,
    tags = {
      "menu"
    }
  })
  local prevX = game.fonts.menu:getWidth(phrases.setLanguage)
  local prev = game.ui.Element({
    draw = function(self)
      game.setFont(game.fonts.menu)
      return game.text("<", 0, 0)
    end,
    x = x + prevX,
    y = y,
    tags = {
      "menu"
    }
  })
end
