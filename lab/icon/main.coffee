sharp 	= require 'sharp'
fs		= require 'fs'

svg = new Buffer(
	'<svg xmlns="http://www.w3.org/2000/svg"  viewBox="0 0 100 100">
    <text y="90" x="0" font-size="150"
    font-family="Sheeping Dogs" fill="white">s</text>
	</svg>'
)

warp = 
	sharp svg
	.png() 

stream = fs.createWriteStream "out.png" 

warp.pipe stream