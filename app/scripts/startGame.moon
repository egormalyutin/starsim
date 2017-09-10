return (mode = (error 'Mode is nil'), content = (error 'Content is nil')) ->
	rawModes = require 'modes/list'

	modes = {}

	for name, path in pairs rawModes
		modes[name] = require 'modes/' .. path 

	if not modes[mode]
		error 'Mode "' .. mode .. '" not found'

	game.setRoom 'play'

	Cls = modes[mode].new
	ui        = {}
	ui.button = (text, x, y, pressed, border) ->
		elem = nil
		if border
			elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.rectangle 'line', 0, 0, @width, @height
					love.graphics.setFont game.fonts.play
					love.graphics.print @_text, 3, 3 

				tags: { 'game' }

				x: x
				y: y

				width:  (game.fonts.play\getWidth text) + 6
				height: (game.fonts.play\getHeight!) + 6

				mousereleased: pressed
			}
		else
			elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.setFont game.fonts.play
					love.graphics.print @_text 

				tags: { 'game' }

				x: x
				y: y
				z: 1

				width:  (game.fonts.play\getWidth text)
				height: (game.fonts.play\getHeight!)

				mousereleased: pressed
			}

		elem._text    = text
		elem.setText  = (text) =>
			@_text = text
			@width = game.fonts.play\getWidth text
			@\reshape!

		elem.getText = =>
			@_text

		rooms.ui.all\update!	

		elem

	ui.line = (x, y) ->
		line = game.ui.Element {
			draw: =>
				game.color 255, 255, 255, 255
				love.graphics.line 0, 0, 0, @height

			tags: { 'game' }

			x: x
			y: y
			z: 1

			width: 1
			height: 25
		}

		line

	ui.bar = (=>
		bar = game.ui.Element {
			draw: =>
				love.graphics.setColor 0x19, 0x1B, 0x1F, 150

				-- love.graphics.draw(
				-- 	game.images.sky, 
				-- 	sizes.width / 2, sizes.height / 2, 
				-- 	@data.angle, 
				-- 	nil, nil, 
				-- 	1920, 1080)

				love.graphics.rectangle 'fill', 0, 0, @width, @height - 1 

				love.graphics.setColor 255, 255, 255, 255
				love.graphics.line 0, @height, @width, @height

				love.graphics.setColor 0, 0, 0, 255
				love.graphics.rectangle 'fill', 0, @height, @width, sizes.height 

			update: =>
				@data.angle += 0.0005


			tags: { 'game' }

			data: angle: 0

			x: 0
			y: 0
			z: 0

			width:  sizes.width
			height: sizes.scaleY * 50
		}
		bar
	)()

	ui.bar.elements     = { { x: 0, width: 0 } }

	ui.bar.updatePositions = () ->
		last = nil

		for _, elem in pairs ui.bar.elements
			if last == nil
				elem.x = 0
				last = elem
				if elem.reshape then elem\reshape!
			else
				elem.x = last.x + last.width + 10
				elem.y = ui.bar.height / 2 - (elem.height / 2)
				last = elem
				if elem.reshape then elem\reshape!

	ui.bar.button = (text, pressed) ->
		lastElem = ui.bar.elements[#ui.bar.elements]
		table.insert(ui.bar.elements, 
			(ui.button text, 0, 0, pressed))
		table.insert(ui.bar.elements, 
			(ui.line 0, 0))
		ui.bar.updatePositions!


	preloaderName  = 'Lorem ipsum dolor sit amet, cononcdentrius dsdsd'
	preloader = game.ui.Element {
		draw: () =>
			love.graphics.setColor 0, 0, 0, @data.alpha
			love.graphics.rectangle 'fill', 0, 0, sizes.width, sizes.height
			love.graphics.setColor 255, 255, 255, @data.alpha
			love.graphics.setFont game.fonts.play
			str = string.sub(preloaderName, 0, @data.text)
			str ..= '_' if (#str % 3 == 1) and (#str ~= #preloaderName)
			love.graphics.print str, 
                sizes.position.y * 10,
				sizes.height - sizes.position.y * 10

		z: 3

		data: 
			alpha: 0
			text:  0

		tags: { 'preloader' }
	}
	game.timer.tween 0.7, preloader.data,  
		{ alpha: 255 },  
		'in-out-linear'

	game.timer.tween 1.5, preloader.data, 
		{ text: #preloaderName },
		'in-out-linear'

	rooms.ui.all = game.ui.Filter { 'preloader' }
	
	-- LOAD

	game.playing = Cls ui, content
	game.playing.update  or= () ->
	game.playing.draw    or= () ->

	game.timer.after 4, =>
		rooms.ui.all = game.ui.Filter { 'game', 'preloader' }

		game.timer.tween 0.3, preloader.data,
			{alpha: 0},
			'in-out-linear',
			-> game.ui.destroy preloader