return () ->
	-- Create new boject and set buttons size
	rooms.ui = {}
	rooms.ui.station = {}

	rooms.ui.station.scale = sizes.scale  / 2
	rooms.ui.station.x     = sizes.width  - ( rooms.ui.station.scale * 1211 )
	rooms.ui.station.y     = sizes.height - ( rooms.ui.station.scale * 427 )

	game.fonts = 
		buttonSize: math.floor sizes.scale * 50
		logoSize: math.floor sizes.scale * 100

	game.fonts.menu = love.graphics.newFont "resources/fonts/menu.ttf", game.fonts.buttonSize 
	game.fonts.logo = love.graphics.newFont "resources/fonts/logo.ttf", game.fonts.logoSize

	rooms.ui.all = game.ui.Filter { "menu" }

	game.ui.destroy rooms.ui.all

	rooms.ui.button  = require('scripts/ui/button')
	rooms.ui.slider  = require('scripts/ui/slider')
	rooms.ui.logo    = require('scripts/ui/logo')()
	-- Create buttons

	rooms.ui.start = rooms.ui.button sizes.position.x * 10, sizes.position.y * 23, 
		phrases.backward,
		() -> 
			game.setRoom game.roomHistory[#game.roomHistory - 1]

	rooms.ui.slide = rooms.ui.slider 10, 5, nil

	rooms.ui.all\update!