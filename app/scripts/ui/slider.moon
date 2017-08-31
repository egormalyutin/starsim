-- SLIDER UI ELEMENT

return (x, y, click) ->
	game.ui.Element {
		draw: =>
			game.setFont game.fonts.menu
			love.graphics.setLineWidth 10
			love.graphics.setLineStyle "rough"
			love.graphics.line 20, @height / 3 * 2, @width, @height / 3 * 2 
			love.graphics.circle "fill", @data.active, 20, 10

			love.graphics.print @data.text, @width + 10, 0

			return

		update: (x, y) =>
			if (@hover) and (@pressed) and (x > 20) and (x < @width + 40)
					@data.active = x - 10
					@data.text   = math.floor((x - 20) / (@width + 20) * 100) .. "%"
					@redraw!

		x: x
		y: y

		height: 30
		width: 300

		data: { active: 20, text: "0%" }

		mousereleased: click

		tags: {"menu"}
	}