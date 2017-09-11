-- AUDIO

Audio = class
	new: (tags, source, tp) =>
		if type(source) == "string"
			ex = (() ->
				if type(tags) ~= 'table'
					@tags = { tags } 
				else
					@tags = tags

				for _, tag in pairs game.musicTags
					for _, tag2 in pairs @tags
						if tag == tag2
							return true
				false
			)()
			@source = love.audio.newSource source, tp
			@source\setVolume 0 if not ex
		else
			@source = source\clone!

	play: () =>
		if @source\isPaused!
			@source\resume!
		else
			@source\play!

	pause: () =>
		@source\pause!

	resume: () =>
		@source\resume!

	toggle: () =>
		if @source\isPlaying!
			@\pause!
		else
			@\resume!

	rewind: () =>
		@source\rewind!

	seek: (pos, unit) =>
		@source\seek pos, unit

	volume: (proc) =>
		if proc
			@source\setVolume 0.01 * proc
		else
			return @source\getVolume!

	clone: (pure) =>
		if pure then return @source\clone!
		return Audio @source

return Audio