return function()
  return game.ui.Element({
    draw = function(self)
      game.color(255, 255, 255)
      love.graphics.setFont(game.fonts.logo)
      return game.text(phrases.name, 0, 0)
    end,
    x = sizes.position.x * 5,
    y = sizes.position.y * 5,
    tags = {
      "menu"
    }
  })
end
