-- LOGO ELEMENT

return () ->
	game.ui.Element {
		draw: =>
			-- Draw text of buttons
			love.graphics.setColor 255, 255, 255
			love.graphics.setFont  game.fonts.logo
			love.graphics.print    phrases.name


		x: sizes.position.x * 5
		y: sizes.position.y * 5

		tags: {"menu", "settings"}
	}