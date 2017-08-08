return class
	new: =>
		@mode = false
		
	start: =>
		@mode = true
		print "Editor mode is ON now!"

		return