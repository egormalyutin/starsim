-- AUDIO

Audio = class
	new: (source, tp) =>
		if type(source) == "string"
			@source = love.audio.newSource source, tp
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