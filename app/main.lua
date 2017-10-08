local dev_enable
dev_enable = function() end
local dev_disable
dev_disable = function() end
dev_enable()
local lovebird = require('scripts.libs.lovebird')
dev_disable()
love.run = function()
  if love.math then
    love.math.setRandomSeed(os.time())
  end
  if love.load then
    love.load(arg)
  end
  if love.timer then
    love.timer.step()
  end
  local dt = 0
  while true do
    if love.event then
      love.event.pump()
      for name, a, b, c, d, e, f in love.event.poll() do
        if name == "quit" then
          if not love.quit or not love.quit() then
            return a
          end
        end
        love.handlers[name](a, b, c, d, e, f)
      end
    end
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end
    if love.update then
      love.update(dt)
    end
    if love.graphics and love.graphics.isActive() then
      love.graphics.clear(love.graphics.getBackgroundColor())
      love.graphics.origin()
      if love.preload and game.preloadProgress ~= 2 then
        love.preload()
      else
        if love.draw then
          love.draw()
        end
      end
      love.graphics.present()
    end
    if love.timer then
      love.timer.sleep(0.001)
    end
  end
end
local defaultSize
defaultSize = function()
  love.resize = nil
  local w, h = love.window.getDesktopDimensions()
  if w <= 1366 or h <= 768 then
    love.window.setMode(w, h, {
      fullscreen = true
    })
  end
  if w > 1366 or h > 768 then
    love.window.setMode(1366, 768, {
      centered = true
    })
  end
  sizes.width, sizes.height = love.window.getMode()
  sizes.position = { }
  sizes.position.x = math.floor(sizes.width / 100)
  sizes.position.y = math.floor(sizes.height / 100)
  sizes.scale = sizes.width / 1366
  sizes.scaleY = sizes.height / 768
  if not rooms.ui then
    rooms.ui = { }
  end
  game.fonts = {
    buttonSize = math.floor(sizes.scale * 50),
    logoSize = math.floor(sizes.scale * 100),
    playSize = math.floor(sizes.scale * 25),
    playLargeSize = math.floor(sizes.scale * 35),
    loveSize = math.floor(sizes.scale * 40),
    smallSize = math.floor(sizes.scale * 12),
    authorSize = math.floor(sizes.scale * 60)
  }
  game.fonts.menu = love.graphics.newFont("resources/fonts/menu.ttf", game.fonts.buttonSize)
  game.fonts.logo = love.graphics.newFont("resources/fonts/logo.ttf", game.fonts.logoSize)
  game.fonts.play = love.graphics.newFont("resources/fonts/play.ttf", game.fonts.playSize)
  game.fonts.playLarge = love.graphics.newFont("resources/fonts/play.ttf", game.fonts.playLargeSize)
  game.fonts.small = love.graphics.newFont("resources/fonts/play.ttf", game.fonts.smallSize)
  game.fonts.love = love.graphics.newFont("resources/fonts/love.woff", game.fonts.loveSize)
  game.fonts.author = love.graphics.newFont("resources/fonts/play.ttf", game.fonts.authorSize)
  game.preload = { }
  game.preload.printY = (sizes.height / 2) - (((game.fonts.love:getHeight() * 2) + 150) / 2)
  game.preload.y = game.preload.printY + game.fonts.love:getHeight() * 2
  game.preload.x = (sizes.width / 2) - (game.fonts.love:getWidth(phrases.poweredBy) / 2)
  game.preload.authorX = (sizes.width / 2) - (game.fonts.author:getWidth(phrases.author) / 2)
  game.preload.authorY = (sizes.height / 2) - (game.fonts.author:getHeight() / 2)
  love.resize = defaultSize
