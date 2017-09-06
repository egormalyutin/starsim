return function()
  rooms.ui = { }
  rooms.ui.station = { }
  rooms.ui.station.scale = sizes.scale / 2
  rooms.ui.station.x = sizes.width - (rooms.ui.station.scale * 1211)
  rooms.ui.station.y = sizes.height - (rooms.ui.station.scale * 427)
  game.fonts = {
    buttonSize = math.floor(sizes.scale * 50),
    logoSize = math.floor(sizes.scale * 100)
  }
  game.fonts.menu = love.graphics.newFont("resources/fonts/menu.ttf", game.fonts.buttonSize)
  game.fonts.logo = love.graphics.newFont("resources/fonts/logo.ttf", game.fonts.logoSize)
  rooms.ui.all = game.ui.Filter({
    "menu"
  })
  game.ui.destroy(rooms.ui.all)
  rooms.ui.button = require('scripts/ui/button')
  rooms.ui.logo = require('scripts/ui/logo')()
  rooms.ui.select = require('scripts/ui/select')
  local x = sizes.position.x * 10
  local y = sizes.position.y * 23
  local py = sizes.position.y * 12
  local langs = {
    'РУССКИЙ',
    'ENGLISH'
  }
  rooms.settings.llang = {
    phrases,
    'settings'
  }
  rooms.settings.lang = rooms.settings.llang
  rooms.ui.backward = rooms.ui.select(x, y, phrases.setLanguage, langs, function(num)
    local _exp_0 = num
    if 1 == _exp_0 then
      rooms.settings.lang = {
        game.phrases.russian,
        'settings'
      }
    elseif 2 == _exp_0 then
      rooms.settings.lang = {
        game.phrases.english,
        'settings'
      }
    end
  end, (function()
    do
      game.phrases.russian = game.phrases.current
      if game.phrases.russian then
        return 1
      end
    end
    do
      game.phrases.english = game.phrases.current
      if game.phrases.english then
        return 2
      end
    end
  end)())
  rooms.ui.save = rooms.ui.button(x, y + py, phrases.saveSettings, function()
    if rooms.settings.llang ~= rooms.settings.lang then
      return game.setLanguage(unpack(rooms.settings.lang))
    end
  end, phrases.saveSettings2)
  rooms.ui.backward = rooms.ui.button(x, y + py * 3, phrases.backward, function()
    return game.setRoom(game.roomHistory[#game.roomHistory - 1])
  end)
  game.audio.menu:play()
  return rooms.ui.all:update()
end