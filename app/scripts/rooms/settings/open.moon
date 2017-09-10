return () ->
	-- Create new boject and set buttons size
	rooms.ui = {}
	rooms.ui.station = {}

	rooms.ui.station.scale = sizes.scale  / 2
	rooms.ui.station.x     = sizes.width  - ( rooms.ui.station.scale * 1211 )
	rooms.ui.station.y     = sizes.height - ( rooms.ui.station.scale * 427 )
	
	rooms.ui.all = game.ui.Filter { "menu" }

	game.ui.destroy rooms.ui.all

	rooms.ui.button    = require('scripts/ui/button')
	-- rooms.ui.slider  = require('scripts/ui/slider')
	rooms.ui.logo      = require('scripts/ui/logo')()
	rooms.ui.select    = require('scripts/ui/select')
	-- Create buttons

	x  = sizes.position.x * 10
	y  = sizes.position.y * 23
	py = sizes.position.y * 12

	langs = {'РУССКИЙ', 'ENGLISH'}
	rooms.settings.llang = {phrases, 'settings'}
	rooms.settings.lang  = rooms.settings.llang

	rooms.ui.backward = rooms.ui.select(x, y, 
		phrases.setLanguage, langs,
		(num) -> 
			switch num
				when 1 then rooms.settings.lang = {game.phrases.russian, 'settings'}
				when 2 then rooms.settings.lang = {game.phrases.english, 'settings'}
		(->
			if game.phrases.russian = game.phrases.current
				return 1
			if game.phrases.english = game.phrases.current
				return 2
		)()
		)

	rooms.ui.save     = rooms.ui.button(x, y + py,
		phrases.saveSettings,
		() ->
			if rooms.settings.llang ~= rooms.settings.lang
				game.setLanguage unpack rooms.settings.lang
		phrases.saveSettings2)

	rooms.ui.backward = rooms.ui.button x, y + py * 3, 
		phrases.backward,
		() -> 
			game.setRoom game.roomHistory[#game.roomHistory - 1]

	-- rooms.ui.slide = rooms.ui.slider 10, 5, nil

	game.audio.menu\play!
	
	rooms.ui.all\update!