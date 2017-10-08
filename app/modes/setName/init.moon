return {
	russian:
		new: class
			new:    (@ui, @content, @checkResults) =>

			start: =>
				@filter = game.ui.Filter { "name" }
				@stars = {}
				current = nil

				a = nil

				@ui.bar.button "ПРОВЕРИТЬ РЕЗУЛЬТАТЫ", () -> @.checkResults(@results!)
				@ui.bar.button "НАЗВАНИЕ ЗВЕЗДЫ: ", nil, true

				a = @ui.bar.selectOne {" "}, 
					(var, text) ->

				sf = @

				@sky  = love.graphics.newImage 'modes/setName/sky.png'
				@skyW = @sky\getWidth!
				@skyH = @sky\getHeight!

				@skyCW, @skyCH, @skyS = @ui.getSize @ui.width, @ui.height, @skyW, @skyH

				@skyX = @ui.width  / 2 - @skyCW / 2
				@skyY = @ui.height / 2 - @skyCH / 2


				rets = {}
				@rets = rets

				@newStar = (img, x, y, items, sx = 1, sy = 1) =>
					image = love.graphics.newImage img
					ret = @.ui.element {
						draw: =>
							love.graphics.setColor   255, 255, 255
							love.graphics.draw       image
							love.graphics.setFont    game.fonts.small
							love.graphics.printf     @_text, 0, @height + 1, @width, 'center' if @_text


						x: x
						y: y

						width:  106
						height: 106

						sx: sx
						sy: sy

						mousereleased: () =>
							a.current = 1 if not @_text
							if @_text
								for name, value in pairs {"Звезда №1", "Звезда №2", "Звезда №3", "Звезда №4"} 
									if @_text == value
										a.current = name
							a.variants = {"Звезда №1", "Звезда №2", "Звезда №3", "Звезда №4"} 
							a.changed  = (_, text) -> @_text = text
							a.text.width = game.fonts.play\getWidth a.variants[1]
							@_text = a.variants[1]
							sf.ui.bar.updatePositions!

						tags: { 'name' }
					}
					table.insert rets, ret
				@newStar "resources/images/star1.png", 100, 100
				@newStar "resources/images/star2.png", 300, 200
				@newStar "resources/images/star3.png", 700, 200
				@newStar "resources/images/star4.png", 900, 500
				sf.ui.bar.updatePositions!
				@filter\update!




		---------------------------
		-- EVENTS
		---------------------------




			update: () =>
				game.ui.update @filter
			draw: () =>
				love.graphics.draw @sky, @skyX, @skyY + @ui.bar.height, nil, @skyS
				game.ui.draw @filter
			mousepressed: () =>
				game.ui.mousepressed @filter
			mousereleased: () =>
				game.ui.mousereleased @filter

			results: () =>
				proc = 0
				game.ret = @rets[1]
				if @rets[1]._text == "Звезда №1"
					proc += 25
				if @rets[2]._text == "Звезда №2"
					proc += 25
				if @rets[3]._text == "Звезда №3"
					proc += 25
				if @rets[4]._text == "Звезда №4"
					proc += 25
				proc




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