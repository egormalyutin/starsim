vert = {
	100, 100
	200, 100
	200, 200
	100, 200
	100, 100
}
vert2 = {
	50, 50
	250, 50
	250, 250
	50, 250
	50, 50
}
vec   = require 'hump.vector-light'
angle = 0
r     = 0
add = (vecs, x, y) ->
	i = 1
	while i <= #vecs
		vecs[i]     -= x
		vecs[i + 1] -= y
		i += 2

mm = (vecs) ->
	i = 1

	mx = math.huge
	my = math.huge

	while i <= #vecs
		mx = vecs[i]     if vecs[i]     < mx
		my = vecs[i + 1] if vecs[i + 1] < my
		i += 2

	mx, my

love.update = (dt) ->
	angle  = dt
	r     += 0.01
	cx, cy = 150, 150

	add vert2, 3, 3	

	px, py = mm vert2
	cx += px
	cy += py

	i = 1	
	while i <= #vert - 1
		vert[i], vert[i+1] = vec.add(cx,cy, vec.rotate(angle, vert[i]-cx, vert[i+1]-cy))
		i += 2
	i = 1
	while i <= #vert2 - 1
		vert2[i], vert2[i+1] = vec.add(cx,cy, vec.rotate(angle, vert2[i]-cx, vert2[i+1]-cy))
		i += 2

love.draw = () ->
	-- love.graphics.push!
	-- love.graphics.translate 100, 100
	-- love.graphics.translate 150, 150

	-- love.graphics.rotate r
	-- love.graphics.translate -150, -150
	-- love.graphics.setColor 255, 255, 255
	-- love.graphics.rectangle 'fill', 0, 0, 300, 300
	-- love.graphics.setColor 255, 0, 0
	-- love.graphics.rectangle 'fill', 200, 200, 40, 40
	-- love.graphics.setColor 0, 255, 0
	-- love.graphics.rectangle 'fill', 10, 10, 70, 40
	-- love.graphics.pop!
	
	love.graphics.setColor 0, 255, 0
	love.graphics.polygon('fill', vert2)

	love.graphics.setColor 255, 255, 255
	love.graphics.polygon('fill', vert)