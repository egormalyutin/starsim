return function()
  return game.ui.Element({
    draw = function(self)
      game.color(255, 255, 255)
      love.graphics.setFont(game.fonts.logo)
      game.text(phrases.name, 0, 0)
      love.graphics.setLineWidth(10)
      return love.graphics.setLineStyle("rough")
    end,
    x = sizes.position.x * 5,
    y = sizes.position.y * 5,
    tags = {
      "menu",
      "settings"
    }
  })
end
