return (last) ->
	-- Create new boject and set buttons size
	rooms.ui = {}
	rooms.ui.station = {}

	rooms.ui.station.scale = sizes.scale  / 2
	rooms.ui.station.x     = sizes.width  - ( rooms.ui.station.scale * 1211 )
	rooms.ui.station.y     = sizes.height - ( rooms.ui.station.scale * 427 )

	-- Load UI
	rooms.ui.all     = game.ui.Filter { "." }

	game.ui.destroy rooms.ui.all

	-- Create buttons
	rooms.ui.button  = require('scripts/ui/button')
	rooms.ui.logo    = require('scripts/ui/logo')()

	x  = sizes.position.x * 10
	y  = sizes.position.y * 23
	py = sizes.position.y * 12

	rooms.ui.start = rooms.ui.button x, y, 
		phrases.startGame,
		() -> 
			game.startGame "setName", "sdsds"

	rooms.ui.settings = rooms.ui.button x, y + py, 
		phrases.settings,
		() -> 
			game.setRoom "settings"

	game.audio.menu\play!

	rooms.ui.all\update!