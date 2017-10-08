local getSize
getSize = function(ww, wh, w, h)
  local scale = 1
  if ww < w then
    if scale > ww / w then
      scale = ww / w
    end
  end
  if wh < h then
    if scale > wh / h then
      scale = wh / h
    end
  end
  return w * scale, h * scale
end
local getScale
getScale = function(ww, wh, w, h)
  local scale = 1
  if ww < w then
    if scale > ww / w then
      scale = ww / w
    end
  end
  if wh < h then
    if scale > wh / h then
      scale = wh / h
    end
  end
  return scale
end
local i = love.graphics.newImage('powered-by.png')
local iw = i:getWidth()
local ih = i:getHeight()
local wt, ht = love.window.getMode()
local cw, ch, s = getSize(wt, ht, iw, ih)
local x, y = wt / 2 - cw / 2, ht / 2 - ch / 2
love.draw = function()
  return love.graphics.draw(i, x, y, nil, s)
end
love.resize = function()
  wt, ht = love.window.getMode()
  cw, ch, s = getSize(wt, ht, iw, ih)
  x, y = wt / 2 - cw / 2, ht / 2 - ch / 2
end
