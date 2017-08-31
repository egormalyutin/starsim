return function(x, y, click)
  return game.ui.Element({
    draw = function(self)
      game.setFont(game.fonts.menu)
      love.graphics.setLineWidth(10)
      love.graphics.setLineStyle("rough")
      love.graphics.line(20, self.height / 3 * 2, self.width, self.height / 3 * 2)
      love.graphics.circle("fill", self.data.active, 20, 10)
      love.graphics.print(self.data.text, self.width + 10, 0)
    end,
    update = function(self, x, y)
      if (self.hover) and (self.pressed) and (x > 20) and (x < self.width + 40) then
        self.data.active = x - 10
        self.data.text = math.floor((x - 20) / (self.width + 20) * 100) .. "%"
        return self:redraw()
      end
    end,
    x = x,
    y = y,
    height = 30,
    width = 300,
    data = {
      active = 20,
      text = "0%"
    },
    mousereleased = click,
    tags = {
      "menu"
    }
  })
end
