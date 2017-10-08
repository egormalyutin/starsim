-- AUDIO

Audio = class
	new: (tags, source, tp) =>
		if game.muted then return
		if type(source) == "string"
			@source = love.audio.newSource source, tp 
			@source\setVolume 0
		else
			@source = source\clone!

	play: () =>
		if game.muted then return
		if @source\isPaused!
			@source\resume!
		else
			@source\play!

	pause: () =>
		if game.muted then return
		@source\pause!

	resume: () =>
		if game.muted then return
		@source\resume!

	toggle: () =>
		if game.muted then return
		if @source\isPlaying!
			@\pause!
		else
			@\resume!

	rewind: () =>
		if game.muted then return
		@source\rewind!

	seek: (pos, unit) =>
		if game.muted then return
		@source\seek pos, unit

	volume: (proc) =>
		if game.muted then return
		if proc
			@source\setVolume 0.01 * proc
		else
			return @source\getVolume!

	clone: (pure) =>
		if game.muted then return
		if pure then return @source\clone!
		return Audio @source

return Audio