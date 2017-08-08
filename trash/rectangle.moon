return class
	new: (settings) =>
		@settings =
			x: 	128
			y: 	128
			width: 32
			height: 32
			speed:	300
			color: { 255, 255, 255 }

		if settings != nil
			for setting, val in pairs settings
				@settings[setting] = val

		@s = @settings

	draw: =>
		love.graphics.setColor @s.color[1], @s.color[2], @s.color[3]
		love.graphics.rectangle "fill", @s.x, @s.y, @s.width, @s.height