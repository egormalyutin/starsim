return function(mode, content)
  if mode == nil then
    mode = (error('Mode is nil'))
  end
  if content == nil then
    content = (error('Content is nil'))
  end
  local rawModes = require('modes/list')
  local modes = { }
  for name, path in pairs(rawModes) do
    modes[name] = require('modes/' .. path)
  end
  if not modes[mode] then
    error('Mode "' .. mode .. '" wasn\'t founded')
  end
  game.setRoom('play')
  local Cls = modes[mode]
  game.playing = Cls(content)
  game.playing.update = game.playing.update or function() end
  game.playing.draw = game.playing.draw or function() end
end
