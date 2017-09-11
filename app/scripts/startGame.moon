return (mode = (error 'Mode is nil'), content = (error 'Content is nil')) ->
	rawModes = love.filesystem.getDirectoryItems 'modes' 

	modes = {}

	for name, path in pairs rawModes
		modes[path] = require 'modes/' .. path 

	if not modes[mode]
		error 'Mode "' .. mode .. '" not exists'

	if not modes[mode][game.getLanguage!]
		print 'Mode "' .. mode .. '" for your language not exists. Using english...'

	md = modes[mode][game.getLanguage!]

	game.setRoom 'play'

	Cls = md.new
	ui         = {}
	ui.element = (s) ->
		elem    = game.ui.Element s
		elem.ty = sizes.scaleY * 50
		elem\reshape!
		elem

	ui.button = (text, x, y, pressed, border) ->
		elem = nil
		if border
			elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.rectangle 'line', 0, 0, @width, @height
					love.graphics.setFont game.fonts.play
					love.graphics.print @_text, 3, 3 

				tags: { 'game' }

				x: x
				y: y

				width:  (game.fonts.play\getWidth text) + 6
				height: (game.fonts.play\getHeight!) + 6

				mousereleased: pressed
			}
		else
			elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.setFont game.fonts.play
					love.graphics.print @_text 

				tags: { 'game' }

				x: x
				y: y
				z: 1

				width:  (game.fonts.play\getWidth text)
				height: (game.fonts.play\getHeight!)

				mousereleased: pressed
			}

		elem._text    = text
		elem.setText  = (text) =>
			@_text = text
			@width = game.fonts.play\getWidth text
			@\reshape!

		elem.getText = =>
			@_text

		rooms.ui.all\update!	

		elem

	ui.getSize = (ww, wh, w, h) ->
		scale = 1

		if ww < w
			if scale > ww / w
				scale = ww / w

		if wh < h
			if scale > wh / h
				scale = wh / h

		w * scale, h * scale, scale

	ui.getScale = (ww, wh, w, h) ->
		scale = 1

		if ww < w
			if scale > ww / w
				scale = ww / w

		if wh < h
			if scale > wh / h
				scale = wh / h

		scale



	ui.line = (x, y) ->
		line = game.ui.Element {
			draw: =>
				game.color 255, 255, 255, 255
				love.graphics.line 0, 0, 0, @height

			tags: { 'game' }

			x: x
			y: y
			z: 1

			width: 1
			height: ui.bar.height / 2
		}

		line

	ui.bar = (=>
		bar = game.ui.Element {
			draw: =>
				-- love.graphics.draw(
				-- 	game.images.sky, 
				-- 	sizes.width / 2, sizes.height / 2, 
				-- 	@data.angle, 
				-- 	nil, nil, 
				-- 	1920, 1080)
				love.graphics.setScissor @x, @y, @width, @height
				if @data.alpha < 255
					love.graphics.setColor 255, 255, 255, 255
					love.graphics.draw game.images.sky, sizes.width / 2, sizes.height / 2, @data.angle, nil, nil, 1920, 1080
				love.graphics.setScissor!

				love.graphics.setColor 0x19, 0x1B, 0x1F, @data.alpha
				love.graphics.rectangle 'fill', 0, 0, @width, @height - 1 

				love.graphics.setColor 255, 255, 255, 255
				love.graphics.line 0, @height, @width, @height


			update: =>
				@data.angle += 0.0005


			tags: { 'game' }

			data: 
				angle: 0
				alpha: 255
				height: sizes.scaleY * 50

			x: 0
			y: 0
			z: 0

			width:  sizes.width
			height: sizes.scaleY * 50
		}
		bar
	)()

	ui.height = sizes.height - sizes.scaleY * 50
	ui.width  = sizes.width

	ui.bar.separatorWidth = sizes.scale * 10

	ui.bar.elements     = { { x: 0, width: 0 } }

	ui.bar.updatePositions = () ->
		last = nil

		for _, elem in pairs ui.bar.elements
			if last == nil
				elem.x = 0
				last = elem
				if elem.reshape then elem\reshape!
			else
				if elem ~= nil
					elem.x = last.x + last.width + ui.bar.separatorWidth
					elem.y = ui.bar.data.height / 2 - (elem.height / 2)
					last   = elem
					if elem.reshape then elem\reshape!
				else
					table.remove ui.bar.elements, _

	ui.bar.button = (text, pressed, last) ->
		lastElem = ui.bar.elements[#ui.bar.elements]
		elem = (ui.button text, 0, 0, pressed)
		table.insert(ui.bar.elements, 
			elem)
		line = (ui.line!) if not last
		table.insert(ui.bar.elements, 
			line) if not last
		ui.bar.updatePositions!
		elem._setText = elem.setText 

		elem.setText = (text) =>
			elem\_setText text
			ui.bar.updatePositions!

		elem, line

	ui.bar.remove = (elem) ->
		for name, value in pairs ui.bar.elements
			table.remove ui.bar.elements, name if value == elem

	ui.bar.free = () ->
		e = ui.bar.elements[#ui.bar.elements]
		sizes.width - e.x + e.width

	ui.bar.prevButton = (pressed) ->
		elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.setFont game.fonts.play
					love.graphics.print "<", 0, 0 

				tags: { 'game', 'select' }

				x: x
				y: y

				width:  (game.fonts.play\getWidth "<")
				height: (game.fonts.play\getHeight!)

				mousereleased: pressed
			}
		elem
		table.insert(ui.bar.elements, elem)
		ui.bar.updatePositions!

	ui.bar.nextButton = (pressed) ->
		elem = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.setFont game.fonts.play
					love.graphics.print ">", 0, 0 

				tags: { 'game', 'select' }

				width:  (game.fonts.play\getWidth ">")
				height: (game.fonts.play\getHeight!)

				mousereleased: pressed
			}
		elem
		table.insert(ui.bar.elements, elem)
		rooms.ui.all\update!
		ui.bar.updatePositions!

	ui.bar.select = (variants = {""}, changed = () ->, free, current) ->
		res  = {}
		con  = false
		free = free!        if type(free) == 'function'
		free = free         if type(free) ~= 'function'
		free = ui.bar.free! if type(free) == 'nil'
		pos  = 1

		slice = (tbl, p1, p2) ->
			result = {}
			while p1 <= p2
				table.insert res, tbl[p1]
				p1 += 1
			result

		getWidth = (text) -> game.fonts.play\getWidth text 

		page = (tbl, plus) ->
			local res
			res   = 0
			for str in *tbl
				res += getWidth str
				res += plus
			res

		pageM = (tbl, plus) ->
			local res
			res = page tbl, plus
			res -= plus
			res

		clone = (tbl) ->
			cloned = {}
			for name, value in ipairs tbl
				cloned[name] = value
			cloned

		
		i = 1

		push = ->
			i += 1
			res[i] = {} if not res[i]

		separator = ui.bar.separatorWidth * 2 + 1

		elem = (text, last) ->
			ret = game.ui.Element {
				draw: =>
					if @hover
						game.color 255, 255, 255, 150
					else
						game.color 255, 255, 255, 255
					love.graphics.setFont game.fonts.play
					love.graphics.print @_text, 0, 0 

				tags: { 'game', 'select-bar' }

				width:  (game.fonts.play\getWidth text)
				height: (game.fonts.play\getHeight!)

				mousereleased: changed
			}
			table.insert(ui.bar.elements, ret)
			line = nil
			if not last
				line = ui.line!
				table.insert(ui.bar.elements, line)
				table.insert line.tags, "select-bar"

			ret._text = text
			ret, line

		for name, item in ipairs variants
			local larger
			res[i] = {} if not res[i]
			table.insert res[i], item

			if pageM(res[i], separator) > free
				table.remove res[i], #res[i]
				push!

			if (pageM({ item }, separator) > free)
				table.insert res[i], item

		filter = game.ui.Filter { 'select-bar' }

		destroy = () ->
			game.ui.destroy filter

		update = nil

		lastPage = ->
			if pos - 1 >= 1
				pos -= 1
				update!

		nextPage = ->
			if pos + 1 <= #res
				pos += 1
				update!

		update = () ->
			destroy!
			lastButton = ui.bar.prevButton () -> lastPage!
			for name, value in ipairs res[pos]
				if name == #res[5]
					elem value, true
				else
					elem value
			nextButton = ui.bar.nextButton () -> nextPage! 

			filter\update!
			ui.bar\updatePositions!

		update!

	ui.bar.selectOne = (variants = {""}, changed) ->
		res = {}

		res.variants = variants
		res.changed  = changed or ->
		res.current  = 1

		res.next = () ->
			if (res.current + 1) <= #res.variants
				res.current += 1
				res.text.width = game.fonts.play\getWidth res.variants[res.current]
				ui.bar.updatePositions!
				res.changed res.current, res.variants[res.current]

		res.prev = () ->
			if (res.current - 1) >= 1 
				res.current -= 1
				res.text.width = game.fonts.play\getWidth res.variants[res.current]
				ui.bar.updatePositions!
				res.changed res.current, res.variants[res.current]

		res.prevButton = ui.bar.prevButton () ->
			res.prev!

		res.text = game.ui.Element {
			draw: =>
					love.graphics.setFont game.fonts.play
					love.graphics.print res.variants[res.current], 0, 0 

				tags: { 'game', 'select' }

				width:  (game.fonts.play\getWidth res.variants[1])
				height: (game.fonts.play\getHeight!)

				mousereleased: pressed
		}
		table.insert ui.bar.elements, res.text

		res.nextButton = ui.bar.nextButton () ->
			res.next!

		ui.bar.updatePositions!

		res.group   = game.ui.Filter { 'select' }
		res.destroy = () -> 
			game.ui.destroy res.group

		res


	preloaderLines       = (select(2, md.description\gsub("\n", "\n"))) + 1
	preloaderDescription = md.description
	preloaderName        = phrases.mode .. md.name
	game.preloader = game.ui.Element {
		draw: () =>
			love.graphics.setColor 0, 0, 0, @data.alpha
			love.graphics.rectangle 'fill', 0, 0, sizes.width, sizes.height
			love.graphics.setColor 255, 255, 255, @data.alpha
			-- str = string.sub(preloaderName, 0, @data.text)
			-- str ..= '_' if (#str % 3 == 1) and (#str ~= #preloaderName)
			love.graphics.setFont game.fonts.playLarge
			love.graphics.print preloaderName, 
                sizes.position.y * 10 - @data.name,
				sizes.height - (sizes.position.y * 20) - @data.nh 

			love.graphics.setFont game.fonts.play
			love.graphics.print preloaderDescription, 
                sizes.position.y * 10 - @data.text,
				sizes.height - (sizes.position.y * 10) - (@data.th * preloaderLines)

		z: 3

		data: 
			alpha: 0
			text:  game.fonts.play\getWidth preloaderDescription
			name:  game.fonts.play\getWidth preloaderName
			th:    game.fonts.play\getHeight!
			nh:    game.fonts.playLarge\getHeight!

		tags: { 'preloader' }
	}


	game.timer.tween 0.7, game.preloader.data,  
		{ alpha: 255 },  
		'in-out-linear'

	game.timer.tween 1.5, game.preloader.data, 
		{ text: 0 },
		'out-quad'

	game.timer.tween 1.5, game.preloader.data, 
		{ name: 0 },
		'out-quad'

	rooms.ui.all = game.ui.Filter { 'preloader' }
	
	-- LOAD

	results = (proc) ->
		text = "Вы выполнили задание на " .. proc .. "% правильно!"
		w    = game.fonts.play\getWidth text
		love.graphics.clear!
		love.graphics.origin!
		love.graphics.setFont game.fonts.play
		love.graphics.print text, sizes.width / 2 - w / 2, sizes.height / 2

		love.graphics.present!
		love.timer.sleep 5

	game.playing = Cls ui, content, results

	game.playing.paused = false
	game.playing.pause = () ->
		ui.playButton\setText phrases.resume
		game.timer.tween 0.7, ui.bar,
			{ height: sizes.height + 1 },
			'out-quad'
		game.timer.tween 0.7, ui.bar.data,
			{ alpha: 0 },
			'out-quad'

	game.playing.play = () ->
		ui.playButton\setText phrases.pause
		game.timer.tween 0.7, ui.bar,
			{ height: sizes.scaleY * 50 },
			'out-quad'
		game.timer.tween 0.7, ui.bar.data,
			{ alpha: 255 },
			'out-quad'

	game.playing.toggle = () ->
		if game.playing.paused
			game.playing.play!
			game.playing.paused = false
		else
			game.playing.pause!
			game.playing.paused = true

	ui.playButton = ui.bar.button phrases.pause, () -> game.playing.toggle!

	game.playing\start!

	game.timer.after 5, =>
		rooms.ui.all = game.ui.Filter { 'game', 'preloader' }

		game.timer.tween 0.3, game.preloader.data,
			{alpha: 0},
			'in-out-linear',
			-> 
				game.ui.destroy game.preloader
				game.preloader  = nil