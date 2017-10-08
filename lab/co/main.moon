r = 0

love.update = (dt) ->
	r += dt

love.draw = () ->
	love.graphics.push!
	love.graphics.translate 100, 100
	love.graphics.translate 150, 150
	love.graphics.rotate r
	love.graphics.translate -150, -150
	love.graphics.setColor 255, 255, 255
	love.graphics.rectangle 'fill', 0, 0, 300, 300
	love.graphics.setColor 255, 0, 0
	love.graphics.rectangle 'fill', 200, 200, 40, 40
	love.graphics.setColor 0, 255, 0
	love.graphics.rectangle 'fill', 10, 10, 70, 40
	love.graphics.pop!