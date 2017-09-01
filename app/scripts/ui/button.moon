-- BUTTON UI ELEMENT

button = (x, y, text, click) ->
	res = game.ui.Element {
		draw: =>
			-- Draw text of buttons
			if @focused
				game.color 255, 255, 255, 50
			else
				game.color 255, 255, 255
			game.font game.fonts.menu
			game.text text, 0, 0


		x: x
		y: y

		mousereleased: click

		tags: {"menu"}
	}

	res\setWidth  game.fonts.menu\getWidth text
	res\setHeight game.fonts.menu\getHeight!
	res\setRotation math.pi /10
	res\__reshape!

	res

return button