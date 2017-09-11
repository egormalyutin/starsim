return function()
  return game.ui.Element({
    draw = function(self)
      love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(game.fonts.logo)
      return love.graphics.print(phrases.name)
    end,
    x = sizes.position.x * 5,
    y = sizes.position.y * 5,
    tags = {
      "menu",
      "settings"
    }
  })
end
