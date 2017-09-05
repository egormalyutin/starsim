return class
		new:    (self, @content) -> -- "self" is important here!
		update: () ->
		draw:   () ->
			love.graphics.print 'OLOLO', 0, 0