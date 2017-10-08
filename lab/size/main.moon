getSize = (ww, wh, w, h) ->
	scale = 1

	if ww < w
		if scale > ww / w
			scale = ww / w

	if wh < h
		if scale > wh / h
			scale = wh / h

	w * scale, h * scale

getScale = (ww, wh, w, h) ->
	scale = 1

	if ww < w
		if scale > ww / w
			scale = ww / w

	if wh < h
		if scale > wh / h
			scale = wh / h

	scale

i  = love.graphics.newImage 'powered-by.png'
iw = i\getWidth!
ih = i\getHeight!

wt, ht = love.window.getMode!
cw, ch, s = getSize wt, ht, iw, ih
x,  y  = wt / 2 - cw / 2, ht / 2 - ch / 2

love.draw = () ->
	love.graphics.draw i, x, y, nil, s

love.resize = () ->
	wt, ht = love.window.getMode!
	cw, ch, s = getSize wt, ht, iw, ih
	x,  y  = wt / 2 - cw / 2, ht / 2 - ch / 2
