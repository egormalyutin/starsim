return class
		new:    (@ui, @content) =>
			@button = @ui.button 'PRESS ME', 100, 100, () -> error 'YOU PRESSED ME!'
		update: () ->
		draw:   () ->
