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

	if game.room == "menu"
		-- Calculate window height and width
		game.window.width, game.window.height = love.window.getMode!

		--------------------------------------------

		game.window.position = {}

		-- Get abstract "position" metric
		game.window.position.x = game.window.width  / 100
		game.window.position.y = game.window.height / 100

		-- Get abstract "scale" metric
		game.window.scale = game.window.width / 1366

		--------------------------------------------

		game.rooms.menu.logo = {}

		-- Get logo position
		game.rooms.menu.logo.x = game.window.position.x * 5
		game.rooms.menu.logo.y = game.window.position.y * 5

		-- Get logo scale
		game.rooms.menu.logo.scale = game.window.scale * 0.8  

		--------------------------------------------

		-- Create new boject and set buttons size
		game.rooms.menu.buttons = {}

		game.fonts.menu = game.font "resources/fonts/menu.ttf", math.floor(game.window.scale * 50)

		-- Create buttons

		game.rooms.menu.buttons.all = game.ui.Filter { "menu" }

		game.ui.destroy game.rooms.menu.buttons.all

		game.rooms.menu.buttons.start = game.ui.Element {
			draw: =>
				-- Draw text of buttons

				game.text "START GAME", 0, 0, nil

			x: math.floor(game.window.position.x * 10)
			y: math.floor(game.window.position.y * 20)

			width: 550 
			height: 500

			focus: { ->
				print "LOL"
			}

			tags: {"menu"}

		}

		game.rooms.menu.buttons.all\update!

love.load = ->

	---------------- WINDOW ------------------
	love.window.setTitle 'STAR SIMULATOR' 
	love.graphics.setBackgroundColor 0, 0, 0
	------------------------------------------

	-- MoonScript requires
	export game

	game = {
		-- Aliases
		pressed: 	love.keyboard.isDown
		draw: 		love.graphics.draw
		image: 		love.graphics.newImage
		font:		love.graphics.newFont
		setFont:	love.graphics.setFont
		text:		love.graphics.print
		textf:		love.graphics.printf

		-- Default room
		room: "menu"

		-- Libraries
		ui: require 'scripts/libs/ui'

		window: {}

		-- Rooms
		rooms: 
			menu: 
				sky: angle:	love.math.random 0, 100
	}

	game.images = {
		sky:	 	game.image "resources/images/starsky.png"
		logo:		game.image "resources/images/logomenu.png"
	}

	game.fonts = {
		menu: 		game.font "resources/fonts/menu.ttf", 50
	}

	-- Set size to default
	defaultSize!

	return


love.update = (dt) ->
	if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r')
		game.room = "rooms"

	if game.room == "menu"
		-- Rotate sky
		game.rooms.menu.sky.angle += 0.001

		game.ui.update game.rooms.menu.buttons.all

	return


love.draw = ->
	if game.room == "menu"
		-- Set menu font
		game.setFont game.fonts.menu

		-- Draw sky
		game.draw game.images.sky, game.window.width / 2, game.window.height / 2, game.rooms.menu.sky.angle, nil, nil, 1920, 1080

		-- Draw logo
		game.draw game.images.logo, game.rooms.menu.logo.x, game.rooms.menu.logo.y, nil, game.rooms.menu.logo.scale

		game.ui.draw game.rooms.menu.buttons.all

	return

-- Reload positions and sizes, when window changes size
love.resize = defaultSize