end
love.load = function()
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
    binser = require('scripts/libs/binser'),
    Audio = require('scripts/audio'),
    timer = require('scripts/libs/hump-timer'),
    musicTags = { },
    muted = true,
    saveData = {
      language = 'russian',
      sound = true
    },
    save = function()
      return love.filesystem.write(game.dataFile, (game.binser.s(game.saveData)))
    end,
    loadData = function()
      if love.filesystem.exists(game.dataFile) then
        local readed = love.filesystem.read(game.dataFile)
        game.saveData = game.binser.dn(readed)
      end
    end,
    dataFile = 'data.dat',
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
      game.ui.destroy(rooms.ui.all)
      game.ui.destroy(game.ui.elements)
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
      },
      play = {
        open = require('scripts/rooms/play/open'),
        close = function() end
      }
    },
    startGame = require('scripts/startGame'),
    phrases = require('scripts/phrases'),
    getLanguage = function()
      for name, value in pairs(game.phrases) do
        if value == phrases and name ~= 'current' then
          return name
        end
      end
    end,
    setLanguage = function(lang, room)
      game.phrases.current = lang
      local w = game.fonts.menu:getWidth(phrases.wait)
      local h = game.fonts.menu:getHeight()
      local x = (sizes.width / 2) - (w / 2)
      local y = (sizes.height / 2) - (h / 2)
      love.graphics.clear()
      love.graphics.origin()
      game.text(phrases.wait, x, y)
      love.graphics.present()
      for name, value in pairs(game.phrases) do
        if value == lang and name ~= 'current' then
          game.saveData.language = name
        end
      end
      game.save()
      return love.event.quit('restart')
    end,
    sizes = { },
    preloadProgress = 0
  }
  game.loadData()
  game.phrases.current = game.phrases[game.saveData.language]
  sizes = game.sizes
  phrases = game.phrases.current
  rooms = game.rooms
  love.window.setTitle(phrases.name)
  love.graphics.setBackgroundColor(0, 0, 0)
  love.window.setIcon(love.image.newImageData('resources/images/icon.png'))
  game.audio = {
    menu = game.Audio("music", "resources/audio/menu.mp3")
  }
  game.images = {
    sky = game.image("resources/images/starsky.png"),
    station = game.image("resources/images/station.png"),
    love = game.image("resources/images/powered-by.png")
  }
  defaultSize()
  game.setRoom(room or "menu")
  game.timer.after(5, function()
    game.preloadProgress = 1
  end)
  game.timer.after(8, function()
    game.preloadProgress = 2
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.origin()
    return love.graphics.present()
  end)
  game.ui.update(rooms.ui.all, nil, nil, 0)
end
love.preload = function()
  if game.preloadProgress == 0 then
    love.graphics.setFont(game.fonts.love)
    love.graphics.print(phrases.poweredBy, game.preload.x, game.preload.printY)
    love.graphics.draw(game.images.love, sizes.width / 2 - 236, game.preload.y)
  end
  if game.preloadProgress == 1 then
    love.graphics.setFont(game.fonts.author)
    return love.graphics.print(phrases.author, game.preload.authorX, game.preload.authorY)
  end
end
love.update = function(dt)
  if game.pressed('lctrl') and game.pressed('lshift') and game.pressed('r') then
    game.setRoom("menu")
  end
  if (game.room == "menu") or (game.room == "settings") then
    game.rooms.menu.sky.angle = game.rooms.menu.sky.angle + 0.001
    game.ui.update(game.rooms.ui.all)
  end
  if (game.room == "play") then
    game.ui.update(rooms.ui.all)
    if game.playing and not game.preloader then
      game.playing:update(dt)
    end
    if game.preloader then
      game.preloader:update()
    end
  end
  game.timer.update(dt)
  dev_enable()
  lovebird.update()
  return dev_disable()
end
love.draw = function()
  if (game.room == "menu") or (game.room == "settings") then
    game.setFont(game.fonts.logo)
    game.draw(game.images.sky, sizes.width / 2, sizes.height / 2, rooms.menu.sky.angle, nil, nil, 1920, 1080)
    game.draw(game.images.station, rooms.ui.station.x, rooms.ui.station.y, nil, rooms.ui.station.scale)
    game.ui.draw(rooms.ui.all)
  end
  if (game.room == "play") then
    if game.playing and not game.preloader then
      game.playing:draw()
    end
    game.ui.draw(rooms.ui.all)
    if game.preloader then
      game.preloader:draw()
    end
  end
  dev_enable()
  love.graphics.setFont(game.fonts.play)
  love.graphics.print(tostring(love.timer.getFPS()), 5, sizes.height - 25)
  return dev_disable()
end
love.resize = defaultSize
love.mousepressed = function()
  game.ui.mousepressed(rooms.ui.all)
  if game.playing and not game.preloader then
    return game.playing:mousepressed()
  end
end
love.mousereleased = function()
  game.ui.mousereleased(rooms.ui.all)
  if game.playing and not game.preloader then
    return game.playing:mousereleased()
  end
end
