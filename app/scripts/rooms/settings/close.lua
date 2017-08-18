return function(nxt)
  if nxt ~= "menu" then
    return game.audio.menu.pause()
  end
end
