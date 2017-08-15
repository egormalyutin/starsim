ui = {
	elements: {}
}

-----------------------
-- EVENETS
-----------------------

ui.draw = (elements = {}) ->
	args = ui.__pipeArray elements
	for name, element in pairs args
		element\draw!

ui.mousepressed = (elements = {}, x, y, button) ->
	args = ui.__pipeArray elements
	for name, element in pairs args
		element\mousepressed x, y, button

ui.mousereleased = (elements = {}, x, y, button) ->
	args = ui.__pipeArray elements
	for name, element in pairs args
		element\mousereleased x, y, button

ui.update = (elements = {}, x, y) ->
	args = ui.__pipeArray elements
	for name, element in pairs args
		element\update x, y

ui.destroy = (elements = {}) ->
	args = ui.__pipeArray elements
	for _, element in pairs args
		for name, destroy in pairs ui.elements
			if destroy == element
				destroy = nil
				table.remove ui.elements, name 


-----------------------
-- HELPERS
-----------------------

ui.__pipeArray = (elements) ->
	if elements.__type == "Filter"
		return elements.elements
	else
		return elements

ui.__filter = (patterns) ->
	res = {}

	exists = (element1) ->
		for _, element2 in pairs res
			if element1 == element2
				return true
		return false

	for _, pattern in pairs patterns
		for _, element in pairs ui.elements
			for _, tag in pairs element.tags
				if (not exists element)
					if type pattern == "string"
						if string.match tag, pattern
							table.insert res, element

	res


-----------------------
-- CLASSES
-----------------------

ui.Filter = class
	new: (patterns) =>
		@patterns = patterns
		@elements = ui.__filter @patterns
		@__type = "Filter"

	update: =>
		@elements = nil	
		@elements = ui.__filter @patterns

ui.Element = class
	new: (s) =>
		@drawFunction = s.draw or () ->
		@drawf = @drawFunction
		@canvas = love.graphics.newCanvas!

		@x  = s.x
		@y  = s.y
		@r  = s.r
		@sx = s.sx
		@sy = s.sy
		@ox = s.ox
		@oy = s.oy
		@kx = s.kx
		@ky = s.ky

		@data = {}

		@width  = s.width  or 0
		@height = s.height or 0

		@tags   = s.tags or {}

		table.insert ui.elements, @

		@on =
			mousepressed:       s.mousepressedbare  or s.pressedbare  or {}
			mousepressedonce:   s.mousepressed      or s.pressed      or {}
			mousereleased:      s.mousereleasedbare or s.releasedbare or {}
			mousereleasedonce:  s.mousereleased     or s.released     or {}
			mouseblur:          s.mouseblurbare     or s.blurbare     or {}
			mousebluronce:      s.mouseblur         or s.blur         or {}
			mousefocus:         s.mousefocusbare    or s.bare         or {}
			mousefocusonce:     s.mousefocus        or s.focus        or {}

		@_focused = false
		@_pressed = false

	draw: =>
		-- Blend mode
    	love.graphics.setColor(255, 255, 255, 255)
    	love.graphics.setBlendMode("alpha", "premultiplied")
		
		-- Drawing
		love.graphics.setCanvas @canvas	
        love.graphics.clear!
		@drawFunction!

		-- Return to main canvas and blend mode
		love.graphics.setCanvas!
		love.graphics.setBlendMode("alpha")

		-- Draw
		love.graphics.draw @canvas, @x, @y, @r, @sx, @sy, @ox, @oy, @kx, @ky

	mousepressed: (x, y, button) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		if (x > @x) and (x < (@x + @width)) and (y > @y) and (y < (@y + @height)) -- Check mouse
			if @on.mousepressed ~= nil
				for _, listener in pairs @on.mousepressed
						listener x, y, button

			if (@on.mousepressedonce ~= nil) and (not @_pressed)
				for _, listener in pairs @on.mousepressedonce
						listener x, y, button	
			@_pressed = true

	mousereleased: (x, y, button) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		if (x > @x) and (x < (@x + @width)) and (y > @y) and (y < (@y + @height)) -- Check mouse
			if @on.mousereleased ~= nil
				for _, listener in pairs @on.mousereleased
						listener x, y, button

			if (@on.mousereleasedonce ~= nil) and (@_pressed)
				for _, listener in pairs @on.mousereleasedonce
						listener x, y, button	
			@_pressed = false

	update: (x, y) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		if (x > @x) and (x < (@x + @width)) and (y > @y) and (y < (@y + @height)) -- Check mouse
			if @on.mousefocus ~= nil
				for _, listener in pairs @on.mousefocus
						listener x, y, button

			if (@on.mousefocusonce ~= nil) and (not @_focused)
				for _, listener in pairs @on.mousefocusonce
						listener x, y, button	
			@_focused = true
		else
			if @on.mouseblur ~= nil
				for _, listener in pairs @on.mouseblur
						listener x, y, button

			if (@on.mousebluronce ~= nil) and (@_focused)
				for _, listener in pairs @on.mousebluronce
						listener x, y, button	
			@_focused = false

return ui