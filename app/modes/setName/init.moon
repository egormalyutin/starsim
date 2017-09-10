return {
	new: class
		new:    (@ui, @content) =>
			@button = @ui.bar.button 'PRESS ME', () -> error 'YOU PRESSED ME!'
			@button = @ui.bar.button 'NOT PRESS ME', () -> error 'YOU PRESSED ME OLOLO!'
		update: () ->
		draw:   () ->

	name:        'Дать имя звезде'
	description: 'Дать имsdjsij'
	tips: { '' }
}