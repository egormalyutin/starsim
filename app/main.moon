-- REQUIRES
Rectangle 	= require 'scripts/classes/rectangle'
Circle 		= require 'scripts/classes/circle'
Image 		= require 'scripts/classes/image'

dev_enable = () ->
dev_disable = () ->

dev_enable()
lovebird	= require 'scripts/debug/lovebird'
dev_disable()

love.load = ->
	-- WINDOW
	love.window.setTitle('GAME')
	-- / WINDOW

	export g

	love.graphics.setBackgroundColor 0, 0, 0
	
	g = {}
	
	g.hero 	= Rectangle!
	g.enemy	= Circle!

	g.pressed = love.keyboard.isDown

	export image
	image = Image path: "resources/images/sprites/star1.png"

love.update = (dt) ->
	lovebird.update!

love.draw = ->
	g.hero\draw!
	g.enemy\draw!

	image\draw!