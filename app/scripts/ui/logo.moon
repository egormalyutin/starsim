-- LOGO ELEMENT

return () ->
	game.ui.Element {
		draw: =>
			-- Draw text of buttons
			game.color 255, 255, 255
			love.graphics.setFont game.fonts.logo
			game.text phrases.name, 0, 0 if DECORATIONS


		x: sizes.position.x * 5
		y: sizes.position.y * 5

		tags: {"menu", "settings"}
	}