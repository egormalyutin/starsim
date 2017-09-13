return {
	russian:
		new: class
			new:    (@ui, @content) =>

			start: =>
				@filter = game.ui.Filter { "name" }
				@stars = {}
				@newStar = (img, x, y, items, sx = 1, sy = 1) =>
					ret = @ui.element {
						draw: =>
							love.graphics.setColor   255, 255, 255
							love.graphics.rectangle "fill", 0, 0, @width, @height
							love.graphics.setFont    game.fonts.small
							love.graphics.printf     @_text, 0, @height + 1, @width, 'center' if @_text


						x: x
						y: y

						width:  100
						height: 100

						sx: sx
						sy: sy

						mousereleased: () =>
							error 'SELECT'

						tags: { 'name' }
					}
					ret.items = items
					ret.setItem = (@_text) =>
				@star  = @newStar 100, 100
				@ui.bar.select {'LOL', 'KEKLOLKEK', 'sihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjsssssssssssssssssssssssssssssssssssssssihfiusfhdsiussssssdhisuchsiuhnsiudhsiudsiduajsdiosjisdjsidhsiudshdishiushdsiuhdsiudhsiudhsiudhsiudhsiudhdsdjsoidsjdisjdoijdsoidjssssssssssssssssssssssssssssssssssssss', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd', 'dsdsd', 'sdds', 'dsdsd', 'dsdsd', 'dsdsd'}, (var, text) ->

				@filter\update!




		---------------------------
		-- EVENTS
		---------------------------




			update: () =>
				game.ui.update @filter
			draw: () =>
				game.ui.draw @filter
			mousepressed: () =>
				game.ui.mousepressed @filter
			mousereleased: () =>
				game.ui.mousereleased @filter



		---------------------------
		-- TEXT
		---------------------------


		name:        'ВЫБРАТЬ ЗВЕЗДУ'
		description: 'Нужно определить созвездие и назвать каждую звезду своим именем.\nНажмите на звезду, чтобы выбрать её имя.'

	english:
		new: class
			new:    (@ui, @content) =>
				@button = @ui.bar.button 'PRESS ME', () -> error 'YOU PRESSED ME!'
				@button = @ui.bar.button 'NOT PRESS ME', () -> error 'YOU PRESSED ME OLOLO!'
			update: () ->
			draw:   () ->

		name:        'SELECT STAR'
		description: 'It is necessary to determine the constellation and name each star by its own name. Click on the star to select its name.'
}