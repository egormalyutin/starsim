cool = {}

class cool.rectangle 
	new: (@x, @y, @width, @height) =>

	draw: (method) =>
		love.graphics.rectangle method, @x, @y, @width, @height

	check: (b) =>
		return true if not((@x + @width < b.x or b.x + b.width < @x) or (@y + @height < b.y or b.y + b.height < @y))
		return false

	moveTo: (@x, @y) =>

cool