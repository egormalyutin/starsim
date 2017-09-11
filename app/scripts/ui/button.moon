-- BUTTON UI ELEMENT

button = (x, y, text, click, text2) ->
	if not text2
		res = game.ui.Element {
					draw: () =>
						love.graphics.setFont game.fonts.menu
						game.color 0, 0, 0, 70
						love.graphics.print text, -1, -1
						love.graphics.print text,  1,  1
						if @hover
							game.color 255, 255, 255, 150
						else
							game.color 255, 255, 255, 255
						love.graphics.print text, 0, 0

					x: x
					y: y

					mousereleased: click

					tags: {"menu"}
				}

		res.width  = game.fonts.menu\getWidth text
		res.height = game.fonts.menu\getHeight!
		res\reshape!

		res
	else
		h = game.fonts.menu\getHeight!

		res = game.ui.Element {
					draw: () =>
						love.graphics.setFont game.fonts.menu
						game.color 0, 0, 0, 70
						love.graphics.print text,  -1, -1
						love.graphics.print text2, -1, h + 9
						love.graphics.print text,  1, 1
						love.graphics.print text2, 1, h + 11
						if @hover
							game.color 255, 255, 255, 150
						else
							game.color 255, 255, 255, 255
						love.graphics.print text,  0, 0
						love.graphics.print text2, 0, h + 10

					x: x
					y: y

					mousereleased: click

					tags: {"menu"}
				}

		o = game.fonts.menu\getWidth text
		s = game.fonts.menu\getWidth text2

		if o > s
			res.width  = game.fonts.menu\getWidth text
		else
			res.width  = game.fonts.menu\getWidth text2
		res.height = game.fonts.menu\getHeight! * 2
		res\reshape!

		res
return button