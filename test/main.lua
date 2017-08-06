local Rectangle = require('scripts/classes/rectangle')
local Circle = require('scripts/classes/circle')
local Image = require('scripts/classes/image')
local dev_enable
dev_enable = function() end
local dev_disable
dev_disable = function() end

love.load = function()
  love.window.setTitle('GAME')
  love.graphics.setBackgroundColor(0, 0, 0)
  g = { }
  g.hero = Rectangle()
  g.enemy = Circle()
  g.pressed = love.keyboard.isDown
  image = Image({
    path = "resources/images/sprites/star1.png"
  })
end
love.update = function(dt)
  
end
love.draw = function()
  g.hero:draw()
  g.enemy:draw()
  return image:draw()
end
