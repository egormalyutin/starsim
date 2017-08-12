fs		= require 'fs'
sharp 	= require 'sharp'

roundedCorners = new Buffer '<svg width="200" height="100">
  <rect x="0" y="0" width="100" height="50" transform="skewX(-20)"/>
  <text x="50%" y="50%" alignment-baseline="middle" text-anchor="middle" dominant-baseline="central" font-family="Vox" font-size="30px" transform="skewX(-20)" color="white">В ЧАЩАХ</text>    
</svg>'

warp = 
	sharp(roundedCorners)
		.png()



warp.pipe fs.createWriteStream 'output.png'