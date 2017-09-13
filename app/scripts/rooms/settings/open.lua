return function()
  rooms.ui = { }
  rooms.ui.station = { }
  rooms.ui.station.scale = sizes.scale / 2
  rooms.ui.station.x = sizes.width - (rooms.ui.station.scale * 1211)
  rooms.ui.station.y = sizes.height - (rooms.ui.station.scale * 427)
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
    if game.phrases.russian == game.phrases.current then
      return 1
    end
    if game.phrases.english == game.phrases.current then
      return 2
    end
  end)())
  rooms.ui.save = rooms.ui.button(x, y + py, phrases.saveSettings, function()
    if rooms.settings.llang ~= rooms.settings.lang then
      return game.setLanguage(unpack(rooms.settings.lang))
    end
  end, phrases.saveSettings2)
  rooms.ui.source = rooms.ui.button(x, y + py * 3, phrases.source, function()
    local succes = love.system.openURL(phrases.sourceLink)
    if succes then
      return love.window.minimize()
    end
  end)
  rooms.ui.backward = rooms.ui.button(x, y + py * 4, phrases.back, function()
    return game.setRoom(game.roomHistory[#game.roomHistory - 1])
  end)
  game.audio.menu:play()
  return rooms.ui.all:update()
end
