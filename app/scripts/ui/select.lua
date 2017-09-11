return function(x, y, label, vars, changed, def)
  if vars == nil then
    vars = (error('Variants is nil'))
  end
  local current = def or 1
  local buttons = { }
  buttons.label = game.ui.Element({
    draw = function(self)
      game.setFont(game.fonts.menu)
      game.color(0, 0, 0, 70)
      love.graphics.print(label, -1, -1)
      love.graphics.print(label, 1, 1)
      game.color(255, 255, 255, 255)
      return game.text(label, 0, 0)
    end,
    x = x,
    y = y,
    tags = {
      "menu"
    }
  })
  local prevX = game.fonts.menu:getWidth(phrases.setLanguage)
  local h = game.fonts.menu:getHeight()
  buttons.prev = game.ui.Element({
    draw = function(self)
      if current - 1 > 0 then
        game.setFont(game.fonts.menu)
        game.color(0, 0, 0, 70)
        love.graphics.print("<", -1, -1)
        love.graphics.print("<", 1, 1)
        if self.hover then
          game.color(255, 255, 255, 150)
        else
          game.color(255, 255, 255, 255)
        end
        return game.text("<", 0, 0)
      end
    end,
    x = x + prevX,
    y = y,
    width = game.fonts.menu:getWidth('<'),
    height = h,
    tags = {
      "menu"
    },
    mousereleased = function()
      if current - 1 > 0 then
        current = current - 1
        buttons.var.width = game.fonts.menu:getWidth(vars[current])
        buttons.var:reshape()
        buttons.next.x = buttons.var.x + buttons.var.width + 6
        buttons.next:reshape()
        return changed(current, vars)
      end
    end
  })
  local varX = prevX + (game.fonts.menu:getWidth('<')) + 6
  buttons.var = game.ui.Element({
    draw = function(self)
      game.setFont(game.fonts.menu)
      game.color(0, 0, 0, 70)
      love.graphics.print(vars[current], -1, -1)
      love.graphics.print(vars[current], 1, 1)
      game.color(255, 255, 255, 255)
      return game.text(vars[current], 0, 0)
    end,
    x = x + varX,
    y = y,
    width = game.fonts.menu:getWidth(vars[current]),
    height = h,
    tags = {
      "menu"
    }
  })
  buttons.next = game.ui.Element({
    draw = function(self)
      if current + 1 <= #vars then
        game.setFont(game.fonts.menu)
        game.color(0, 0, 0, 70)
        love.graphics.print(">", -1, -1)
        love.graphics.print(">", 1, 1)
        if self.hover then
          game.color(255, 255, 255, 150)
        else
          game.color(255, 255, 255, 255)
        end
        return game.text('>', 0, 0)
      end
    end,
    x = buttons.var.x + buttons.var.width + 6,
    y = y,
    width = game.fonts.menu:getWidth('>'),
    height = h,
    tags = {
      "menu"
    },
    mousereleased = function()
      if current + 1 <= #vars then
        current = current + 1
        buttons.var.width = game.fonts.menu:getWidth(vars[current])
        buttons.var:reshape()
        buttons.next.x = buttons.var.x + buttons.var.width + 6
        buttons.next:reshape()
        return changed(current, vars)
      end
    end
  })
end
