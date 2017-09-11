return (x, y, label, vars = (error 'Variants is nil'), changed, def) ->

	current = def or 1
	buttons = {}

	buttons.label = game.ui.Element {
		draw: =>
			game.setFont game.fonts.menu
			game.color 0, 0, 0, 70
			love.graphics.print label, -1, -1
			love.graphics.print label,  1,  1
			game.color 255, 255, 255, 255
			game.text label, 0, 0

		x: x
		y: y

		tags: { "menu" }
	}

	prevX = game.fonts.menu\getWidth phrases.setLanguage
	h = game.fonts.menu\getHeight!

	buttons.prev = game.ui.Element {
		draw: =>

			if current - 1 > 0
				game.setFont game.fonts.menu
				game.color 0, 0, 0, 70
				love.graphics.print "<", -1, -1
				love.graphics.print "<",  1,  1
				if @hover
					game.color 255, 255, 255, 150
				else
					game.color 255, 255, 255, 255
				game.text "<", 0, 0

		x: x + prevX
		y: y

		width: game.fonts.menu\getWidth '<'
		height: h

		tags: {"menu"}

		mousereleased: () ->
			if current - 1 > 0
				current -= 1
				buttons.var.width = game.fonts.menu\getWidth vars[current]
				buttons.var\reshape!
				buttons.next.x = buttons.var.x + buttons.var.width + 6
				buttons.next\reshape!
				changed current, vars
	}

	varX = prevX + (game.fonts.menu\getWidth '<') + 6

	buttons.var = game.ui.Element {
		draw: =>
			game.setFont game.fonts.menu
			game.color 0, 0, 0, 70
			love.graphics.print vars[current], -1, -1
			love.graphics.print vars[current],  1,  1
			game.color 255, 255, 255, 255
			game.text vars[current], 0, 0

		x: x + varX
		y: y

		width:  game.fonts.menu\getWidth vars[current]
		height: h

		tags: {"menu"}
	}

	buttons.next = game.ui.Element {
		draw: =>
			if current + 1 <= #vars
				game.setFont game.fonts.menu
				game.color 0, 0, 0, 70
				love.graphics.print ">", -1, -1
				love.graphics.print ">",  1,  1
				if @hover
					game.color 255, 255, 255, 150
				else
					game.color 255, 255, 255, 255
				game.text '>', 0, 0

		x: buttons.var.x + buttons.var.width + 6
		y: y

		width: game.fonts.menu\getWidth '>'
		height: h

		tags: {"menu"}
		mousereleased: () ->
			if current + 1 <= #vars
				current += 1
				buttons.var.width = game.fonts.menu\getWidth vars[current]
				buttons.var\reshape!
				buttons.next.x = buttons.var.x + buttons.var.width + 6
				buttons.next\reshape!
				changed current, vars
	}
