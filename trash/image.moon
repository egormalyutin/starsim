return class
	new: (settings) =>
		@settings =
			x: 	128
			y: 	128
			width: 32
			height: 32
			scale: {x: 1, y: 1}
			color: { 255, 255, 255 }

		if settings != nil
			for setting, val in pairs settings
				@settings[setting] = val

		@s = @settings

		@image = love.graphics.newImage @s.path

	draw: =>
		love.graphics.draw @image, @s.x, @s.y, nil, @s.scale.x, @s.scale.y