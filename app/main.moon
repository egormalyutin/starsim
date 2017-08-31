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

	if rooms[game.room]
		if rooms[game.room].open
			rooms[game.room].open game.room


love.load = ->
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
		play:		love.audio.play
		pause:		love.audio.pause
		audio:		love.audio.newSource

		-- Libraries
		ui: 			require 'scripts/libs/ui'
		Audio:			require 'scripts/audio'

		-- Rooms
		room: "empty"
		roomHistory: {'menu'}

		setRoom: (room) ->
			if rooms[game.room]
				if rooms[game.room].close
					rooms[game.room].close room

			table.insert game.roomHistory, room
			game.room = room

			if rooms[room]
				if rooms[room].open
					rooms[room].open game.room

			-- if game.o[room]
				-- game.o[room]!

		-- Rooms
		rooms: 
			menu: 
				sky: angle:	love.math.random 0, 100
				open:  require 'scripts/rooms/menu/open'
				close: require 'scripts/rooms/menu/close'

			settings:
				open:  require 'scripts/rooms/settings/open'
				close: require 'scripts/rooms/settings/close'

		-- Languages
		phrases: require 'scripts/phrases'	

		-- Sizes
		sizes: {}
	}

	sizes   = game.sizes
	phrases = game.phrases.current
	rooms   = game.rooms

	------------------------------- WINDOW ---------------------------------
	love.window.setTitle phrases.name
	love.graphics.setBackgroundColor 0, 0, 0
	love.window.setIcon love.image.newImageData 'resources/images/icon.png'
	------------------------------------------------------------------------

	game.audio  = {
		menu:		game.Audio "resources/audio/menu.mp3"
	}

	game.images = {
		sky:	 	game.image "resources/images/starsky.png"
		logo:		game.image "resources/images/logomenu.png"
		station:	game.image "resources/images/station.png"
	}

	-- Set size to default
	defaultSize!

	game.setRoom "menu"

	game.ui.update rooms.ui.all, nil, nil, 0

	return

love.update = (dt) ->
	if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r')
		game.setRoom "menu"

	if (game.room == "menu") or (game.room == "settings")
		-- Rotate sky
		game.rooms.menu.sky.angle += 0.001

		game.ui.update game.rooms.ui.all, nil, nil, dt
	dev_enable()
	lovebird.update!
	dev_disable()

love.draw = ->
	if (game.room == "menu") or (game.room == "settings")		
		-- Set menu font
		game.setFont game.fonts.logo

		-- Draw sky
		game.draw game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080

		-- Draw station
		game.draw game.images.station, rooms.ui.station.x, rooms.ui.station.y, nil, rooms.ui.station.scale

		game.ui.draw rooms.ui.all


-- Reload positions and sizes, when window changes size
love.resize = defaultSize

-- Bind UI events

love.mousepressed = () ->
	game.ui.mousepressed rooms.ui.all

love.mousereleased = ->
	game.ui.mousereleased rooms.ui.all