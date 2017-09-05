return (mode = (error 'Mode is nil'), content = (error 'Content is nil')) ->
	rawModes = require 'modes/list'

	modes = {}

	for name, path in pairs rawModes
		modes[name] = require 'modes/' .. path 

	if not modes[mode]
		error 'Mode "' .. mode .. '" wasn\'t founded'

	game.setRoom 'play'

	Cls = modes[mode]
	game.playing = Cls content
	
	game.playing.update or= () ->
	game.playing.draw   or= () ->
