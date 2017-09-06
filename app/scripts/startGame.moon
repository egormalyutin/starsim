return (mode = (error 'Mode is nil'), content = (error 'Content is nil')) ->
	rawModes = require 'modes/list'

	modes = {}

	for name, path in pairs rawModes
		modes[name] = require 'modes/' .. path 

	if not modes[mode]
		error 'Mode "' .. mode .. '" wasn\'t founded'

	game.setRoom 'play'

	rooms.ui.all = game.ui.Filter { 'game' }

	Cls = modes[mode]
	ui        = {}
	ui.button = (text, x, y, pressed) ->
		elem = game.ui.Element {
			draw: =>
				if @hover
					game.color 255, 255, 255, 150
				else
					game.color 255, 255, 255, 255
				love.graphics.setFont game.fonts.menu
				love.graphics.print @text, 0, 0 

			tags: { 'game' }

			x: x
			y: y

			width:  game.fonts.menu\getWidth text
			height: game.fonts.menu\getHeight!

			mousereleased: pressed
		}

		elem.text = text

		rooms.ui.all\update!	
	game.playing = Cls ui, content

	game.playing.update  or= () ->
	game.playing.draw    or= () ->
	
