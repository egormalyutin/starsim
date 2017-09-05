return function(nxt)
  if nxt ~= "settings" then
    return game.audio.menu:pause()
  end
end
