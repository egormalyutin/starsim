cool = require 'cool'
gjk  = require 'HC.gjk'
vec  = require 'HC.vector-light'
coll = false

love.load = () ->
	export rect, mouse
	rect  = cool.rectangle 0, 0, 100, 100
	mouse = cool.rectangle 500, 500, 30, 30

love.draw = () -> 
	love.graphics.setColor 255, 255, 255
	rect\draw  'fill'

	if coll
		love.graphics.setColor 255, 0, 0
	else
		love.graphics.setColor 255, 255, 255
	mouse\draw 'fill'

love.mousemoved = (x, y) ->
	mouse\moveTo x - 15, y - 15
	coll = mouse\check rect
