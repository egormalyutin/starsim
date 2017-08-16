dev_enable = () ->
dev_disable = () ->

dev_enable()
lovebird	= require 'scripts/libs/lovebird'
dev_disable()

defaultSize = () ->
	love.window.setFullscreen 1
	w, h = love.window.getMode()
	if w > 1366 or h > 768
		love.window.setFullscreen 0
		love.window.setMode 1366, 768

	-- Calculate window height and width
	sizes.width, sizes.height = love.window.getMode!

	--------------------------------------------

	sizes.position = {}

	-- Get abstract "position" metric
	sizes.position.x = math.floor sizes.width  / 100
	sizes.position.y = math.floor sizes.height / 100

	-- Get abstract "scale" metric
	sizes.scale = sizes.width / 1366

	if game.room == "menu"
		
		-- Create new boject and set buttons size
		rooms.menu.ui = {}
		rooms.menu.ui.station = {}

		rooms.menu.ui.station.scale = sizes.scale  / 2
		rooms.menu.ui.station.x     = sizes.width  - ( rooms.menu.ui.station.scale * 1211 )
		rooms.menu.ui.station.y     = sizes.height - ( rooms.menu.ui.station.scale * 427 )

		game.fonts = 
			buttonSize: math.floor sizes.scale * 50
			logoSize: math.floor sizes.scale * 100

		game.fonts.menu = love.graphics.newFont "resources/fonts/menu.ttf", game.fonts.buttonSize 
		game.fonts.logo = love.graphics.newFont "resources/fonts/logo.ttf", game.fonts.logoSize
		
		-- Create buttons

		rooms.menu.ui.all = game.ui.Filter { "menu" }

		game.ui.destroy rooms.menu.ui.all

		-- Load UI
		rooms.menu.ui.button  = require('scripts/rooms/menu/button')
		rooms.menu.ui.logo    = require('scripts/rooms/menu/logo')()

		-- Create buttons
		rooms.menu.ui.start = rooms.menu.ui.button sizes.position.x * 10, sizes.position.y * 23, 
			phrases.startGame,
			() -> 
				print "SET ROOM TO LEVELS"

		rooms.menu.ui.settings = rooms.menu.ui.button sizes.position.x * 10, sizes.position.y * 35, 
			phrases.settings,
			() -> 
				print "SET ROOM TO SETTINGS"
				game.setRoom "settings"


		rooms.menu.ui.all\update!

love.load = ->

	------------------------------- WINDOW ---------------------------------
	love.window.setTitle 'STAR SIMULATOR' 
	love.graphics.setBackgroundColor 0, 0, 0
	love.window.setIcon love.image.newImageData 'resources/images/icon.png'
	------------------------------------------------------------------------

	-- MoonScript requires
	export game, rooms, phrases, sizes

	game = {
		-- Aliases
		pressed: 	love.keyboard.isDown
		draw: 		love.graphics.draw
		image: 		love.graphics.newImage
		font:		love.graphics.newFont
		setFont:	love.graphics.setFont
		text:		love.graphics.print
		textf:		love.graphics.printf
		rectangle:  love.graphics.rectangle
		font:  		love.graphics.setFont
		color:  	love.graphics.setColor

		-- Libraries
		ui: require 'scripts/libs/ui'

		-- Rooms
		room: "menu"
		roomHistory: {'menu'}

		setRoom: (room) ->
			table.insert game.roomHistory, room
			game.room = room


		-- Rooms
		rooms: 
			menu: 
				sky: angle:	love.math.random 0, 100

		-- Languages
		phrases: require 'scripts/phrases'	

		-- Sizes
		sizes: {}
	}

	sizes   = game.sizes
	phrases = game.phrases.current
	rooms   = game.rooms

	game.images = {
		sky:	 	game.image "resources/images/starsky.png"
		logo:		game.image "resources/images/logomenu.png"
		station:	game.image "resources/images/station.png"
	}

	

	-- Set size to default
	defaultSize!

	game.ui.update rooms.menu.ui.all	

	return

love.update = (dt) ->
	if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r')
		game.room = "rooms"

	if game.room == "menu"
		-- Rotate sky
		game.rooms.menu.sky.angle += 0.001

		game.ui.update game.rooms.menu.ui.all


love.draw = ->
	if game.room == "menu"
		-- Set menu font
		game.setFont game.fonts.logo

		-- Draw sky
		game.draw game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080

		-- Draw station
		game.draw game.images.station, rooms.menu.ui.station.x, rooms.menu.ui.station.y, nil, rooms.menu.ui.station.scale

		game.ui.draw rooms.menu.ui.all

-- Reload positions and sizes, when window changes size
love.resize = defaultSize

-- Bind UI events

love.mousepressed = () ->
	game.ui.mousepressed rooms.menu.ui.all

love.mousereleased = ->
	game.ui.mousereleased rooms.menu.ui.all