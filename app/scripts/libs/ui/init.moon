ui = {
	elements: {}
}

_NAME = (...)

hc = require _NAME .. '.HC'

ui.mouse = hc.circle 0,0,1
ui.mouse\moveTo(love.mouse.getPosition())

ui.obj = hc.rectangle 100, 100, 200, 200

-----------------------
-- EVENTS
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

ui.update = (elements = {}, x, y, dt) ->
	ui.mouse\moveTo(love.mouse.getPosition())
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

ui.__checkMouse = (elem) ->
	for shape, delta in pairs hc.collisions ui.mouse
		if shape == elem._shape
			return true

	false


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
		@drawFunction   = s.draw   or () ->
		@updateFunction = s.update or () ->
		@drawf   =   @drawFunction
		@updatef = @updateFunction
		@canvas = love.graphics.newCanvas!

		@_x  = s.x  or 0
		@_y  = s.y  or 0
		@_r  = s.r  or 0
		@_sx = s.sx or 1
		@_sy = s.sy or 1
		@_ox = s.ox or 0
		@_oy = s.oy or 0
		@_kx = s.kx or 0
		@_ky = s.ky or 0

		if not @_x then @_x = 0
		if not @_y then @_y = 0

		@data = s.data or {}

		@_width  = s.width  or 1
		@_height = s.height or 1

		@tags   = s.tags or {}

		table.insert ui.elements, @

		@_shape = hc.rectangle @_x, @_y, @_width, @_height

		@\__reshape!

		@on = {}

		if type(s.mousepressedbare) == "function"
			@on.mousepressedbare = { s.mousepressedbare }
		else
			@on.mousepressedbare = s.mousepressedbare

		if type(s.mousepressed) == "function"
			@on.mousepressed = { s.mousepressed }
		else
			@on.mousepressed = s.mousepressed

		-----------

		if type(s.mousereleasedbare) == "function"
			@on.mousereleasedbare = { s.mousereleasedbare }
		else
			@on.mousereleasedbare = s.mousereleasedbare

		if type(s.mousereleased) == "function"
			@on.mousereleased = { s.mousereleased }
		else
			@on.mousereleased = s.mousereleased

		-----------

		if type(s.mousefocusbare) == "function"
			@on.mousefocusbare = { s.mousefocusbare }
		else
			@on.mousefocusbare = s.mousefocusbare

		if type(s.mousefocus) == "function"
			@on.mousefocus = { s.mousefocus }
		else
			@on.mousefocus = s.mousefocus

		-----------

		if type(s.mouseblurbare) == "function"
			@on.mouseblurbare = { s.mouseblurbare }
		else
			@on.mouseblurbare = s.mouseblurbare

		if type(s.mouseblur) == "function"
			@on.mouseblur = { s.mouseblur }
		else
			@on.mouseblur = s.mouseblur

		@_focused = false
		@_pressed = false

		-- Draw on canvas
		love.graphics.setCanvas @canvas	
		love.graphics.clear!
		@drawFunction!
		-- Set default canvas
		love.graphics.setCanvas!

	redraw: =>
		-- Draw on canvas
		love.graphics.setCanvas @canvas	
		love.graphics.clear!
		@drawFunction!
		-- Set default canvas
		love.graphics.setCanvas!

	draw: =>
		------------------- NOW USING "REDRAW"
		-- -- Draw on canvas
		-- love.graphics.setCanvas @canvas	
  		-- love.graphics.clear!
		-- @drawFunction!

		-- -- Set default canvas
		-- love.graphics.setCanvas!

		-- Draw canvas
		love.graphics.setCanvas @output
    	love.graphics.setColor(255, 255, 255, 255)
    	love.graphics.setBlendMode("alpha", "premultiplied")
		love.graphics.draw @canvas, @_x, @_y, @_r, @_sx, @_sy, @_ox, @_oy, @_kx, @_ky

		-- Set default blend mode
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas!

	------------------------
	-- GETTERS AND SETTERS
	------------------------

	__reshape: =>
		@_shape = hc.rectangle @_x, @_y, @_width, @_height
		@_shape\setRotation @\getRotation!, @_x + @\getOffsetX!, @_y + @\getOffsetY!



	setX: (x) =>
		@_x = x
		@\__reshape!
		return
	getX: =>
		@_x

	setY: (y) =>
		@_y = y
		@\__reshape!
		return
	getY: =>
		@_y

	setPosition: (x, y) =>
		@\setX x or @\getX!
		@\setY y or @\getY!
		@\__reshape!
		return
	getPosition: =>
		@\getX!, @\getY!



	setWidth: (w) =>
		@_width = w or 1
		@\__reshape!
		return
	getWidth: =>
		@_width

	setHeight: (h) =>
		@_height = h or 1
		@\__reshape!
		return
	getHeight: =>
		@_height

	setSize: (w, h) =>
		@\setWidth  w or  @\getWidth!
		@\setHeight h or @\getHeight!
		@\__reshape!
		return
	getSize: () =>
		@\getWidth!, @\getHeight!



	setRotation: (r) =>
		@_r = r
		@\__reshape!
	getRotation: () =>
		@_r



	setScaleX: (x) =>
		@_sx = x
		@\__reshape!
	getScaleX: () =>
		@_sx

	setScaleY: (y) =>
		@_sy = y
		@\__reshape!
	getScaleY: () =>
		@_sy

	setScale: (x, y) =>
		@\setScaleX x or @\getScaleX!
		@\setScaleY y or @\getScaleY!
		@\__reshape!
		return
	getScale: () =>
		@\getScaleX!, @\getScaleY!



	setOffsetX: (x) =>
		@_ox = x
		@\__reshape!
	getOffsetX: () =>
		@_ox

	setOffsetY: (y) =>
		@_oy = y
		@\__reshape!
	getOffsetY: () =>
		@_oy

	setOffset: (x, y) =>
		@\setOffsetX x or @\getOffsetX!
		@\setOffsetY y or @\getOffsetY!
		@\__reshape!
		return
	getOffset: () =>
		@\getOffsetX!, @\getOffsetY!



	setShearingX: (x) =>
		@_kx = x
		@\__reshape!
	getShearingX: () =>
		@_kx

	setShearingY: (y) =>
		@_ky = y
		@\__reshape!
	getShearingY: () =>
		@_ky

	setShearing: (x, y) =>
		@\setShearingX x or @\getShearingX!
		@\setShearingY y or @\getShearingY!
		@\__reshape!
		return
	getShearing: () =>
		@\getShearingX!, @\getShearingY!

	mousepressed: (x, y, button) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		if ui.__checkMouse @
			if @on.mousepressedbare ~= nil
				for _, listener in pairs @on.mousepressedbare
						listener @, x, y, button

			if (@on.mousepressed ~= nil) and (not @_pressed)
				for _, listener in pairs @on.mousepressed
						listener @, x, y, button	
			@\__setPressed true

	mousereleased: (x, y, button) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		if ui.__checkMouse @
			if @on.mousereleasedbare ~= nil
				for _, listener in pairs @on.mousereleasedbare
						listener @, x, y, button

			if (@on.mousereleased ~= nil) and (@_pressed)
				for _, listener in pairs @on.mousereleased
						listener @, x, y, button	

			@\__setPressed false

	update: (x, y) =>
		x = x or love.mouse.getX!
		y = y or love.mouse.getY!

		@updateFunction x, y

		if ui.__checkMouse @
			if @on.mousefocusbare ~= nil
				for _, listener in pairs @on.mousefocusbare
						listener @, x, y, button

			if (@on.mousefocus ~= nil) and (not @_focused)
				for _, listener in pairs @on.mousefocus
						listener @, x, y, button	

			@\__setFocused true
		else
			if @on.mouseblurbare ~= nil
				for _, listener in pairs @on.mouseblurbare
						listener @, x, y, button

			if (@on.mouseblur ~= nil) and (@_focused)
				for _, listener in pairs @on.mouseblur
						listener @, x, y, button	

			@\__setFocused false

	__setPressed: (value) =>
		@_pressed = value
		@pressed  = value
		@press    = value
		@_release  = not value
		@_released = not value

	__setFocused: (value) =>
		@_focused = value
		@focused  = value
		@focus    = value
		@hover    = value
		@hovered  = value
		@blured   = not value
		@blur     = not value
		if not value
			@\__setPressed false

return ui