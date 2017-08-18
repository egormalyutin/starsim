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
  if rooms[game.room] then
    if rooms[game.room].open then
      return rooms[game.room].open(game.room)
    end
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
    play = love.audio.play,
    pause = love.audio.pause,
    audio = love.audio.newSource,
    ui = require('scripts/libs/ui'),
    Audio = require('scripts/audio'),
    room = "empty",
    roomHistory = {
      'menu'
    },
    setRoom = function(room)
      if rooms[game.room] then
        if rooms[game.room].close then
          rooms[game.room].close(room)
        end
      end
      table.insert(game.roomHistory, room)
      game.room = room
      if rooms[room] then
        if rooms[room].open then
          return rooms[room].open(game.room)
        end
      end
    end,
    rooms = {
      menu = {
        sky = {
          angle = love.math.random(0, 100)
        },
        open = require('scripts/rooms/menu/open'),
        close = require('scripts/rooms/menu/close')
      },
      settings = {
        open = require('scripts/rooms/settings/open'),
        close = require('scripts/rooms/settings/close')
      }
    },
    phrases = require('scripts/phrases'),
    sizes = { }
  }
  sizes = game.sizes
  phrases = game.phrases.current
  rooms = game.rooms
  game.audio = {
    menu = game.Audio("resources/audio/menu.mp3")
  }
  game.images = {
    sky = game.image("resources/images/starsky.png"),
    logo = game.image("resources/images/logomenu.png"),
    station = game.image("resources/images/station.png")
  }
  defaultSize()
  game.setRoom("menu")
  game.ui.update(rooms.ui.all)
end
love.update = function(dt)
  if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r') then
    game.setRoom("menu")
  end
  if (game.room == "menu") or (game.room == "settings") then
    game.rooms.menu.sky.angle = game.rooms.menu.sky.angle + 0.001
    game.ui.update(game.rooms.ui.all)
  end
  dev_enable()
  lovebird.update()
  return dev_disable()
end
love.draw = function()
  if (game.room == "menu") or (game.room == "settings") then
    game.setFont(game.fonts.logo)
    game.draw(game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080)
    game.draw(game.images.station, rooms.ui.station.x, rooms.ui.station.y, nil, rooms.ui.station.scale)
    return game.ui.draw(rooms.ui.all)
  end
end
love.resize = defaultSize
love.mousepressed = function()
  return game.ui.mousepressed(rooms.ui.all)
end
love.mousereleased = function()
  return game.ui.mousereleased(rooms.ui.all)
end
