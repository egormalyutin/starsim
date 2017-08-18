-- BUTTON UI ELEMENT

button = (x, y, text, click) ->
	res = game.ui.Element {
		draw: =>
			-- Draw text of buttons
			if @hover
				game.color 255, 255, 255, 190
			else
				game.color 255, 255, 255
			game.font game.fonts.menu
			game.text text, 0, 0

		x: x
		y: y

		mousereleased: click

		tags: {"menu"}
	}

	res.width  = game.fonts.menu\getWidth text
	res.height = game.fonts.menu\getHeight!

	res

return button