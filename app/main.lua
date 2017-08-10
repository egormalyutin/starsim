local dev_enable
dev_enable = function() end
local dev_disable
dev_disable = function() end
dev_enable()
local lovebird = require('scripts/debug/lovebird')
dev_disable()
local defaultSize
defaultSize = function()
  love.window.setFullscreen(1)
  local w, h = love.window.getMode()
  if w > 1366 or h > 768 then
    love.window.setFullscreen(0)
    love.window.setMode(1366, 768)
  end
  if game.room == "menu" then
    game.window.width, game.window.height = love.window.getMode()
    game.window.position = { }
    game.window.position.x = game.window.width / 100
    game.window.position.y = game.window.height / 100
    game.window.scale = game.window.width / 1366
    game.rooms.menu.logo = { }
    game.rooms.menu.logo.x = game.window.position.x * 5
    game.rooms.menu.logo.y = game.window.position.y * 5
    game.rooms.menu.logo.scale = game.window.scale * 0.8
    game.rooms.menu.buttons = {
      scale = game.window.scale * 0.8
    }
    game.rooms.menu.buttons.start = { }
    game.rooms.menu.buttons.start.x = game.window.position.x * 10
    game.rooms.menu.buttons.start.y = game.window.position.y * 20
  end
end
love.load = function()
  love.window.setTitle('STAR SIMULATOR')
  love.graphics.setBackgroundColor(0, 0, 0)
  game = {
    pressed = love.keyboard.isDown,
    draw = love.graphics.draw,
    image = love.graphics.newImage,
    font = love.graphics.newFont,
    setFont = love.graphics.setFont,
    text = love.graphics.print,
    textf = love.graphics.printf,
    Button = require("scripts/button"),
    room = "menu",
    window = { },
    rooms = {
      menu = {
        sky = {
          angle = love.math.random(0, 100)
        }
      }
    }
  }
  game.images = {
    sky = game.image("resources/images/starsky.png"),
    logo = game.image("resources/images/logomenu.png")
  }
  game.fonts = {
    menu = game.font("resources/fonts/menu.ttf", 50)
  }
  defaultSize()
  button = game.Button("lol", 200, 300)
end
love.update = function(dt)
  if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r') then
    game.room = "rooms"
  end
  if game.room == "menu" then
    game.rooms.menu.sky.angle = game.rooms.menu.sky.angle + 0.001
  end
end
love.draw = function()
  if game.room == "menu" then
    game.setFont(game.fonts.menu)
    game.draw(game.images.sky, game.window.width / 2, game.window.height / 2, game.rooms.menu.sky.angle, nil, nil, 1920, 1080)
    game.draw(game.images.logo, game.rooms.menu.logo.x, game.rooms.menu.logo.y, nil, game.rooms.menu.logo.scale)
    game.text("Начать игру", game.rooms.menu.buttons.start.x, game.rooms.menu.buttons.start.y, nil, game.rooms.menu.buttons.scale)
    button:draw()
  end
end
love.resize = defaultSize
