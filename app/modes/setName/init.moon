return {
	new: class
		new:    (@ui, @content) =>
			@button = @ui.bar.button 'PRESS ME', () -> error 'YOU PRESSED ME!'
			@button = @ui.bar.button 'NOT PRESS ME', () -> error 'YOU PRESSED ME OLOLO!'
		update: () ->
		draw:   () ->

	name:        ''
	description: 'Нужно определить созведздие и назвать каждую звезду своим именем.\nНажмите на звезду, чтобы выбрать её имя.'
	tips: { '' }
}