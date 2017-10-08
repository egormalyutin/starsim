return function(mode, content)
  if mode == nil then
    mode = (error('Mode is nil'))
  end
  if content == nil then
    content = (error('Content is nil'))
  end
  local rawModes = love.filesystem.getDirectoryItems('modes')
  local modes = { }
  for name, path in pairs(rawModes) do
    modes[path] = require('modes/' .. path)
  end
  if not modes[mode] then
    error('Mode "' .. mode .. '" not exists')
  end
  if not modes[mode][game.getLanguage()] then
    print('Mode "' .. mode .. '" for your language not exists. Using english...')
  end
  local md = modes[mode][game.getLanguage()]
  game.setRoom('play')
  local Cls = md.new
  local ui = { }
  ui.element = function(s)
    local elem = game.ui.Element(s)
    elem.ty = sizes.scaleY * 50
    elem:reshape()
    return elem
  end
  ui.button = function(text, x, y, pressed, border)
    local elem = nil
    if border then
      elem = game.ui.Element({
        draw = function(self)
          if self.hover then
            game.color(255, 255, 255, 150)
          else
            game.color(255, 255, 255, 255)
          end
          love.graphics.rectangle('line', 0, 0, self.width, self.height)
          love.graphics.setFont(game.fonts.play)
          return love.graphics.print(self._text, 3, 3)
        end,
        tags = {
          'game'
        },
        x = x,
        y = y,
        width = (game.fonts.play:getWidth(text)) + 6,
        height = (game.fonts.play:getHeight()) + 6,
        mousereleased = pressed
      })
    else
      elem = game.ui.Element({
        draw = function(self)
          if self.hover then
            game.color(255, 255, 255, 150)
          else
            game.color(255, 255, 255, 255)
          end
          love.graphics.setFont(game.fonts.play)
          return love.graphics.print(self._text)
        end,
        tags = {
          'game'
        },
        x = x,
        y = y,
        z = 1,
        width = (game.fonts.play:getWidth(text)),
        height = (game.fonts.play:getHeight()),
        mousereleased = pressed
      })
    end
    elem._text = text
    elem.setText = function(self, text)
      self._text = text
      self.width = game.fonts.play:getWidth(text)
      return self:reshape()
    end
    elem.getText = function(self)
      return self._text
    end
    rooms.ui.all:update()
    return elem
  end
  ui.getSize = function(ww, wh, w, h)
    local scale = 1
    if ww < w then
      if scale > ww / w then
        scale = ww / w
      end
    end
    if wh < h then
      if scale > wh / h then
        scale = wh / h
      end
    end
    return w * scale, h * scale, scale
  end
  ui.getScale = function(ww, wh, w, h)
    local scale = 1
    if ww < w then
      if scale > ww / w then
        scale = ww / w
      end
    end
    if wh < h then
      if scale > wh / h then
        scale = wh / h
      end
    end
    return scale
  end
  ui.line = function(x, y)
    local line = game.ui.Element({
      draw = function(self)
        game.color(255, 255, 255, 255)
        return love.graphics.line(0, 0, 0, self.height)
      end,
      tags = {
        'game'
      },
      x = x,
      y = y,
      z = 1,
      width = 1,
      height = ui.bar.height / 2
    })
    return line
  end
  ui.bar = (function(self)
    local bar = game.ui.Element({
      draw = function(self)
        love.graphics.setScissor(self.x, self.y, self.width, self.height)
        if self.data.alpha < 255 then
          love.graphics.setColor(255, 255, 255, 255)
          love.graphics.draw(game.images.sky, sizes.width / 2, sizes.height / 2, self.data.angle, nil, nil, 1920, 1080)
        end
        love.graphics.setScissor()
        love.graphics.setColor(0x19, 0x1B, 0x1F, self.data.alpha)
        love.graphics.rectangle('fill', 0, 0, self.width, self.height - 1)
        love.graphics.setColor(255, 255, 255, 255)
        return love.graphics.line(0, self.height, self.width, self.height)
      end,
      update = function(self)
        self.data.angle = self.data.angle + 0.0005
      end,
      tags = {
        'game'
      },
      data = {
        angle = 0,
        alpha = 255,
        height = sizes.scaleY * 50
      },
      x = 0,
      y = 0,
      z = 0,
      width = sizes.width,
      height = sizes.scaleY * 50
    })
    return bar
  end)()
  ui.height = sizes.height - sizes.scaleY * 50
  ui.width = sizes.width
  ui.bar.separatorWidth = sizes.scale * 10
  ui.bar.elements = {
    {
      x = 0,
      width = 0
    }
  }
  ui.bar.updatePositions = function()
    local last = nil
    for _, elem in pairs(ui.bar.elements) do
      if last == nil then
        elem.x = 0
        last = elem
        if elem.reshape then
          elem:reshape()
        end
      else
        if elem ~= nil then
          elem.x = last.x + last.width + ui.bar.separatorWidth
          elem.y = ui.bar.data.height / 2 - (elem.height / 2)
          last = elem
          if elem.reshape then
            elem:reshape()
          end
        else
          table.remove(ui.bar.elements, _)
        end
      end
    end
  end
  ui.bar.button = function(text, pressed, last)
    local lastElem = ui.bar.elements[#ui.bar.elements]
    local elem = (ui.button(text, 0, 0, pressed))
    table.insert(ui.bar.elements, elem)
    local line
    if not last then
      line = (ui.line())
    end
    if not last then
      table.insert(ui.bar.elements, line)
    end
    ui.bar.updatePositions()
    elem._setText = elem.setText
    elem.setText = function(self, text)
      elem:_setText(text)
      return ui.bar.updatePositions()
    end
    return elem, line
  end
  ui.bar.remove = function(elem)
    for name, value in pairs(ui.bar.elements) do
      if value == elem then
        table.remove(ui.bar.elements, name)
      end
    end
  end
  ui.bar.free = function()
    local e = ui.bar.elements[#ui.bar.elements]
    return sizes.width - e.x + e.width
  end
  ui.bar.prevButton = function(pressed)
    local elem = game.ui.Element({
      draw = function(self)
        if self.hover then
          game.color(255, 255, 255, 150)
        else
          game.color(255, 255, 255, 255)
        end
        love.graphics.setFont(game.fonts.play)
        return love.graphics.print("<", 0, 0)
      end,
      tags = {
        'game',
        'select'
      },
      x = x,
      y = y,
      width = (game.fonts.play:getWidth("<")),
      height = (game.fonts.play:getHeight()),
      mousereleased = pressed
    })
    local _ = elem
    table.insert(ui.bar.elements, elem)
    return ui.bar.updatePositions()
  end
  ui.bar.nextButton = function(pressed)
    local elem = game.ui.Element({
      draw = function(self)
        if self.hover then
          game.color(255, 255, 255, 150)
        else
          game.color(255, 255, 255, 255)
        end
        love.graphics.setFont(game.fonts.play)
        return love.graphics.print(">", 0, 0)
      end,
      tags = {
        'game',
        'select'
      },
      width = (game.fonts.play:getWidth(">")),
      height = (game.fonts.play:getHeight()),
      mousereleased = pressed
    })
    local _ = elem
    table.insert(ui.bar.elements, elem)
    rooms.ui.all:update()
    return ui.bar.updatePositions()
  end
  ui.bar.select = function(variants, changed, free, current)
    if variants == nil then
      variants = {
        ""
      }
    end
    if changed == nil then
      changed = function() end
    end
    local res = { }
    local con = false
    if type(free) == 'function' then
      free = free()
    end
    if type(free) ~= 'function' then
      free = free
    end
    if type(free) == 'nil' then
      free = ui.bar.free()
    end
    local pos = 1
    local slice
    slice = function(tbl, p1, p2)
      local result = { }
      while p1 <= p2 do
        table.insert(res, tbl[p1])
        p1 = p1 + 1
      end
      return result
    end
    local getWidth
    getWidth = function(text)
      return game.fonts.play:getWidth(text)
    end
    local page
    page = function(tbl, plus)
      local res
      res = 0
      for _index_0 = 1, #tbl do
        local str = tbl[_index_0]
        res = res + getWidth(str)
        res = res + plus
      end
      return res
    end
    local pageM
    pageM = function(tbl, plus)
      local res
      res = page(tbl, plus)
      res = res - plus
      return res
    end
    local clone
    clone = function(tbl)
      local cloned = { }
      for name, value in ipairs(tbl) do
        cloned[name] = value
      end
      return cloned
    end
    local i = 1
    local push
    push = function()
      i = i + 1
      if not res[i] then
        res[i] = { }
      end
    end
    local separator = ui.bar.separatorWidth * 2 + 1
    local elem
    elem = function(text, last)
      local ret = game.ui.Element({
        draw = function(self)
          if self.hover then
            game.color(255, 255, 255, 150)
          else
            game.color(255, 255, 255, 255)
          end
          love.graphics.setFont(game.fonts.play)
          return love.graphics.print(self._text, 0, 0)
        end,
        tags = {
          'game',
          'select-bar'
        },
        width = (game.fonts.play:getWidth(text)),
        height = (game.fonts.play:getHeight()),
        mousereleased = changed
      })
      table.insert(ui.bar.elements, ret)
      local line = nil
      if not last then
        line = ui.line()
        table.insert(ui.bar.elements, line)
        table.insert(line.tags, "select-bar")
      end
      ret._text = text
      return ret, line
    end
    for name, item in ipairs(variants) do
      local larger
      if not res[i] then
        res[i] = { }
      end
      table.insert(res[i], item)
      if pageM(res[i], separator) > free then
        table.remove(res[i], #res[i])
        push()
      end
      if (pageM({
        item
      }, separator) > free) then
        table.insert(res[i], item)
      end
    end
    local filter = game.ui.Filter({
      'select-bar'
    })
    local destroy
    destroy = function()
      return game.ui.destroy(filter)
    end
    local update = nil
    local lastPage
    lastPage = function()
      if pos - 1 >= 1 then
        pos = pos - 1
        return update()
      end
    end
    local nextPage
    nextPage = function()
      if pos + 1 <= #res then
        pos = pos + 1
        return update()
      end
    end
    update = function()
      destroy()
      local lastButton = ui.bar.prevButton(function()
        return lastPage()
      end)
      for name, value in ipairs(res[pos]) do
        if name == #res[5] then
          elem(value, true)
        else
          elem(value)
        end
      end
      local nextButton = ui.bar.nextButton(function()
        return nextPage()
      end)
      filter:update()
      return ui.bar:updatePositions()
    end
    return update()
  end
  ui.bar.selectOne = function(variants, changed)
    if variants == nil then
      variants = {
        ""
      }
    end
    local res = { }
    res.variants = variants
    res.changed = changed or function() end
    res.current = 1
    res.next = function()
      if (res.current + 1) <= #res.variants then
        res.current = res.current + 1
        res.text.width = game.fonts.play:getWidth(res.variants[res.current])
        ui.bar.updatePositions()
        return res.changed(res.current, res.variants[res.current])
      end
    end
    res.prev = function()
      if (res.current - 1) >= 1 then
        res.current = res.current - 1
        res.text.width = game.fonts.play:getWidth(res.variants[res.current])
        ui.bar.updatePositions()
        return res.changed(res.current, res.variants[res.current])
      end
    end
    res.prevButton = ui.bar.prevButton(function()
      return res.prev()
    end)
    res.text = game.ui.Element({
      draw = function(self)
        love.graphics.setFont(game.fonts.play)
        return love.graphics.print(res.variants[res.current], 0, 0)
      end,
      tags = {
        'game',
        'select'
      },
      width = (game.fonts.play:getWidth(res.variants[1])),
      height = (game.fonts.play:getHeight()),
      mousereleased = pressed
    })
    table.insert(ui.bar.elements, res.text)
    res.nextButton = ui.bar.nextButton(function()
      return res.next()
    end)
    ui.bar.updatePositions()
    res.group = game.ui.Filter({
      'select'
    })
    res.destroy = function()
      return game.ui.destroy(res.group)
    end
    return res
  end
  local preloaderLines = (select(2, md.description:gsub("\n", "\n"))) + 1
  local preloaderDescription = md.description
  local preloaderName = phrases.mode .. md.name
  game.preloader = game.ui.Element({
    draw = function(self)
      love.graphics.setColor(0, 0, 0, self.data.alpha)
      love.graphics.rectangle('fill', 0, 0, sizes.width, sizes.height)
      love.graphics.setColor(255, 255, 255, self.data.alpha)
      love.graphics.setFont(game.fonts.playLarge)
      love.graphics.print(preloaderName, sizes.position.y * 10 - self.data.name, sizes.height - (sizes.position.y * 20) - self.data.nh)
      love.graphics.setFont(game.fonts.play)
      return love.graphics.print(preloaderDescription, sizes.position.y * 10 - self.data.text, sizes.height - (sizes.position.y * 10) - (self.data.th * preloaderLines))
    end,
    z = 3,
    data = {
      alpha = 0,
      text = game.fonts.play:getWidth(preloaderDescription),
      name = game.fonts.play:getWidth(preloaderName),
      th = game.fonts.play:getHeight(),
      nh = game.fonts.playLarge:getHeight()
    },
    tags = {
      'preloader'
    }
  })
  game.timer.tween(0.7, game.preloader.data, {
    alpha = 255
  }, 'in-out-linear')
  game.timer.tween(1.5, game.preloader.data, {
    text = 0
  }, 'out-quad')
  game.timer.tween(1.5, game.preloader.data, {
    name = 0
  }, 'out-quad')
  rooms.ui.all = game.ui.Filter({
    'preloader'
  })
  local results
  results = function(proc)
    local text = "Вы выполнили задание на " .. proc .. "%!"
    local w = game.fonts.play:getWidth(text)
    love.graphics.clear()
    love.graphics.origin()
    love.graphics.print(text, sizes.width / 2 - w / 2, sizes.height / 2)
    love.graphics.present()
    return love.timer.sleep(5)
  end
  game.playing = Cls(ui, content, results)
  game.playing.paused = false
  game.playing.pause = function()
    ui.playButton:setText(phrases.resume)
    game.timer.tween(0.7, ui.bar, {
      height = sizes.height + 1
    }, 'out-quad')
    return game.timer.tween(0.7, ui.bar.data, {
      alpha = 0
    }, 'out-quad')
  end
  game.playing.play = function()
    ui.playButton:setText(phrases.pause)
    game.timer.tween(0.7, ui.bar, {
      height = sizes.scaleY * 50
    }, 'out-quad')
    return game.timer.tween(0.7, ui.bar.data, {
      alpha = 255
    }, 'out-quad')
  end
  game.playing.toggle = function()
    if game.playing.paused then
      game.playing.play()
      game.playing.paused = false
    else
      game.playing.pause()
      game.playing.paused = true
    end
  end
  ui.playButton = ui.bar.button(phrases.pause, function()
    return game.playing.toggle()
  end)
  game.playing:start()
  return game.timer.after(5, function(self)
    rooms.ui.all = game.ui.Filter({
      'game',
      'preloader'
    })
    return game.timer.tween(0.3, game.preloader.data, {
      alpha = 0
    }, 'in-out-linear', function()
      game.ui.destroy(game.preloader)
      game.preloader = nil
    end)
  end)
end
