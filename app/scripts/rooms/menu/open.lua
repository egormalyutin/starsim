return function(last)
  rooms.ui = { }
  rooms.ui.station = { }
  rooms.ui.station.scale = sizes.scale / 2
  rooms.ui.station.x = sizes.width - (rooms.ui.station.scale * 1211)
  rooms.ui.station.y = sizes.height - (rooms.ui.station.scale * 427)
  rooms.ui.all = game.ui.Filter({
    "."
  })
  game.ui.destroy(rooms.ui.all)
  rooms.ui.button = require('scripts/ui/button')
  rooms.ui.logo = require('scripts/ui/logo')()
  local x = sizes.position.x * 10
  local y = sizes.position.y * 23
  local py = sizes.position.y * 12
  rooms.ui.start = rooms.ui.button(x, y, phrases.startGame, function()
    return game.startGame("setName", "sdsds")
  end)
  rooms.ui.settings = rooms.ui.button(x, y + py, phrases.settings, function()
    return game.setRoom("settings")
  end)
  game.audio.menu:play()
  return rooms.ui.all:update()
end
