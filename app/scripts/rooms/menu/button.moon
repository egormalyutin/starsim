-- BUTTON UI ELEMENT

button = (x, y, text, click) ->
	res = game.ui.Element {
		draw: =>
			-- Draw text of buttons
			game.color 255, 255, 255
			game.font game.fonts.menu
			game.text text, 0, 0

		x: x
		y: y

		mousereleased: click

		tags: {"menu"}
	}

	res.width  = (string.len text) * game.fonts.buttonSize
	res.height = game.fonts.buttonSize

	res

return button