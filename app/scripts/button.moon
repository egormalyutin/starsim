return class 
	new: (@text, @x, @y, @limit) =>

	draw: () =>
		love.graphics.printf @text, @x, @y, @limit