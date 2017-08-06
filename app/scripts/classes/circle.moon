return class
	new: (settings) =>
		@settings =
			x: 	128
			y: 	128
			radius: 32 / 2
			color: { 255, 255, 255 }

		if settings != nil
			for setting, val in pairs settings
				@settings[setting] = val

		@s = @settings

	draw: =>
		love.graphics.setColor @s.color[1], @s.color[2], @s.color[3]
		love.graphics.circle "fill", @s.x, @s.y, @s.radius