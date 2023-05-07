local NetworkIsPlayerActive <const> = NetworkIsPlayerActive

CreateThread(function()
    while not sl.cache.playerid and not NetworkIsPlayerActive(supv.cache.playerid) do Wait(0) end
    sl.onNet('playerLoaded')
end)

sl.onNet('playerLoaded', function(...)
    print('playerLoaded', ...)
end)