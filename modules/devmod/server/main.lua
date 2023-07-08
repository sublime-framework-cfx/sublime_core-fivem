RegisterCommand('save', function(source)
    local player <const> = sl.getPlayerFromId(source)
    player:save(player.char)
end)