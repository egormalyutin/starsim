dev_enable = () ->
dev_disable = () ->

dev_enable()
lovebird	= require 'scripts.libs.lovebird'
dev_disable()

love.run = ->
	if love.math
		love.math.setRandomSeed(os.time())
 
	if love.load then love.load(arg)
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() 
 
	dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
				love.handlers[name](a,b,c,d,e,f)
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
 
		-- Call update and draw
		if love.update then love.update(dt) -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive()
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.preload and game.preloadProgress ~= 2
				love.preload()
			else
				if love.draw then love.draw() 
			love.graphics.present()
 
		if love.timer then love.timer.sleep(0.001)
 

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
	sizes.scaleY = sizes.height / 768

	rooms.ui = {}

	game.fonts = 
		buttonSize: math.floor sizes.scale * 50
		logoSize:   math.floor sizes.scale * 100
		playSize:   math.floor sizes.scale * 25
		loveSize:   math.floor sizes.scale * 40
		authorSize: math.floor sizes.scale * 60

	game.fonts.menu = love.graphics.newFont "resources/fonts/menu.ttf", game.fonts.buttonSize 
	game.fonts.logo = love.graphics.newFont "resources/fonts/logo.ttf", game.fonts.logoSize
	game.fonts.play = love.graphics.newFont "resources/fonts/play.ttf", game.fonts.playSize
	game.fonts.love = love.graphics.newFont "resources/fonts/love.woff", game.fonts.loveSize
	game.fonts.author = love.graphics.newFont "resources/fonts/play.ttf", game.fonts.authorSize

	if rooms[game.room]
		if rooms[game.room].open
			rooms[game.room].open game.room

love.load = () ->
	-- MoonScript requires
	export game, rooms, phrases, sizes, DECORATIONS

	DECORATIONS = true
	MUSIC = true
	dev_enable()
	-- DECORATIONS = false
	MUSIC = true
	dev_disable()

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
		binser:			require 'scripts/libs/binser'
		Audio:			require 'scripts/audio'
		timer:			require 'scripts/libs/hump-timer'

		-- Rooms
		room: "empty"
		roomHistory: {'menu'}

		setRoom: (room) ->
			if rooms[game.room]
				if rooms[game.room].close
					rooms[game.room].close room

			table.insert game.roomHistory, room
			game.ui.destroy rooms.ui.all
			game.ui.destroy game.ui.elements 
			game.room = room

			if rooms[room]
				if rooms[room].open
					rooms[room].open game.room

			-- if game.o[room]
				-- game.o[room]!

		rooms: 
			menu: 
				sky: angle:	love.math.random 0, 100
				open:  require 'scripts/rooms/menu/open'
				close: require 'scripts/rooms/menu/close'

			settings:
				open:  require 'scripts/rooms/settings/open'
				close: require 'scripts/rooms/settings/close'

			play: 
				open:  require 'scripts/rooms/play/open'
				close: () ->

		startGame: require 'scripts/startGame'

		-- Languages
		phrases: require 'scripts/phrases'	

		getLanguage: (mas = {}) ->
			name = lang for name, value in pairs game.phrases when value == phrases
			if mas[name] then return mas[name]
			return name

		setLanguage: (lang, room) ->
			game.phrases.current = lang
			love.graphics.clear!
			w = game.fonts.menu\getWidth phrases.wait
			h = game.fonts.menu\getHeight!

			x = (sizes.width  / 2) - (w / 2)
			y = (sizes.height / 2) - (h / 2)

			game.text phrases.wait, x, y
			love.event.quit 'restart'

		-- Sizes
		sizes: {}

		preloadProgress: 0
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
		station:	game.image "resources/images/station.png"
		love:       game.image "resources/images/powered-by.png"
	}

	-- Set size to default
	defaultSize!

	game.setRoom room or "menu"
	game.timer.after 5,  -> game.preloadProgress = 1
	game.timer.after 8,  -> 
		game.preloadProgress = 2
		love.graphics.clear love.graphics.getBackgroundColor()
		love.graphics.origin!
		love.graphics.present!

	game.ui.update rooms.ui.all, nil, nil, 0

	game.preload   = {}

	game.preload.printY = (sizes.height / 2) - (((game.fonts.love\getHeight!) + 170) / 2)
	game.preload.y      = game.preload.printY + game.fonts.love\getHeight! + 10
	game.preload.x = (sizes.width  / 2) - (game.fonts.love\getWidth(phrases.poweredBy) / 2)

	game.preload.authorX = (sizes.width  / 2) - (game.fonts.author\getWidth(phrases.author) / 2)
	game.preload.authorY = (sizes.height / 2) - (game.fonts.author\getHeight! / 2)
	return

love.preload = ->
	if game.preloadProgress == 0
		love.graphics.setFont game.fonts.love
		love.graphics.print phrases.poweredBy, game.preload.x, game.preload.printY
		love.graphics.draw game.images.love, sizes.width / 2 - 236, game.preload.y
	if game.preloadProgress == 1
		love.graphics.setFont game.fonts.author
		love.graphics.print phrases.author, game.preload.authorX, game.preload.authorY 

love.update = (dt) ->
	if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r')
		game.setRoom "menu"

	if (game.room == "menu") or (game.room == "settings")
		-- Rotate sky
		game.rooms.menu.sky.angle += 0.001

		game.ui.update game.rooms.ui.all


	if (game.room == "play")
		game.playing.update dt if game.playing
		game.ui.update rooms.ui.all

	game.timer.update dt

	dev_enable()
	lovebird.update!
	dev_disable()

love.draw = ->
	if (game.room == "menu") or (game.room == "settings")		
		-- Set menu font
		game.setFont game.fonts.logo

		-- Draw sky
		game.draw game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080 if DECORATIONS

		-- Draw station
		game.draw game.images.station, rooms.ui.station.x, rooms.ui.station.y, nil, rooms.ui.station.scale if DECORATIONS

		game.ui.draw rooms.ui.all

	if (game.room == "play")
		game.playing.draw! if game.playing
		game.ui.draw rooms.ui.all

	dev_enable()
	love.graphics.setFont game.fonts.play
	love.graphics.print(tostring(love.timer.getFPS!), 5, sizes.height - 25)
	dev_disable()

-- Reload positions and sizes, when window changes size
love.resize = defaultSize

-- Bind UI events

love.mousepressed = () ->
	game.ui.mousepressed rooms.ui.all

love.mousereleased = ->
	game.ui.mousereleased rooms.ui.all