return (x, y) ->
	label = game.ui.Element {
		draw: =>
			game.setFont game.fonts.menu
			game.text phrases.setLanguage, 0, 0

		x: x
		y: y

		tags: { "menu" }
	}

	prevX = game.fonts.menu\getWidth phrases.setLanguage

	prev = game.ui.Element {
		draw: =>
			game.setFont game.fonts.menu
			game.text "<", 0, 0

		x: x + prevX
		y: y

		tags: {"menu"}
	}