local cool = require('cool')
local gjk = require('HC.gjk')
local vec = require('HC.vector-light')
local coll = false
love.load = function()
  rect = cool.rectangle(0, 0, 100, 100)
  mouse = cool.rectangle(500, 500, 30, 30)
end
love.draw = function()
  love.graphics.setColor(255, 255, 255)
  rect:draw('fill')
  if coll then
    love.graphics.setColor(255, 0, 0)
  else
    love.graphics.setColor(255, 255, 255)
  end
  return mouse:draw('fill')
end
love.mousemoved = function(x, y)
  mouse:moveTo(x - 15, y - 15)
  coll = mouse:check(rect)
end
