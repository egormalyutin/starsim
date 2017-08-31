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
	-- rooms.ui.slider  = require('scripts/ui/slider')
	rooms.ui.logo    = require('scripts/ui/logo')()
	rooms.ui.lang    = require('scripts/ui/lang')
	-- Create buttons

	x  = sizes.position.x * 10
	y  = sizes.position.y * 23
	py = sizes.position.y * 12

	rooms.ui.backward = rooms.ui.lang x, y, 
		() -> 
			game.setRoom game.roomHistory[#game.roomHistory - 1]

	rooms.ui.backward = rooms.ui.button x, y + py, 
		phrases.backward,
		() -> 
			game.setRoom game.roomHistory[#game.roomHistory - 1]

	-- rooms.ui.slide = rooms.ui.slider 10, 5, nil

	game.audio.menu\play!
	
	rooms.ui.all\update!