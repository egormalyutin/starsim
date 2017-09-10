fs   = require "fs"
png  = require "svg2png"

fs.writeFileSync('paint.png', png.sync(fs.readFileSync "paint.svg"))
