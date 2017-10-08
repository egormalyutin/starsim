local vert = {
  100,
  100,
  200,
  100,
  200,
  200,
  100,
  200,
  100,
  100
}
local vert2 = {
  50,
  50,
  250,
  50,
  250,
  250,
  50,
  250,
  50,
  50
}
local vec = require('hump.vector-light')
local angle = 0
local r = 0
local add
add = function(vecs, x, y)
  local i = 1
  while i <= #vecs do
    vecs[i] = vecs[i] - x
    vecs[i + 1] = vecs[i + 1] - y
    i = i + 2
  end
end
local mm
mm = function(vecs)
  local i = 1
  local mx = math.huge
  local my = math.huge
  while i <= #vecs do
    if vecs[i] < mx then
      mx = vecs[i]
    end
    if vecs[i + 1] < my then
      my = vecs[i + 1]
    end
    i = i + 2
  end
  return mx, my
end
love.update = function(dt)
  angle = dt
  r = r + 0.01
  local cx, cy = 150, 150
  add(vert2, 3, 3)
  local px, py = mm(vert2)
  cx = cx + px
  cy = cy + py
  local i = 1
  while i <= #vert - 1 do
    vert[i], vert[i + 1] = vec.add(cx, cy, vec.rotate(angle, vert[i] - cx, vert[i + 1] - cy))
    i = i + 2
  end
  i = 1
  while i <= #vert2 - 1 do
    vert2[i], vert2[i + 1] = vec.add(cx, cy, vec.rotate(angle, vert2[i] - cx, vert2[i + 1] - cy))
    i = i + 2
  end
end
love.draw = function()
  love.graphics.setColor(0, 255, 0)
  love.graphics.polygon('fill', vert2)
  love.graphics.setColor(255, 255, 255)
  return love.graphics.polygon('fill', vert)
end
