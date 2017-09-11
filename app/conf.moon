love.conf = (t) ->
	t.version = "0.10.2"

	t.identity = "star-simulator"

	t.window.title = "STAR SIMULATOR"
	t.window.icon  = "resources/images/icon.png"

	t.modules.joystick = false
	t.modules.physics  = false
	t.modules.video    = false
	t.modules.thread   = false