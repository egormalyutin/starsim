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
				variants = {"Аль Салиб", "Аль Укуд", "Суалоцин", "Ротанев", "Денеб Дулфим"} 

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

				@newStar = (radius, x, y, right) =>
					x /= 100
					y /= 100
					radius /= 100

					x *= @skyCW
					y *= @skyCH
					radius *= @skyCH


					x += @skyX
					y += @skyY

					ret = @.ui.element {
						draw: =>
							love.graphics.setColor   255, 255, 255
							love.graphics.circle    "fill", radius, radius, radius
							love.graphics.setFont    game.fonts.small
							love.graphics.printf     @_text, -@width, @height + 1, @width * 3, 'center' if @_text


						x: x - radius
						y: y - radius

						width:  radius * 2
						height: radius * 2

						mousereleased: () =>
							a.current = 1 if not @_text
							if @_text
								for name, value in pairs variants
									if @_text == value
										a.current = name
							a.variants = variants
							a.changed  = (_, text) -> @_text = text
							a.text.width = game.fonts.play\getWidth a.variants[1]
							@_text = a.variants[1]
							sf.ui.bar.updatePositions!

						tags: { 'name' }
						data: right: right
					}
					ret._right = right
					table.insert rets, ret
					ret
				sf.ui.bar.updatePositions!

				r = 2
				@newStar r, 14, 48, "Аль Салиб"
				@newStar r, 26, 55, "Аль Укуд"
				@newStar r, 27, 27, "Суалоцин"
				@newStar r, 42, 42, "Ротанев"
				@newStar r, 70, 56, "Денеб Дулфим"

				@filter\update!




		---------------------------
		-- EVENTS
		---------------------------




			update: () =>
				game.ui.update @filter
			draw: () =>
				x, y = love.mouse.getPosition()
				love.graphics.draw @sky, @skyX, @skyY + @ui.bar.height, nil, @skyS
				game.ui.draw @filter
				-- love.graphics.print (math.floor((x - @skyX) / @skyCW * 100)) .. ' X ' .. (math.floor((y - @skyY) / @skyCH * 100)), 100, 100
			mousepressed: () =>
				game.ui.mousepressed @filter
			mousereleased: () =>
				game.ui.mousereleased @filter

			results: () =>
				proc = 0
				cnt  = 0
				len  = #@rets
				for _, item in ipairs @rets
					if item._text == item._right
						cnt += 1
				proc = cnt / len * 100
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