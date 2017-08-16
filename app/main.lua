local dev_enable
dev_enable = function() end
local dev_disable
dev_disable = function() end
dev_enable()
local lovebird = require('scripts/libs/lovebird')
dev_disable()
local defaultSize
defaultSize = function()
  love.window.setFullscreen(1)
  local w, h = love.window.getMode()
  if w > 1366 or h > 768 then
    love.window.setFullscreen(0)
    love.window.setMode(1366, 768)
  end
  sizes.width, sizes.height = love.window.getMode()
  sizes.position = { }
  sizes.position.x = math.floor(sizes.width / 100)
  sizes.position.y = math.floor(sizes.height / 100)
  sizes.scale = sizes.width / 1366
  if game.room == "menu" then
    rooms.menu.ui = { }
    rooms.menu.ui.station = { }
    rooms.menu.ui.station.scale = sizes.scale / 2
    rooms.menu.ui.station.x = sizes.width - (rooms.menu.ui.station.scale * 1211)
    rooms.menu.ui.station.y = sizes.height - (rooms.menu.ui.station.scale * 427)
    game.fonts = {
      buttonSize = math.floor(sizes.scale * 50),
      logoSize = math.floor(sizes.scale * 100)
    }
    game.fonts.menu = love.graphics.newFont("resources/fonts/menu.ttf", game.fonts.buttonSize)
    game.fonts.logo = love.graphics.newFont("resources/fonts/logo.ttf", game.fonts.logoSize)
    rooms.menu.ui.all = game.ui.Filter({
      "menu"
    })
    game.ui.destroy(rooms.menu.ui.all)
    rooms.menu.ui.button = require('scripts/rooms/menu/button')
    rooms.menu.ui.logo = require('scripts/rooms/menu/logo')()
    rooms.menu.ui.start = rooms.menu.ui.button(sizes.position.x * 10, sizes.position.y * 23, phrases.startGame, function()
      return print("SET ROOM TO LEVELS")
    end)
    rooms.menu.ui.settings = rooms.menu.ui.button(sizes.position.x * 10, sizes.position.y * 35, phrases.settings, function()
      print("SET ROOM TO SETTINGS")
      return game.setRoom("settings")
    end)
    return rooms.menu.ui.all:update()
  end
end
love.load = function()
  love.window.setTitle('STAR SIMULATOR')
  love.graphics.setBackgroundColor(0, 0, 0)
  love.window.setIcon(love.image.newImageData('resources/images/icon.png'))
  game = {
    pressed = love.keyboard.isDown,
    draw = love.graphics.draw,
    image = love.graphics.newImage,
    font = love.graphics.newFont,
    setFont = love.graphics.setFont,
    text = love.graphics.print,
    textf = love.graphics.printf,
    rectangle = love.graphics.rectangle,
    font = love.graphics.setFont,
    color = love.graphics.setColor,
    ui = require('scripts/libs/ui'),
    room = "menu",
    roomHistory = {
      'menu'
    },
    setRoom = function(room)
      table.insert(game.roomHistory, room)
      game.room = room
    end,
    rooms = {
      menu = {
        sky = {
          angle = love.math.random(0, 100)
        }
      }
    },
    phrases = require('scripts/phrases'),
    sizes = { }
  }
  sizes = game.sizes
  phrases = game.phrases.current
  rooms = game.rooms
  game.images = {
    sky = game.image("resources/images/starsky.png"),
    logo = game.image("resources/images/logomenu.png"),
    station = game.image("resources/images/station.png")
  }
  defaultSize()
  game.ui.update(rooms.menu.ui.all)
end
love.update = function(dt)
  if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r') then
    game.room = "rooms"
  end
  if game.room == "menu" then
    game.rooms.menu.sky.angle = game.rooms.menu.sky.angle + 0.001
    return game.ui.update(game.rooms.menu.ui.all)
  end
end
love.draw = function()
  if game.room == "menu" then
    game.setFont(game.fonts.logo)
    game.draw(game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080)
    game.draw(game.images.station, rooms.menu.ui.station.x, rooms.menu.ui.station.y, nil, rooms.menu.ui.station.scale)
    return game.ui.draw(rooms.menu.ui.all)
  end
end
love.resize = defaultSize
love.mousepressed = function()
  return game.ui.mousepressed(rooms.menu.ui.all)
end
love.mousereleased = function()
  return game.ui.mousereleased(rooms.menu.ui.all)
end
